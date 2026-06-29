// ignore_for_file: deprecated_member_use
// lib/screens/main_navigation.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // هاوردەکردنی url_launcher
import '../global_state.dart';
import '../models/office_model.dart';
import '../widgets/auth_sheets.dart';
import 'cities_screen.dart';
import 'currencies_screen.dart';
import 'calculator_screen.dart';
import 'market_analysis_screen.dart';
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

  // --- داتای بۆرسەی شارەکان (ئەم نرخە لێرە بگۆڕە، حاسیبەکە خۆی دەیخوێنێتەوە) ---
  final List<Map<String, String>> pinnedRates = [
    {'city': 'بەغداد', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'city': 'سلێمانی', 'buy': '١٥٣,٦٥٠', 'sell': '١٥٤,٠٠٠', 'status': 'neutral'},
    {'city': 'هەولێر', 'buy': '١٥٣,٦٦٠', 'sell': '١٥٣,٩٥٠', 'status': 'up'},
  ];

  final List<Map<String, String>> cities = [
    {'name': 'هەولێر', 'buy': '١٥٣,٧٥٠', 'sell': '١٥٤,١٠٠', 'status': 'up'},
    {'name': 'سلێمانی', 'buy': '١٥٣,٨٠٠', 'sell': '١٥٤,٨٠٠', 'status': 'neutral'}, // نرخ لە سلێمانی کراوەتە ١٥٤,٨٠٠
    {'name': 'بەغداد (کِفاح)', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'neutral'},
    {'name': 'کەڕادە', 'buy': '١٥٤,٠٠٠', 'sell': '١٥٤,٤٠٠', 'status': 'up'},
    {'name': 'حاریشیە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٥٠', 'status': 'neutral'},
    {'name': 'کەرکوک', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'down'},
    {'name': 'دهۆک', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٠٠', 'status': 'neutral'},
    {'name': 'نەجەف', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'name': 'بەسرە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'down'},
  ];

  // --- گۆڕاوەکانی حاسیبە ---
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

  // --- لۆجیکی هۆشمەندی وەرگرتنی نرخ ---
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
    if (selectedBaseRateSourceGlobal == 'Central Bank') {
      return usdToIqdCentralBankRate; // هاوئاراستەکردنی تەواو بێ دابەشکردنی ١٠٠
    }
    String cityName = (selectedBaseRateSourceGlobal == 'Baghdad Bourse') 
        ? 'بەغداد (کِفاح)' : 'سلێمانی';

    final cityData = cities.firstWhere((c) => c['name'] == cityName, orElse: () => cities[1]);
    return _parseRate(cityData['sell']!); 
  }

  Map<String, double> get _rateToIQD {
    double base = _getCurrentBaseUSDValue() * 100;
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
      double toRate = _toCurrencySelected == 'تمەن IRR' || _toCurrencySelected == 'دینار IQD' ? 1.0 : _rateToIQD[_toCurrencySelected] ?? 1.0;
      double result = (v * fromRate) / toRate;
      _toAmount = (_toCurrencySelected == 'تمەن IRR' || _toCurrencySelected == 'دینار IQD') 
          ? result.toStringAsFixed(0) : result.toStringAsFixed(2);
    });
  }

  // ============================================================================
  // چارەسەرکردنی ڕەق و تەواوی هاوکێشەی ماتماتیکی کڕین و فرۆشتنی لایڤی دۆلار و دینار
  // ============================================================================
  void _calculateProfit() {
    final double amount = double.tryParse(_amountVal.replaceAll(',', '')) ?? 0.0;
    final double buyPrice = double.tryParse(_buyPriceVal.replaceAll(',', '')) ?? 0.0;
    final double sellPrice = double.tryParse(_sellPriceVal.replaceAll(',', '')) ?? 0.0;
    if (amount <= 0 || buyPrice <= 0 || sellPrice <= 0) return;
    
    double rate = _rateToIQD['دۆلار USD'] ?? (_getCurrentBaseUSDValue() * 100);

    // ١. سەرمایەی سەرەتایی بە دیناری عێراقی بە دروستی (بڕی پارەکە هەمیشە وەک دۆلار وەرگرە)
    double amountInIQD = amount * (buyPrice / 100.0);

    // ٢. کۆی گشتی فرۆشتن بە دیناری عێراقی بە دروستی
    double totalSell = amount * (sellPrice / 100.0);

    // ٣. لۆجیکی کەمیسیۆن بە دینار
    double commission = double.tryParse(_commissionVal) ?? 0.0;
    double commAmount = amountInIQD * (commission / 100);

    // ٤. صافی قازانج بە دیناری عێراقی
    double profitIQD = totalSell - amountInIQD - commAmount;

    // ٥. صافی قازانج بە دۆلاری فەرمی بەگوێرەی تێکڕای لایڤی بازاڕ
    double profitUSD = profitIQD / (rate / 100.0);

    setState(() {
      _profitResult = {
        'profitIQD': profitIQD,
        'profitCurrency': profitUSD, // بەهاکە سەد لە سەد ڕاست و بێ هەڵەیە ئێستا
        'profitPercent': (profitIQD / amountInIQD) * 100,
        'totalSell': totalSell,
        'isProfit': profitIQD >= 0,
        'currency': 'USD', // ناونیشانی دووەم هەمیشە بە دۆلار بێت تا کڕیار بە قەبارەی ڕوون بیبینێت
        'commissionAmount': commAmount,
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

  List<Map<String, dynamic>> getDynamicCurrencyData() {
    double base = _getCurrentBaseUSDValue();
    return [
      {'name': 'دینار عێراقی', 'code': 'IQD', 'flag': '🇮🇶', 'price': base * 100, 'color': const Color(0xFF00C6FF)},
      {'name': 'تمەنی ئێرانی', 'code': 'IRR', 'flag': '🇮🇷', 'price': (1000000 / 62000.0) * base * 100, 'color': const Color(0xFFFF4D4D)},
      {'name': 'پاوەندی بەریتانی', 'code': 'GBP', 'flag': '🇬🇧', 'price': (100 / 0.794) * base, 'color': const Color(0xFF22C55E)},
      {'name': 'یۆرۆی ئەورووپی', 'code': 'EUR', 'flag': '🇪🇺', 'price': (100 / 0.915) * base, 'color': const Color(0xFFEAB308)},
    ];
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
        GestureDetector(onTap: _triggerRefresh, child: Stack(alignment: Alignment.center, children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00C6FF).withOpacity(0.12)), value: 1.0)), RotationTransition(turns: _refreshRotationController, child: const Icon(Icons.sync_rounded, color: Color(0xFF76C917), size: 14))])),
      ]),
    );
  }

  Widget _buildBottomNav() {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl, 
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08), 
              width: 1.2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          currentIndex: _selectedIndex, 
          selectedItemColor: Colors.blueAccent, 
          unselectedItemColor: Colors.grey, 
          onTap: (i) => setState(() => _selectedIndex = i), 
          type: BottomNavigationBarType.fixed, 
          selectedFontSize: 10, 
          unselectedFontSize: 10, 
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.trending_up), label: getTxt('cities_tab')), 
            BottomNavigationBarItem(icon: const Icon(Icons.currency_exchange), label: getTxt('currencies_tab')), 
            BottomNavigationBarItem(icon: const Icon(Icons.analytics_rounded), label: getTxt('analysis_tab')), 
            BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: getTxt('calculator_tab')), 
            BottomNavigationBarItem(icon: const Icon(Icons.store_rounded), label: getTxt('offices_tab'))
          ]
        ),
      )
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return isCitiesLockedGlobal ? _buildLockedScreen(getTxt('cities_tab')) : CitiesScreen(pinnedRates: pinnedRates, cities: cities, citiesScrollController: _citiesScrollController, onPinUpdated: (idx, c, b, s, st) { setState(() => pinnedRates[idx] = {'city': c, 'buy': b, 'sell': s, 'status': st}); }, onSwap: (f, t) { setState(() { final temp = cities[f]; cities[f] = cities[t]; cities[t] = temp; }); });
      case 1:
        return isCurrenciesLockedGlobal ? _buildLockedScreen(getTxt('currencies_tab')) : CurrenciesScreen(currencyData: getDynamicCurrencyData(), formatPrice: (p) => p.toString());
      case 2:
        return const MarketAnalysisScreen(); 
      case 3:
        return CalculatorScreen( 
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
              String current = '';
              if (_activeField == 'amount') {
                current = _amountVal.replaceAll(',', '');
              } else if (_activeField == 'buy') {
                current = _buyPriceVal.replaceAll(',', '');
              } else if (_activeField == 'sell') {
                current = _sellPriceVal.replaceAll(',', '');
              } else if (_activeField == 'commission') {
                current = _commissionVal.replaceAll(',', '');
              }

              if (key == '⌫') {
                if (current.isNotEmpty) current = current.substring(0, current.length - 1);
              } else if (key == 'C') {
                current = '';
                _profitResult = null;
              } else {
                if (current.length < 12) current += key;
              }

              if (_activeField == 'amount') {
                _amountVal = current;
              } else if (_activeField == 'buy') {
                _buyPriceVal = current;
              } else if (_activeField == 'sell') {
                _sellPriceVal = current;
              } else if (_activeField == 'commission') {
                _commissionVal = current;
              }

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
      default: return OfficesScreen(offices: allOffices);
    }
  }

  Widget _buildLockedScreen(String sectionName) {
    final String lockedDescText = appLanguageGlobal == 'English'
        ? "Your account usage period has expired. To renew, simply tap the WhatsApp icon below to send us an automatic account renewal message."
        : (appLanguageGlobal == 'العربية'
            ? "لقد انتهت فترة استخدام حسابك. للتجديد, فقط اضغط على أيقونة الواتساب أدناه لإرسال رسالة تجديد تلقائية إلينا."
            : "ماوەی بەکارهێنانی ئەژمارەکەت بەسەرچوو، بۆ نوێکردنەوە تەنیا دەست بنێ بە ئایکۆنی وەتساپی خوارەوە بۆ ئەوەی نامەی تۆماتیکی نوێنکردنەوەی ئەژمارەکەتمان پێ بگات ...");

    return Container(
      color: const Color(0xFF0B121F), 
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center, 
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 65), 
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF131C2E), 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(
            color: Colors.white.withOpacity(0.08), 
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), 
              blurRadius: 28,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFECC880).withOpacity(0.45),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/fanus.png', 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.hourglass_empty_rounded, size: 40, color: Color(0xFFECC880));
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              getTxt('locked_title'),
              style: const TextStyle(
                color: Color(0xFFECC880), 
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              lockedDescText, 
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              getTxt('locked_note'),
              style: const TextStyle(
                color: Color(0xFFECC880),
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildLockScreenContactRow('+964 773 145 4737'),
            _buildLockScreenContactRow('+964 773 154 7371'), 
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {
                showRegisterPhoneBottomSheet(context, onStateChanged: () {
                  setState(() {});
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD54C4C), 
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD54C4C).withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    getTxt('lock_create_account_btn'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockScreenContactRow(String number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F121A).withOpacity(0.6), 
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0),
      ),
      child: Row(
        children: [
          Text(
            number,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Color(0xFFECC880), 
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final cleanNumber = number.replaceAll(' ', '').replaceAll('+', '');
                  final message = Uri.encodeComponent(
                    appLanguageGlobal == 'English'
                        ? "Hello, please renew my account."
                        : (appLanguageGlobal == 'العربية'
                            ? "مرحباً، يرجى تجديد حسابي من فضلك."
                            : "تکایە ئەژمارەکەم بۆ نوێ بکەنەوە ..."),
                  );
                  final Uri url = Uri.parse('https://wa.me/$cleanNumber?text=$message');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 14),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final cleanNumber = number.replaceAll(' ', '');
                  final Uri url = Uri.parse('tel:$cleanNumber');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072FF).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0072FF).withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF4FC3F7), size: 14),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}