// ignore_for_file: deprecated_member_use
// lib/screens/main_navigation.dart

import 'dart:async'; // هاوردەکردنی تایمەر بۆ ئۆتۆ ڕێفرێش
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

// گۆڕینی مێکسەکە بۆ TickerProviderStateMixin بۆ ڕێگەپێدانی زۆرتر لە یەک ئەنیمەیشنی جیاواز بێ کێشە
class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final ScrollController _citiesScrollController = ScrollController();
  
  late AnimationController _refreshRotationController; // کۆنتڕۆڵەری خولانەوەی ڕێفرێش
  late Timer _refreshTimer; // تایمەری ئۆتۆ ڕێفرێش لە هەر ٥ چرکەیەکدا

  final List<Map<String, String>> pinnedRates = [
    {'city': 'بەغداد', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'city': 'سلێمانی', 'buy': '١٥٣,٦٥٠', 'sell': '١٥٤,٠٠٠', 'status': 'neutral'},
    {'city': 'هەولێر', 'buy': '١٥٣,٦٦٠', 'sell': '١٥٣,٩٥٠', 'status': 'up'},
  ];

  final List<Map<String, String>> cities = [
    {'name': 'هەولێر', 'buy': '١٥٣,٧٥٠', 'sell': '١٥٤,١٠٠', 'status': 'up'},
    {'name': 'سلێمانی', 'buy': '١٥٣,٨٠٠', 'sell': '١٥٤,١٥٠', 'status': 'neutral'},
    {'name': 'بەغداد (کِفاح)', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'neutral'},
    {'name': 'کەڕادە', 'buy': '١٥٤,٠٠٠', 'sell': '١٥٤,٤٠٠', 'status': 'up'},
    {'name': 'حاریشیە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٥٠', 'status': 'neutral'},
    {'name': 'کەرکوک', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'down'},
    {'name': 'دهۆک', 'buy': '١٥٣,٨٥٠', 'sell': '١٥٤,٢٠٠', 'status': 'neutral'},
    {'name': 'نەجەف', 'buy': '١٥٣,٩٠٠', 'sell': '١٥٤,٢٥٠', 'status': 'up'},
    {'name': 'بەسرە', 'buy': '١٥٣,٩٥٠', 'sell': '١٥٤,٣٠٠', 'status': 'down'},
  ];

  // لۆجیکی حیسابکردنی داینامیکی نرخەکانی دراوەکان بە نیسبەت دۆلاری ناوەندی/بازاڕ
  List<Map<String, dynamic>> getDynamicCurrencyData() {
    double selectedBaseUSD = activeBaseUsdToIqdRate; // بەکار هێنانی ڕێژەی داینامیکی بەپێی هەڵبژاردەی کڕیار
    return [
      {
        'name': 'دینار عێراقی', 
        'code': 'IQD', 
        'flag': '🇮🇶', 
        'price': usdToIqdMarketRate * 100, // ١٠٠ دۆلاری بازاڕ بەرامبەر دینار
        'change': '+0.12%', 
        'isUp': true, 
        'color': const Color(0xFF00C6FF)
      },
      {
        'name': 'تمەنی ئێرانی', 
        'code': 'IRR', 
        'flag': '🇮🇷', 
        // حیسابکردنی خۆکاری تمەن بەرامبەر بە دۆلاری فەرمی ناوەندی (کورتەی ١ ملیۆن تمەن)
        'price': (1000000 / 62000.0) * selectedBaseUSD, 
        'change': '-0.08%', 
        'isUp': false, 
        'color': const Color(0xFFFF4D4D)
      },
      {
        'name': 'پاوەندی بەریتانی', 
        'code': 'GBP', 
        'flag': '🇬🇧', 
        // حیسابکردنی ١٠٠ پاوەند بە دینار لەسەر دۆلاری ناوەندی
        'price': (100 / 0.794) * selectedBaseUSD, 
        'change': '+0.05%', 
        'isUp': true, 
        'color': const Color(0xFF22C55E)
      },
      {
        'name': 'یۆرۆی ئەورووپی', 
        'code': 'EUR', 
        'flag': '🇪🇺', 
        // حیسابکردنی ١٠٠ یۆرۆ بە دینار لەسەر دۆلاری فەرمی ناوەندی
        'price': (100 / 0.915) * selectedBaseUSD, 
        'change': '-0.06%', 
        'isUp': false, 
        'color': const Color(0xFFEAB308)
      },
      {
        'name': 'لیرەی تورکی', 
        'code': 'TRY', 
        'flag': '🇹🇷', 
        // حیسابکردنی ١٠٠ لیرە بە دینار لەسەر دۆلاری ناوەندی
        'price': (100 / 32.45) * selectedBaseUSD, 
        'change': '-0.22%', 
        'isUp': false, 
        'color': const Color(0xFFFF7849)
      },
      {
        'name': 'درامی ئیماراتی', 
        'code': 'AED', 
        'flag': '🇦🇪', 
        // حیسابکردنی ١٠٠ درەم بە دینار لەسەر دۆلاری فەرمی ناوەندی
        'price': (100 / 3.673) * selectedBaseUSD, 
        'change': '+0.03%', 
        'isUp': true, 
        'color': const Color(0xFF06B6D4)
      },
    ];
  }

  String _fromAmount = '100';
  String _toAmount = '153,700';
  String _fromCurrencySelected = 'دۆلار USD';
  String _toCurrencySelected = 'دینار IQD';
  String _activeField = 'amount';
  String _amountVal = '';
  String _buyPriceVal = '';
  String _sellPriceVal = '';
  String _commissionVal = '0';
  String _selectedCurrency = 'دۆلار USD';
  Map<String, dynamic>? _profitResult;

  final List<String> _availableCurrencies = ['دۆلار USD', 'دینار IQD', 'تمەن IRR', 'یۆرۆ EUR', 'پاوەند GBP'];
  
  // لۆجیکی هاوکێشەی ڕێژەکان بەگوێرەی بەهای هەڵبژێردراوی بەکارهێنەر لە ڕێکخستنەکاندا
  Map<String, double> get _rateToIQD => {
    'دۆلار USD': activeBaseUsdToIqdRate, 
    'دینار IQD': 1.0,
    'تمەن IRR': activeBaseUsdToIqdRate / 62000.0, 
    'یۆرۆ EUR': activeBaseUsdToIqdRate / 0.915, 
    'پاوەند GBP': activeBaseUsdToIqdRate / 0.794,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // خولانەوەی لەسەرخۆ بە بەردەوامی لە ماوەی تەواوی ٥ چرکەکەدا
    _refreshRotationController = AnimationController(
      duration: const Duration(seconds: 5), // خولانەوەیەکی زۆر هێمن و لەسەرخۆ
      vsync: this,
    );
    _refreshRotationController.repeat(); // دووبارەبوونەوەی بەردەوام بە بێ پچڕان

    // بەکارخستنی مێتۆدی نوێکردنەوەی خۆکارانە لە هەر ٥ چرکەیەکدا
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _triggerRefresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel(); // پاککردنەوەی تایمەر لە مێمۆریدا لە کاتی داخستنی لاپەڕەکە
    _refreshRotationController.dispose();
    _tabController.dispose();
    _citiesScrollController.dispose();
    super.dispose();
  }

  // مێتۆدی نوێبوونەوەی داینامیکی نرخەکان لە کاتی ڕێفرێشدا
  void _triggerRefresh() {
    setState(() {
      // لێرەوە دەتوانیت نرخە مۆکەکانی شارەکان بە بڕی زۆر بچووک بگۆڕیت بۆ ڕاستەقینە پیشاندان لە کاتی ڕێفرێش
      cities[0]['buy'] = (153750 + (DateTime.now().second % 3 == 0 ? 50 : -50)).toString();
      cities[1]['buy'] = (153800 + (DateTime.now().second % 2 == 0 ? 50 : -50)).toString();
    });
  }

  String _formatPrice(double price) {
    if (price >= 1000000) return '${(price / 1000000).toStringAsFixed(2)}M';
    if (price >= 1000) return price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (price >= 1) return price.toStringAsFixed(2);
    return price.toStringAsFixed(4);
  }

  String _addCommas(String raw) {
    if (raw.isEmpty) return '';
    final clean = raw.replaceAll(',', '');
    final parts = clean.split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (parts.length > 1) return '$intPart.${parts[1]}';
    return intPart;
  }

  String _removeCommas(String val) => val.replaceAll(',', '');

  String _getCurrentVal() {
    switch (_activeField) {
      case 'amount': return _amountVal;
      case 'buy': return _buyPriceVal;
      case 'sell': return _sellPriceVal;
      case 'commission': return _commissionVal;
      default: return '';
    }
  }

  void _switchToValue(String val) {
    switch (_activeField) {
      case 'amount': _amountVal = val; break;
      case 'buy': _buyPriceVal = val; break;
      case 'sell': _sellPriceVal = val; break;
      case 'commission': _commissionVal = val; break;
    }
  }

  void _calculateConversionFromStr({bool fromTop = true}) {
    setState(() {
      final double v = double.tryParse(_removeCommas(_fromAmount)) ?? 0.0;
      double fromRate = _rateToIQD[_fromCurrencySelected] ?? 1.0;
      double toRate = _rateToIQD[_toCurrencySelected] ?? 1.0;
      if (fromTop) {
        double result = (v * fromRate) / toRate;
        _toAmount = _addCommas((_toCurrencySelected == 'تمەن IRR' || _toCurrencySelected == 'دینار IQD') ? result.toStringAsFixed(0) : result.toStringAsFixed(2));
      } else {
        double result = (v * toRate) / fromRate;
        _fromAmount = _addCommas((_fromCurrencySelected == 'تمەن IRR' || _fromCurrencySelected == 'دینار IQD') ? result.toStringAsFixed(0) : result.toStringAsFixed(2));
      }
    });
  }

  void _calculateProfit() {
    final double amount = double.tryParse(_removeCommas(_amountVal)) ?? 0.0;
    final double buyPrice = double.tryParse(_removeCommas(_buyPriceVal)) ?? 0.0;
    final double sellPrice = double.tryParse(_removeCommas(_sellPriceVal)) ?? 0.0;
    final double commission = double.tryParse(_removeCommas(_commissionVal)) ?? 0.0;
    if (amount <= 0 || buyPrice <= 0 || sellPrice <= 0) return;
    final double rate = _rateToIQD[_selectedCurrency] ?? activeBaseUsdToIqdRate;
    final double amountInIQD = amount * rate;
    final double units = amountInIQD / buyPrice;
    final double totalSell = units * sellPrice;
    final double commissionAmount = amountInIQD * (commission / 100);
    final double profitIQD = totalSell - amountInIQD - commissionAmount;
    setState(() {
      _profitResult = {
        'profitIQD': profitIQD, 'profitCurrency': profitIQD / rate,
        'profitPercent': (profitIQD / amountInIQD) * 100, 'totalSell': totalSell,
        'isProfit': profitIQD >= 0, 'currency': _selectedCurrency, 'commissionAmount': commissionAmount,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(children: [
          _buildHeader(), 
          _buildBreakingNewsBanner(),
          Expanded(child: _buildCurrentScreen())
        ])),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(color: Color(0xFF0F172A), border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1))),
      child: Stack(alignment: Alignment.center, children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  setState(() {}); 
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0072FF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF00C6FF).withOpacity(0.35)),
                    ),
                    child: const Icon(Icons.settings_rounded, color: Color(0xFF00C6FF), size: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    getTxt('settings_title'), 
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        Center(child: Text(
          getTxt('app_subtitle'), 
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)
        )),
        Align(
          alignment: Alignment.centerRight,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.calendar_month_rounded, size: 10, color: Color(0xFF00C6FF)),
              const SizedBox(width: 3),
              Text(formatDisplayNumbers('٦/٦/٢٠٢٦'), style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 1),
            Text(
              appLanguageGlobal == 'English' 
                  ? 'Saturday • 12:00 AM' 
                  : (appLanguageGlobal == 'العربية' ? 'السبت • ١٢:٠٠ ص' : 'شەممە • ١٢:٠٠ پ.ن'), 
              style: const TextStyle(fontSize: 8, color: Color(0xFF4ADE80), fontWeight: FontWeight.w600)
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildBreakingNewsBanner() {
    return Container(
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded, color: Colors.orangeAccent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              appLanguageGlobal == 'English'
                  ? 'News: Baghdad and Sulaymaniyah bourses have updated their rates.'
                  : (appLanguageGlobal == 'العربية'
                      ? 'أخبار: بورصتا بغداد والسليمانية حدثتا أسعارهما.'
                      : 'هەواڵ: بۆرسەی سلێمانی و بەغداد نرخەکانی خۆیان نوێکردەوە.'),
              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // پێکهاتەی هۆشمەندی گۆڕینی لۆگۆی ڕێفرێش بە بازنەی پڕ و جووڵەی لەسەرخۆ کەمڕوون وەک داواکارییەکەت
          GestureDetector(
            onTap: _triggerRefresh, // ڕێفرێش بە دەست لێدان
            child: Stack(
              alignment: Alignment.center,
              children: [
                // هێڵە بازنەییە زێڕینییە پاشبنەماییەکە بۆ پێشکەشکردنی هەستی پڕبوون
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF00C6FF).withOpacity(0.12)
                    ),
                    value: 1.0, // سندوقێکی پڕی گشتگیر پیشان دەدات
                  ),
                ),
                // ئایکۆنی ناوەکی خولاوەی بەردەوام بە شێوازی لەسەرخۆ
                RotationTransition(
                  turns: _refreshRotationController,
                  child: const Icon(
                    Icons.sync_rounded, 
                    color: Color(0xFF76C917), // ڕەنگی سەوزی مۆدێرنی دڵخواز
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F172A),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10, unselectedFontSize: 10,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.trending_up), label: getTxt('cities_tab')),
          BottomNavigationBarItem(icon: const Icon(Icons.currency_exchange), label: getTxt('currencies_tab')),
          BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: getTxt('calculator_tab')),
          BottomNavigationBarItem(icon: const Icon(Icons.store_rounded), label: getTxt('offices_tab')),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    Widget child;
    switch (_selectedIndex) {
      case 0:
        child = isCitiesLockedGlobal ? _buildLockedScreen(getTxt('cities_tab')) : CitiesScreen(
          pinnedRates: pinnedRates,
          cities: cities,
          citiesScrollController: _citiesScrollController,
          onPinUpdated: (idx, c, b, s, st) {
            setState(() => pinnedRates[idx] = {'city': c, 'buy': b, 'sell': s, 'status': st});
          },
          onSwap: (f, t) {
            setState(() {
              final temp = cities[f];
              cities[f] = cities[t];
              cities[t] = temp;
            });
          },
        );
        break;
      case 1:
        child = isCurrenciesLockedGlobal ? _buildLockedScreen(getTxt('currencies_tab')) : CurrenciesScreen(
          currencyData: getDynamicCurrencyData(), // بەکارهێنانی داتای نرخە داینامیکییە گەشاوەکان
          formatPrice: (p) => p.toString(), 
        );
        break;
      case 2:
        child = CalculatorScreen(
          tabController: _tabController,
          availableCurrencies: _availableCurrencies,
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
              String current = _removeCommas(_getCurrentVal());
              if (key == '⌫') {
                if (current.isNotEmpty) current = current.substring(0, current.length - 1);
              } else if (key == '.' && current.contains('.')) {
                return;
              } else if (current == '0' && key != '.') {
                current = key;
              } else {
                if (current.length < 12) current += key;
              }
              _switchToValue(current);
              if (_activeField != 'commission') _profitResult = null;
            });
          },
          onConverterTap: (key) {
            setState(() {
              String current = _removeCommas(_fromAmount);
              if (key == '⌫') {
                if (current.isNotEmpty) current = current.substring(0, current.length - 1);
                if (current.isEmpty) current = '0';
              } else if (key == '.' && current.contains('.')) {
                return;
              } else if (current == '0' && key != '.') {
                current = key;
              } else {
                if (current.length < 12) current += key;
              }
              _fromAmount = _addCommas(current);
              _calculateConversionFromStr(fromTop: true);
            });
          },
          onCalculateProfit: _calculateProfit,
          onConverterFieldsChanged: (curr, rate, isFrom) {
            setState(() {
              if (isFrom) {
                _fromCurrencySelected = curr;
              } else {
                _toCurrencySelected = curr;
              }
              _calculateConversionFromStr();
            });
          },
          onProfitCurrencyChanged: (curr) {
            setState(() {
              _selectedCurrency = curr;
              _profitResult = null;
            });
          },
          onFieldTapped: (field, val) {
            setState(() {
              _activeField = field;
            });
          },
        );
        break;
      case 3:
        child = OfficesScreen(offices: allOffices);
        break;
      default:
        child = OfficesScreen(offices: allOffices);
    }

    // لۆجیکی فەرمی زیادکردنی تایبەتمەندی ڕاکێشان بۆ خوارەوە (Pull-to-Refresh) بۆ سەرجەم بەشە گونجاوەکان وەک داواکاریت
    if (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3) {
      return RefreshIndicator(
        backgroundColor: const Color(0xFF131C2E),
        color: const Color(0xFF76C917), // ڕەنگی سەوزی نایاب لە کاتی ڕاکێشاندا
        onRefresh: () async {
          _triggerRefresh();
          await Future.delayed(const Duration(milliseconds: 1000));
        },
        child: child,
      );
    }
    return child;
  }

  Widget _buildOfficesScreen() => OfficesScreen(offices: allOffices);

  // شاشەی قوفڵبوون بە چاککاری زۆر تایبەت بۆ تەواو لۆدبوونی وێنە زێڕینییەکە
  Widget _buildLockedScreen(String sectionName) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320), 
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF131724), 
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // بەکار هێنانی ClipOval و BoxFit.cover بۆ پڕبوونی بازنەکە بێ کێشەی لاکێشەیی
              Container(
                width: 100, // فۆرماتی دروستی قەبارەکە بۆ پیشاندانی فانۆسە گەشاوەکە
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC59A5C).withOpacity(0.25), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC59A5C).withOpacity(0.12),
                      blurRadius: 35,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/fanus.png', // وێنەی فەرمی و زێڕینی فانۆسەکە
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover, // بەهێزترین مێتۆد بۆ ڕێگریکردن لە کەنارە ڕەشەکانی ڕاست و چەپ و پڕبوونی تەواوەتی بازنەکە
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.hourglass_empty_rounded, 
                        size: 56, 
                        color: Color(0xFFC59A5C)
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                getTxt('locked_title'),
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFFC59A5C)),
              ),
              const SizedBox(height: 12),

              Text(
                getTxt('locked_desc'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7), height: 1.6, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              
              Text(
                getTxt('locked_note'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Color(0xFFC59A5C), height: 1.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    _buildLockScreenContactRow('+964 750 585 6964'),
                    const SizedBox(height: 10),
                    _buildLockScreenContactRow('+964 772 585 6969'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB83939).withOpacity(0.2), 
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB83939), 
                      padding: const EdgeInsets.symmetric(vertical: 16), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    onPressed: () {
                       showRegisterPhoneBottomSheet(context, onStateChanged: () {
                         setState(() {});
                       });
                    },
                    child: Text(
                      getTxt('lock_create_account_btn'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockScreenContactRow(String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), 
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Text(
            number,
            textDirection: TextDirection.ltr,
            style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          ),
          const Spacer(),
          _buildSimpleIcon(Icons.chat_bubble_outline_rounded),
          const SizedBox(width: 10),
          _buildSimpleIcon(Icons.phone_outlined),
          const SizedBox(width: 10),
          _buildSimpleIcon(Icons.chat_outlined),
        ],
      ),
    );
  }

  Widget _buildSimpleIcon(IconData icon) {
    return Icon(icon, color: Colors.white.withOpacity(0.6), size: 16);
  }
}