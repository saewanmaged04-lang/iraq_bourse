// lib/screens/main_navigation.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global_state.dart';
import '../models/office_model.dart';
import '../widgets/auth_sheets.dart';
import 'cities_screen.dart';
import 'currencies_screen.dart';
import 'calculator_screen.dart';
import 'offices_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final ScrollController _citiesScrollController = ScrollController();
  
  late AnimationController _refreshRotationController;
  late Timer _refreshTimer;

  // --- داتای بۆرسەی شارەکان (سەرچاوەی لایڤی نرخەکان بۆ حاسیبە) ---
  final List<Map<String, String>> pinnedRates = [
    {'city': 'بەغداد', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'city': 'سلێمانی', 'buy': '١٥٣,٦٥٠', 'sell': '١٥٤,٨٠٠', 'status': 'neutral'},
    {'city': 'هەولێر', 'buy': '١٥٣,٦٦٠', 'sell': '١٥٣,٩٥٠', 'status': 'up'},
  ];

  final List<Map<String, String>> cities = [
    {'name': 'هەولێر', 'buy': '١٥٣,٧٥٠', 'sell': '١٥٤,١٠٠', 'status': 'up'},
    {'name': 'سلێمانی', 'buy': '١٥٣,٨٠٠', 'sell': '١٥٤,٨٠٠', 'status': 'neutral'},
    {'name': 'بەغداد (کِفاح)', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'neutral'},
    {'name': 'کەڕادە', 'buy': '١٥٤,٠٠٠', 'sell': '١٥٤,٤٠٠', 'status': 'up'},
    {'name': 'حاریشیە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٥٠', 'status': 'neutral'},
    {'name': 'کەرکوک', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'down'},
    {'name': 'دهۆک', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٠٠', 'status': 'neutral'},
    {'name': 'نەجەف', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'name': 'بەسرە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'down'},
  ];

  // --- گۆڕاوەکانی باری حاسیبە ---
  String _fromAmount = '100';
  String _toAmount = '';
  String _fromCurrencySelected = 'دۆلار USD';
  String _toCurrencySelected = 'دینار IQD';
  String _activeField = 'amount';
  String _amountVal = '';
  String _buyPriceVal = '';
  String _sellPriceVal = '';
  String _commissionVal = '0';
  String _selectedCurrency = 'دۆلار USD';
  Map<String, dynamic>? _profitResult;

  // --- لۆجیکی هۆشمەند بۆ بەستنەوەی حاسیبە بە بۆرسە و بانکی ناوەندی ---
  double _parseRate(String rateStr) {
    String clean = rateStr.replaceAll(',', '').replaceAll(' ', '');
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      clean = clean.replaceAll(eastern[i], western[i]);
    }
    return (double.tryParse(clean) ?? 154000.0) / 100.0;
  }

  double _getCurrentBaseUSDValue() {
    if (isAutoRateGlobal) {
      return _parseRate(cities[1]['sell']!); // بۆرسەی سلێمانی کاتێک ئۆتۆماتیکە
    }
    if (selectedBaseRateSourceGlobal == 'Central Bank') {
      return usdToIqdCentralBankRate / 100.0;
    }
    String cityName = (selectedBaseRateSourceGlobal == 'Baghdad Bourse') 
        ? 'بەغداد (کِفاح)' : 'سلێمانی';

    final cityData = cities.firstWhere((c) => c['name'] == cityName, orElse: () => cities[1]);
    return _parseRate(cityData['sell']!);
  }

  Map<String, double> get _rateToIQD {
    double base = _getCurrentBaseUSDValue() * 100;
    activeBaseUsdToIqdRate = base; // نوێکردنەوەی جیهانی بۆ پیشاندانی نرخ
    return {
      'دۆلار USD': base,
      'دینار IQD': 1.0,
      'تمەن IRR': base / 62000.0,
      'یۆرۆ EUR': base / 0.915,
      'پاوەند GBP': base / 0.794,
    };
  }

  void _calculateConversionFromStr() {
    setState(() {
      final double v = double.tryParse(_fromAmount.replaceAll(',', '')) ?? 0.0;
      double fromRate = _rateToIQD[_fromCurrencySelected] ?? 1.0;
      double toRate = _rateToIQD[_toCurrencySelected] ?? 1.0;
      double result = (v * fromRate) / toRate;
      _toAmount = (_toCurrencySelected == 'تمەن IRR' || _toCurrencySelected == 'دینار IQD') 
          ? result.toStringAsFixed(0) : result.toStringAsFixed(2);
    });
  }

  void _calculateProfit() {
    final double amount = double.tryParse(_amountVal.replaceAll(',', '')) ?? 0.0;
    final double buyPrice = double.tryParse(_buyPriceVal.replaceAll(',', '')) ?? 0.0;
    final double sellPrice = double.tryParse(_sellPriceVal.replaceAll(',', '')) ?? 0.0;
    if (amount <= 0 || buyPrice <= 0 || sellPrice <= 0) return;
    
    double rate = _rateToIQD[_selectedCurrency] ?? (activeBaseUsdToIqdRate);
    double amountInIQD = amount * rate;
    double units = amountInIQD / buyPrice;
    double totalSell = units * sellPrice;
    double commission = double.tryParse(_commissionVal) ?? 0.0;
    double commAmount = amountInIQD * (commission / 100);
    double profitIQD = totalSell - amountInIQD - commAmount;

    setState(() {
      _profitResult = {
        'profitIQD': profitIQD, 'profitCurrency': profitIQD / rate,
        'profitPercent': (profitIQD / amountInIQD) * 100, 'totalSell': totalSell,
        'isProfit': profitIQD >= 0, 'currency': _selectedCurrency, 'commissionAmount': commAmount,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshRotationController = AnimationController(duration: const Duration(seconds: 5), vsync: this)..repeat();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) => _triggerRefresh());
    _calculateConversionFromStr();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _refreshRotationController.dispose();
    _tabController.dispose();
    _citiesScrollController.dispose();
    super.dispose();
  }

  void _triggerRefresh() {
    setState(() {
      _calculateConversionFromStr();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(children: [_buildHeader(), _buildBreakingNewsBanner(), Expanded(child: _buildCurrentScreen())])),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(color: Color(0xFF0F172A), border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1))),
      child: Stack(alignment: Alignment.center, children: [
        Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); setState(() {}); }, child: Row(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF0072FF).withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00C6FF).withOpacity(0.35))), child: const Icon(Icons.settings_rounded, color: Color(0xFF00C6FF), size: 14)), const SizedBox(width: 6), Text(getTxt('settings_title'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8)))]))),
        Center(child: Text(getTxt('app_subtitle'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5))),
        Align(alignment: Alignment.centerRight, child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.calendar_month_rounded, size: 10, color: Color(0xFF00C6FF)), const SizedBox(width: 3), Text(formatDisplayNumbers('٦/٦/٢٠٢٦'), style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700))]), const SizedBox(height: 1), Text(appLanguageGlobal == 'English' ? 'Saturday • 12:00 AM' : (appLanguageGlobal == 'العربية' ? 'السبت • ١٢:٠٠ ص' : 'شەممە • ١٢:٠٠ پ.ن'), style: const TextStyle(fontSize: 8, color: Color(0xFF4ADE80), fontWeight: FontWeight.w600))])),
      ]),
    );
  }

  Widget _buildBreakingNewsBanner() {
    return Container(
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(children: [
        const Icon(Icons.campaign_rounded, color: Colors.orangeAccent, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(appLanguageGlobal == 'English' ? 'News: Rates updated.' : 'هەواڵ: نرخەکان نوێکرانەوە.', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        GestureDetector(onTap: _triggerRefresh, child: Stack(alignment: Alignment.center, children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00C6FF).withOpacity(0.12)), value: 1.0)), RotationTransition(turns: _refreshRotationController, child: const Icon(Icons.sync_rounded, color: Color(0xFF76C917), size: 14))])),
      ]),
    );
  }

  Widget _buildBottomNav() {
    return Directionality(textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl, child: BottomNavigationBar(backgroundColor: const Color(0xFF0F172A), currentIndex: _selectedIndex, selectedItemColor: Colors.blueAccent, unselectedItemColor: Colors.grey, onTap: (i) => setState(() => _selectedIndex = i), type: BottomNavigationBarType.fixed, selectedFontSize: 10, unselectedFontSize: 10, items: [BottomNavigationBarItem(icon: const Icon(Icons.trending_up), label: getTxt('cities_tab')), BottomNavigationBarItem(icon: const Icon(Icons.currency_exchange), label: getTxt('currencies_tab')), BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: getTxt('calculator_tab')), BottomNavigationBarItem(icon: const Icon(Icons.store_rounded), label: getTxt('offices_tab'))]));
  }

  List<Map<String, dynamic>> getDynamicCurrencyData() {
    double base = _getCurrentBaseUSDValue();
    return [
      {'name': 'دینار عێراقی', 'code': 'IQD', 'flag': '🇮🇶', 'price': base * 100, 'color': const Color(0xFF00C6FF)},
      {'name': 'تمەنی ئێرانی', 'code': 'IRR', 'flag': '🇮🇷', 'price': (1000000 / 62000.0) * base * 100, 'color': const Color(0xFFFF4D4D)},
      {'name': 'پاوەندی بەریتانی', 'code': 'GBP', 'flag': '🇬🇧', 'price': (100 / 0.794) * base, 'color': const Color(0xFF22C55E)},
      {'name': 'یۆرۆی ئەورووپی', 'code': 'EUR', 'flag': '🇪🇺', 'price': (100 / 0.915) * base, 'color': const Color(0xFFEAB308)},
    ];
  }

  Widget _buildCurrentScreen() {
    Widget child;
    switch (_selectedIndex) {
      case 0:
        child = isCitiesLockedGlobal ? _buildLockedScreen(getTxt('cities_tab')) : CitiesScreen(pinnedRates: pinnedRates, cities: cities, citiesScrollController: _citiesScrollController, onPinUpdated: (idx, c, b, s, st) { setState(() => pinnedRates[idx] = {'city': c, 'buy': b, 'sell': s, 'status': st}); }, onSwap: (f, t) { setState(() { final temp = cities[f]; cities[f] = cities[t]; cities[t] = temp; }); });
        break;
      case 1:
        child = isCurrenciesLockedGlobal ? _buildLockedScreen(getTxt('currencies_tab')) : CurrenciesScreen(currencyData: getDynamicCurrencyData(), formatPrice: (p) => p.toString());
        break;
      case 2:
        child = CalculatorScreen(
          tabController: _tabController,
          availableCurrencies: const ['دۆلار USD', 'دینار IQD', 'تمەن IRR', 'یۆرۆ EUR', 'پاوەند GBP'],
          rateToIQD: _rateToIQD,
          fromAmount: _fromAmount,
          toAmount: _toAmount,
          fromCurrencySelected: _fromCurrencySelected,
          toCurrencySelected: _toCurrencySelected,
          amountVal: _amountVal,
          buyPriceVal: _buyPriceVal,
          sellPriceVal: _sellPriceVal,
          commissionVal: _commissionVal,
          selectedCurrency: _selectedCurrency,
          profitResult: _profitResult,
          activeField: _activeField,
          onKeyTap: (key) {
            setState(() {
              String current = _amountVal.replaceAll(',', '');
              if (key == '⌫') { if (current.isNotEmpty) current = current.substring(0, current.length - 1); }
              else if (key == 'C') { current = ''; _profitResult = null; }
              else { if (current.length < 12) current += key; }
              _amountVal = current;
              _calculateProfit();
            });
          },
          onConverterTap: (key) {
            setState(() {
              String current = _fromAmount.replaceAll(',', '');
              if (key == '⌫') { if (current.isNotEmpty) current = current.substring(0, current.length - 1); if (current.isEmpty) current = '0'; }
              else if (key == 'C') { current = '0'; }
              else { if (current.length < 12) current += key; }
              _fromAmount = current;
              _calculateConversionFromStr();
            });
          },
          onCalculateProfit: _calculateProfit,
          onConverterFieldsChanged: (curr, rate, isFrom) {
            setState(() { if (isFrom) _fromCurrencySelected = curr; else _toCurrencySelected = curr; _calculateConversionFromStr(); });
          },
          onProfitCurrencyChanged: (curr) { setState(() { _selectedCurrency = curr; _calculateProfit(); }); },
          onFieldTapped: (field, val) { setState(() { _activeField = field; }); },
        );
        break;
      default: child = OfficesScreen(offices: allOffices);
    }

    if (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3) {
      return RefreshIndicator(backgroundColor: const Color(0xFF131C2E), color: const Color(0xFF76C917), onRefresh: () async { _triggerRefresh(); await Future.delayed(const Duration(milliseconds: 1000)); }, child: child);
    }
    return child;
  }

  Widget _buildLockedScreen(String sectionName) {
    return Center(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), child: Container(constraints: const BoxConstraints(maxWidth: 320), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), decoration: BoxDecoration(color: const Color(0xFF131724), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 1)]), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFC59A5C).withOpacity(0.25), width: 2), boxShadow: [BoxShadow(color: const Color(0xFFC59A5C).withOpacity(0.12), blurRadius: 35, spreadRadius: 4)]), child: ClipOval(child: Image.asset('assets/fanus.png', width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.hourglass_empty_rounded, size: 56, color: Color(0xFFC59A5C))))), const SizedBox(height: 24), Text(getTxt('locked_title'), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFFC59A5C))), const SizedBox(height: 12), Text(getTxt('locked_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7), height: 1.6, fontWeight: FontWeight.w600)), const SizedBox(height: 24), SizedBox(width: double.infinity, child: Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0xFFB83939).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 3))]), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB83939), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 0), onPressed: () { showRegisterPhoneBottomSheet(context, onStateChanged: () { setState(() {}); }); }, child: Text(getTxt('lock_create_account_btn'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5)))))]))));
  }
}