// ignore_for_file: deprecated_member_use
// lib/screens/main_navigation.dart

import 'dart:async';
import 'dart:math' as math; // 🔹 هاوردەکردنی ماتماتیک بۆ ئەنیمەیشنی شەپۆلی وشەکان
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_state.dart';
import '../models/office_model.dart';
import '../widgets/auth_sheets.dart';
import '../main.dart'; 
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
    with TickerProviderStateMixin { // کلاسی دروست و فەرمی ئەنیمەیشنەکان
  int _selectedIndex = 0;
  late TabController _tabController;
  final ScrollController _citiesScrollController = ScrollController();
  
  late AnimationController _refreshRotationController;
  late Timer _refreshTimer;

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
      return usdToIqdCentralBankRate; 
    }
    String cityName = (selectedBaseRateSourceGlobal == 'Baghdad Bourse') 
        ? 'بەغداد (کِفاح)' : 'سلێمانی';

    final cityData = cities.firstWhere((c) => c['name'] == cityName, orElse: () => cities[1]);
    return _parseRate(cityData['sell']!); 
  }

  // فۆرمولەی مۆدێرنی ماتماتیکی حاسیبەکە بۆ ئەوەی لەسەر بنەمای ١ یەکە نرخەکە ئەژمار بکات
  Map<String, double> get _rateToIQD {
    double oneUsd = _getCurrentBaseUSDValue(); // ڕێژەی ڕاستەقینەی ١ دۆلار (بۆ نموونە ١٥٣٧ دینار)
    return {
      'دۆلار USD': oneUsd,
      'دینار IQD': 1.0,
      'تمەن IRR': oneUsd / 620.0,    // ١ دۆلار = ٦٢٠ تەمەن
      'یۆرۆ EUR': oneUsd / 0.915,  // ڕێژەی یۆرۆ بەرامبەر دۆلار
      'پاوەند GBP': oneUsd / 0.794, // ڕێژەی پاوەند بەرامبەر دۆلار
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

  void _calculateProfit() {
    final double amount = double.tryParse(_amountVal.replaceAll(',', '')) ?? 0.0;
    final double buyPrice = double.tryParse(_buyPriceVal.replaceAll(',', '')) ?? 0.0;
    final double sellPrice = double.tryParse(_sellPriceVal.replaceAll(',', '')) ?? 0.0;
    if (amount <= 0 || buyPrice <= 0 || sellPrice <= 0) {
      return;
    }
    
    double rate = _rateToIQD['دۆلار USD'] ?? _getCurrentBaseUSDValue();
    final bool isIQD = _selectedCurrency.contains('IQD');

    double amountInIQD = isIQD ? amount : amount * (buyPrice / 100.0);
    double totalSell = isIQD ? (amount / (buyPrice / 100.0)) * (sellPrice / 100.0) : amount * (sellPrice / 100.0);
    double commission = double.tryParse(_commissionVal) ?? 0.0;
    double commAmount = amountInIQD * (commission / 100);
    double profitIQD = totalSell - amountInIQD - commAmount;
    double profitCurrency = isIQD ? profitIQD : profitIQD / (rate / 100.0);

    setState(() {
      _profitResult = {
        'profitIQD': profitIQD,
        'profitCurrency': profitCurrency, 
        'profitPercent': (profitIQD / amountInIQD) * 100,
        'totalSell': totalSell,
        'commissionAmount': commAmount,
      };
    });
  }

  void _toggleLanguage(BuildContext context, StateSetter setModalState) {
    setModalState(() {
      if (appLanguageGlobal == 'کوردی') {
        appLanguageGlobal = 'العربية';
      } else if (appLanguageGlobal == 'العربية') {
        appLanguageGlobal = 'English';
      } else {
        appLanguageGlobal = 'کوردی';
      }
    });
    BoursePremiumApp.rebuild(context);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshRotationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _calculateConversionFromStr();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshRotationController.dispose();
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(), // هێدەری سەرەکی و بێ کێشەی خۆت
              _buildBreakingNewsBanner(), // بانەری سەرەکی ڕاستەقینە
              Expanded(child: _buildCurrentScreen()), // بەشی گۆڕینی تابەکان
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF131C2E),
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.show_chart_rounded, color: Color(0xFF4FC3F7), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AnimatedWaveWords(text: getTxt('app_subtitle')),
                const SizedBox(height: 2),
                Text(getTxt('live'), style: const TextStyle(color: Color(0xFF22C55E), fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white70, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return isCitiesLockedGlobal 
            ? _buildLockedScreen(getTxt('cities_tab')) 
            : CitiesScreen(
                pinnedRates: pinnedRatesGlobal, // بەکارهێنانی گۆڕاوی جیهانی
                cities: cities, 
                citiesScrollController: _citiesScrollController, 
                onPinUpdated: (idx, c, b, s, st) {
                  setState(() {
                    String oldCity = pinnedRatesGlobal[idx]['city']!;
                    pinnedRatesGlobal[idx] = {'city': c, 'buy': b, 'sell': s, 'status': st};
                    
                    if (isRateNotifEnabledGlobal) {
                      updateFcmTopicSubscription(oldCity, false); 
                      updateFcmTopicSubscription(c, true);        
                    }
                  });
                }, 
                onSwap: (f, t) {
                  setState(() {
                    final temp = cities[f];
                    cities[f] = cities[t];
                    cities[t] = temp;
                  });
                },
              );
      case 1:
        return isCurrenciesLockedGlobal 
            ? _buildLockedScreen(getTxt('currencies_tab')) 
            : CurrenciesScreen(
                currencyData: getDynamicCurrencyData(), 
                formatPrice: (p) => p.toString()
              );
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
                if (current.isNotEmpty) {
                  current = current.substring(0, current.length - 1);
                }
              } else if (key == 'C') {
                current = '';
                _profitResult = null;
              } else {
                // ڕاستکردنەوەی لۆجیکی جێگرتنەوەی سفر لە خانەکاندا
                if (current == '' || current == '0') {
                  if (key == '.') {
                    current = '0.';
                  } else if (key == '000' || key == '0') {
                    current = '0';
                  } else {
                    current = key;
                  }
                } else {
                  if (current.length < 12) {
                    current += key;
                  }
                }
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
              if (key == '⌫') {
                if (current.isNotEmpty) {
                  current = current.substring(0, current.length - 1);
                }
                if (current.isEmpty) {
                  current = '0';
                }
              } else if (key == 'C') {
                current = '0';
              } else {
                // ڕاستکردنەوەی لۆجیکی جێگرتنەوەی سفر لە بەشی گۆڕینەوەی خێرادا
                if (current == '' || current == '0') {
                  if (key == '.') {
                    current = '0.';
                  } else if (key == '000' || key == '0') {
                    current = '0';
                  } else {
                    current = key;
                  }
                } else {
                  if (current.length < 12) {
                    current += key;
                  }
                }
              }
              _fromAmount = current;
              _calculateConversionFromStr();
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
              _calculateProfit();
            });
          },
          onFieldTapped: (field, val) {
            setState(() {
              _activeField = field;
            });
          },
        );
      default: 
        return OfficesScreen(offices: allOffices);
    }
  }

  Widget _buildLockedScreen(String sectionName) {
    final bool isLtr = appLanguageGlobal == 'English';
    return Container(
      color: const Color(0xFF0B121F), 
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center, 
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 45), 
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF131C2E), 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            isLoggedInGlobal ? _buildRegistrationSuccessView() : _buildAccountExpiredView(),
            Positioned(
              top: -8, 
              right: isLtr ? -6 : null, 
              left: isLtr ? null : -6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _toggleLanguage(context, setState), 
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: const Icon(Icons.g_translate_rounded, color: Color(0xFFECC880), size: 15),
                    ),
                  ),
                ],
              ),      
            ),
          ],
        ),      
      ),
    );
  }

  Widget _buildAccountExpiredView() {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Container(
          width: 85, height: 85,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFECC880).withOpacity(0.45), width: 1.5)),
          child: ClipOval(child: Image.asset('assets/fanus.png', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.hourglass_empty_rounded, size: 40, color: Color(0xFFECC880)))),
        ),
        const SizedBox(height: 14),
        Text(getTxt('locked_title'), style: const TextStyle(color: Color(0xFFECC880), fontSize: 16.5, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(getTxt('locked_desc'), style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 10.5, fontWeight: FontWeight.w600, height: 1.45), textAlign: TextAlign.center),
        const SizedBox(height: 14),
        _buildLockScreenContactRow('+964 773 145 4737'),
        _buildLockScreenContactRow('+964 773 154 7371'), 
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () { showRegisterPhoneBottomSheet(context, onStateChanged: () { setState(() {}); }); },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFD54C4C), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(getTxt('lock_create_account_btn'), style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF16181F), border: Border.all(color: const Color(0xFF76C917).withOpacity(0.3), width: 1.5)),
          child: const Icon(Icons.check_circle_outline_rounded, size: 44, color: Color(0xFF76C917)),
        ),
        const SizedBox(height: 16),
        Text(getTxt('reg_success_title'), style: const TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(getTxt('reg_success_subtitle'), style: const TextStyle(color: Color(0xFFECC880), fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 16), 
        _buildLockScreenContactRow('+964 773 145 4737'),
        _buildLockScreenContactRow('+964 773 154 7371'),
      ],
    );
  }

  Widget _buildLockScreenContactRow(String number) {
    final String cleanNumber = '\u200E$number'; 
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF0F121A).withOpacity(0.6), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0)),
      child: Row(children: [
        Text(cleanNumber, textDirection: TextDirection.ltr, style: const TextStyle(color: Color(0xFFECC880), fontSize: 11.5, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const Spacer(),
        Row(children: [
          GestureDetector(
            onTap: () async {
              final cleanNumberForWa = number.replaceAll(' ', '').replaceAll('+', '');
              final message = Uri.encodeComponent(appLanguageGlobal == 'English' ? "Hello, please renew my account." : "تکایە ئەژمارەکەم بۆ نوێ بکەنەوە ...");
              final Uri url = Uri.parse('https://wa.me/$cleanNumberForWa?text=$message');
              if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
            },
            child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF25D366).withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3))), child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 14)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              final cleanNumberForTel = number.replaceAll(' ', '');
              final Uri url = Uri.parse('tel:$cleanNumberForTel');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
            child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF0072FF).withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0072FF).withOpacity(0.3))), child: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF4FC3F7), size: 14)),
          ),
        ])
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
        Expanded(child: Text(getTxt('news_ticker'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
        GestureDetector(onTap: _triggerRefresh, child: Stack(alignment: Alignment.center, children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00C6FF).withOpacity(0.12)), value: 1.0)), RotationTransition(turns: _refreshRotationController, child: const Icon(Icons.sync_rounded, color: Color(0xFF76C917), size: 14))])),
      ]),
    );
  }

  Widget _buildBottomNav() {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl, 
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), 
        child: Container(
          height: 56, 
          decoration: BoxDecoration(
            color: const Color(0xFF131C2E).withOpacity(0.92), 
            borderRadius: BorderRadius.circular(16), 
            border: Border.all(color: const Color(0xFFECC880).withOpacity(0.35), width: 1.2),
          ),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(16),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent, 
                elevation: 0, 
                currentIndex: _selectedIndex, 
                selectedItemColor: Colors.blueAccent, 
                unselectedItemColor: Colors.grey, 
                onTap: (i) => setState(() => _selectedIndex = i), 
                type: BottomNavigationBarType.fixed, 
                iconSize: 21, 
                selectedFontSize: 9.0, 
                unselectedFontSize: 9.0, 
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.trending_up_rounded), label: getTxt('cities_tab')), 
                  BottomNavigationBarItem(icon: const Icon(Icons.monetization_on_rounded), label: getTxt('currencies_tab')), 
                  BottomNavigationBarItem(icon: const Icon(Icons.assessment_rounded), label: getTxt('analysis_tab')), 
                  BottomNavigationBarItem(icon: const Icon(Icons.calculate_rounded), label: getTxt('calculator_tab')), 
                  BottomNavigationBarItem(icon: const Icon(Icons.store_rounded), label: getTxt('offices_tab'))
                ]
              ),
            ),
          ),
        ),
      )
    );
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

  void _triggerRefresh() {
    _refreshRotationController.forward(from: 0.0);
    _calculateConversionFromStr();
  }
}

// ============================================================
// کڵاسی ئەنیمەیشنی شەپۆلی وشەکان بە لۆجیکی ماتماتیکی دروست
// ============================================================
class _AnimatedWaveWords extends StatefulWidget {
  final String text;
  const _AnimatedWaveWords({required this.text});

  @override
  State<_AnimatedWaveWords> createState() => _AnimatedWaveWordsState();
}

class _AnimatedWaveWordsState extends State<_AnimatedWaveWords> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(); // 🔹 فۆرماتەکە لێرە بە تەواوی بۆ دوو خاڵ ڕاستکرایەوە
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    List<Widget> children = [];
    
    for (int i = 0; i < words.length; i++) {
      children.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final dy = math.sin((_controller.value * 2 * math.pi) + (i * 0.8)) * 2.5; 
            return Transform.translate(offset: Offset(0, dy), child: child);
          },
          child: Text(words[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.3)),
        )
      );
      if (i < words.length - 1) {
        children.add(const SizedBox(width: 4.5));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}