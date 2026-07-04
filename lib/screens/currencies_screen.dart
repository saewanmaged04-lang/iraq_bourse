// ignore_for_file: deprecated_member_use
// lib/screens/currencies_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../global_state.dart';
import '../main.dart'; // هاوردەکردنی بۆ نوێکردنەوەی ئەپەکە بە داینامیکی

class CurrenciesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> currencyData;
  final Function(double) formatPrice;

  const CurrenciesScreen({
    super.key,
    required this.currencyData,
    required this.formatPrice,
  });

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // ئایندێکسی دراوی هەڵبژێردراو بۆ تەفسیلات
  int? _expandedIndex;

  // دۆخی بەشە چالاکەکە (0: دراوەکان، 1: زێڕ و زیو)
  int _activeSubTab = 0;

  String _formatWithCommas(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(2)}M';
    }
    if (price % 1 == 0) {
      String raw = price.toStringAsFixed(0);
      return raw.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    } else {
      String raw = price.toStringAsFixed(2);
      final parts = raw.split('.');
      final intPart = parts[0].replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
      return '$intPart.${parts[1]}';
    }
  }

  String _getLocalName(String code) {
    if (code == 'IQD') {
      return appLanguageGlobal == 'English' ? 'Iraqi Dinar' : (appLanguageGlobal == 'العربية' ? 'دينار عراقي' : 'دینار عێراقی');
    }
    if (code == 'IRR') {
      return appLanguageGlobal == 'English' ? 'Iranian Toman' : (appLanguageGlobal == 'العربية' ? 'تومان إيراني' : 'تمەنی ئێرانی');
    }
    if (code == 'GBP') {
      return appLanguageGlobal == 'English' ? 'British Pound' : (appLanguageGlobal == 'العربية' ? 'جنيه إسترليني' : 'پاوەندی بەریتانی');
    }
    if (code == 'EUR') {
      return appLanguageGlobal == 'English' ? 'Euro' : (appLanguageGlobal == 'العربية' ? 'يورو أوروبي' : 'یۆرۆی ئەورووپی');
    }
    if (code == 'TRY') {
      return appLanguageGlobal == 'English' ? 'Turkish Lira' : (appLanguageGlobal == 'العربية' ? 'ليرة تركية' : 'لیرەی تورکی');
    }
    if (code == 'AED') {
      return appLanguageGlobal == 'English' ? 'UAE Dirham' : (appLanguageGlobal == 'العربية' ? 'درهم إماراتي' : 'درامی ئیماراتی');
    }
    return code;
  }

  String _getLocalUnit(String code) {
    if (code == 'IQD') {
      return appLanguageGlobal == 'English' ? 'IQD' : 'د.ع';
    }
    if (code == 'IRR') {
      return appLanguageGlobal == 'English' ? 'Toman' : (appLanguageGlobal == 'العربية' ? 'تومان' : 'تمەن');
    }
    if (code == 'GBP') {
      return appLanguageGlobal == 'English' ? 'GBP' : (appLanguageGlobal == 'العربية' ? 'جنيه' : 'پاوەند');
    }
    if (code == 'EUR') {
      return appLanguageGlobal == 'English' ? 'EUR' : (appLanguageGlobal == 'العربية' ? 'يورو' : 'یۆرۆ');
    }
    if (code == 'TRY') {
      return appLanguageGlobal == 'English' ? 'TRY' : (appLanguageGlobal == 'العربية' ? 'ليرة' : 'لیرە');
    }
    if (code == 'AED') {
      return appLanguageGlobal == 'English' ? 'AED' : (appLanguageGlobal == 'العربية' ? 'درهم' : 'درام');
    }
    return code;
  }

  // سپارکلاین بچووک بۆ هەر دراوێک (mock data)
  List<double> _getMiniChart(String code) {
    final Map<String, List<double>> charts = {
      'IQD': [151.2, 152.0, 151.8, 153.0, 152.5, 153.7, 153.7],
      'IRR': [6.3, 6.1, 6.2, 6.0, 6.2, 6.2, 6.2],
      'GBP': [78.5, 79.0, 78.8, 79.2, 79.1, 79.4, 79.4],
      'EUR': [91.0, 90.8, 91.2, 91.3, 91.4, 91.5, 91.5],
      'TRY': [3280, 3260, 3255, 3250, 3248, 3245, 3245],
      'AED': [366.5, 367.0, 366.8, 367.1, 367.2, 367.3, 367.3],
    };
    return charts[code] ?? [1, 1, 1, 1, 1, 1, 1];
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim =
        Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Container(
        color: const Color(0xFF0B121F),
        child: RefreshIndicator(
          backgroundColor: const Color(0xFF131C2E),
          color: Colors.blueAccent,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              if (widget.currencyData.isNotEmpty) {
                widget.currencyData[0]['price'] = 153800.0;
              }
            });
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: _activeSubTab == 0 
                ? widget.currencyData.length + 1 
                : 2, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSubTabSwitcher(), // 🔹 دوگمە هاوتەریبەکان لێرەیە
                  ],
                );
              }
              
              if (_activeSubTab == 0) {
                return _buildCurrencyCard(index - 1); 
              } else {
                return _buildGoldAndSilverSection(); 
              }
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER 
  // ============================================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 10), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              getTxt('currencies_title'),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
            const SizedBox(height: 3),
            Text(
              getTxt('vs_100_dollars'),
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.35)),
            ),
          ]),
          Row(
            children: [
              _buildBaseUsdSelector(), 
              const SizedBox(width: 8),
              _buildLiveBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBaseUsdSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBaseRateSourceGlobal,
          dropdownColor: const Color(0xFF131C2E),
          isDense: true,
          icon: const Icon(Icons.expand_more_rounded, color: Color(0xFFECC880), size: 14),
          style: const TextStyle(color: Color(0xFFECC880), fontSize: 10.5, fontWeight: FontWeight.bold),
          items: [
            DropdownMenuItem(value: 'Central Bank', child: Text(getTxt('rate_source_central'))), 
            DropdownMenuItem(value: 'Sulaymaniyah Bourse', child: Text(getTxt('rate_source_slemani'))), 
            DropdownMenuItem(value: 'Baghdad Bourse', child: Text(getTxt('rate_source_baghdad'))), 
            DropdownMenuItem(value: 'Erbil Bourse', child: Text(getTxt('rate_source_erbil'))), 
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                selectedBaseRateSourceGlobal = val;
              });
              BoursePremiumApp.rebuild(context); 
            }
          },
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4ADE80).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4ADE80)
                .withOpacity(0.2 + _pulseAnim.value * 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ADE80)
                  .withOpacity(_pulseAnim.value * 0.12),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4ADE80)
                  .withOpacity(0.6 + _pulseAnim.value * 0.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ADE80)
                      .withOpacity(_pulseAnim.value * 0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            getTxt('live'),
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF4ADE80),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5),
          ),
        ]),
      ),
    );
  }

  // ============================================================
  // 🔹 ویجێتی گۆڕینی بەشەکان بە دوو ڕەنگی جیاواز و دەقی زەق
  // ============================================================
  Widget _buildSubTabSwitcher() {
    final bool isEn = appLanguageGlobal == 'English';
    final bool isAr = appLanguageGlobal == 'العربية';
    
    final String currenciesLabel = isEn ? 'Currencies' : (isAr ? 'العملات' : 'دراوەکان');
    final String goldSilverLabel = isEn ? 'Gold & Silver' : (isAr ? 'الذهب والفضة' : 'زێڕ و زیو');

    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 4),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSubTabButton(
              index: 0,
              icon: Icons.monetization_on_rounded,
              label: currenciesLabel,
              activeColor: const Color(0xFF22C55E), // 🔹 ڕەنگی سەوز بۆ بەشی دراوەکان [1]
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildSubTabButton(
              index: 1,
              icon: Icons.stars_rounded, 
              label: goldSilverLabel,
              activeColor: const Color(0xFFECC880), // 🔹 ڕەنگی زێڕینی شاهانە بۆ زێڕ و زیو [1]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabButton({
    required int index, 
    required IconData icon, 
    required String label,
    required Color activeColor, // وەرگرتنی ڕەنگی تایبەت بۆ چالاکبوون
  }) {
    final bool isActive = _activeSubTab == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSubTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.18) : const Color(0xFF1E293B).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor : Colors.white.withOpacity(0.15), // هێڵی دەوری ناچالاک بۆ پڕکردنەوەی جیاوازییەکە [1]
            width: isActive ? 1.8 : 1.0,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: activeColor.withOpacity(0.12),
              blurRadius: 10,
              spreadRadius: 0,
            )
          ] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: isActive ? activeColor : Colors.white.withOpacity(0.7), // ئایکۆنی بەشی ناچالاک تۆختر کرا بۆ ئەوەی ون نەبێت [1]
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.75), // زیادکردنی ئۆپاسیتی بەشی ناچالاک بۆ تۆخبوونەوەی دەقەکە [1]
                fontSize: 12.5,
                fontWeight: FontWeight.w900, // فۆنتی زۆر ئەستوور بۆ دیاربوون بە ڕوونی [1]
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CURRENCY CARD
  // ============================================================
  Widget _buildCurrencyCard(int index) {
    final item = widget.currencyData[index];
    final Color itemColor = item['color'] as Color;
    final double price = item['price'] as double;
    final String code = item['code'] as String;
    final bool isUp = item['isUp'] as bool? ?? true;
    final String change = item['change'] as String? ?? '+0.00%';
    final String displayName = _getLocalName(code);
    final String displayUnit = _getLocalUnit(code);
    final List<double> chartData = _getMiniChart(code);
    final bool isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? itemColor.withOpacity(0.3)
                : Colors.white.withOpacity(0.06),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: itemColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              _buildCurrencyInfo(
                  code, displayName, displayUnit, itemColor, item['flag'] as String),
              const SizedBox(width: 10),
              _buildMiniSparkline(chartData, isUp, itemColor),
              const SizedBox(width: 10),
              _buildPriceSection(price, displayUnit, change, isUp, itemColor),
            ]),
          ),
          if (isExpanded) _buildExpandedDetails(item, itemColor, displayName),
        ]),
      ),
    );
  }

  Widget _buildCurrencyInfo(String code, String displayName,
      String unit, Color color, String flag) {
    return Row(children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Center(
          child:
              Text(flag, style: const TextStyle(fontSize: 22)),
        ),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          displayName,
          style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        const SizedBox(height: 3),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            code,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: color),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildMiniSparkline(
      List<double> data, bool isUp, Color color) {
    return SizedBox(
      width: 50,
      height: 30,
      child: CustomPaint(
        painter: _SparklinePainter(data: data, color: color, isUp: isUp),
      ),
    );
  }

  Widget _buildPriceSection(double price, String unit, String change,
      bool isUp, Color color) {
    final Color changeColor =
        isUp ? const Color(0xFF4ADE80) : const Color(0xFFFF6B6B);

    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text(
        formatDisplayNumbers(_formatWithCommas(price)),
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.3),
      ),
      const SizedBox(height: 2),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          isUp
              ? Icons.arrow_drop_up_rounded
              : Icons.arrow_drop_down_rounded,
          color: changeColor,
          size: 14,
        ),
        Text(
          change,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: changeColor),
        ),
      ]),
    ]);
  }

  Widget _buildExpandedDetails(
      Map<String, dynamic> item, Color color, String displayName) {
    final double price = item['price'] as double;
    final String displayUnit = _getLocalUnit(item['code'] as String);

    final double per100 = price;
    final double per10 = price / 10;
    final double per1 = price / 100;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(children: [
        Row(children: [
          Container(width: 3, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(
            getTxt('quick_convert_title'), 
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8)),
          ),
        ]),
        const SizedBox(height: 10),
        _buildConvertRow('USD 1', _formatWithCommas(per1), displayUnit, color),
        const SizedBox(height: 6),
        _buildConvertRow('USD 10', _formatWithCommas(per10), displayUnit, color),
        const SizedBox(height: 6),
        _buildConvertRow('USD 100', _formatWithCommas(per100), displayUnit, color),
      ]),
    );
  }

  Widget _buildConvertRow(
      String from, String to, String unit, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            from,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w600),
          ),
        ),
        Icon(Icons.arrow_forward_rounded,
            size: 12, color: Colors.white.withOpacity(0.2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              formatDisplayNumbers(to),
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                  fontSize: 9,
                  color: color.withOpacity(0.6),
                  fontWeight: FontWeight.w600),
            ),
          ]),
        ),
      ],
    );
  }

  // ============================================================
  // ✨ بەشی نوێ و ڕێکخراوی زێڕ و زیو (GOLD & SILVER SECTION)
  // ============================================================
  Widget _buildGoldAndSilverSection() {
    final bool isEn = appLanguageGlobal == 'English';
    final bool isAr = appLanguageGlobal == 'العربية';

    // وەرگێڕانی داینامیکی سەردێڕەکان بە زمانی ئەپەکە
    final String sectionTitle = isEn 
        ? 'Gold & Silver Rates' 
        : (isAr ? 'أسعار الذهب والفضة' : 'نرخەکانی زێڕ و زیو'); 
        
    final String subtitle = isEn 
        ? 'Live gold rates per Mithqal (~5g) & silver per gram' 
        : (isAr ? 'أسعار الذهب للمثقال والفضة للغرام الواحد' : 'نرخەکانی زێڕ بۆ مسقاڵ و زیو بۆ هەر غرامێک بە زیندوویی');

    final String headerName = isEn ? 'Type' : (isAr ? 'النوع' : 'جۆر');
    final String headerUnit = isEn ? 'Unit' : (isAr ? 'الوحدة' : 'یەکە');
    final String headerPrice = isEn ? 'Price (IQD)' : (isAr ? 'السعر (د.ع)' : 'نرخ (دینار)');

    final String mithqalUnit = isEn ? 'Mithqal' : (isAr ? 'مثقال' : 'مسقاڵ');
    final String pieceUnit = isEn ? 'Piece' : (isAr ? 'قطعة' : 'دانە');
    final String gramUnit = isEn ? 'Gram' : (isAr ? 'غرام' : 'غرام');

    // نرخە ڕاستەقینەکانی ساڵی ٢٠٢٦ بەپێی بۆرسەی فەرمی عێراق و کوردستان [1.2.3, 1.2.9]
    final List<Map<String, String>> goldRates = [
      {
        'name': isEn ? 'Gold 24 Carat' : (isAr ? 'ذهب عيار ٢٤' : 'زێڕی عەیار ٢٤'),
        'unit': mithqalUnit,
        'price': '١,١٤٣,٠٠٠',
        'icon': '🏆',
        'color': '0xFFFFD700',
      },
      {
        'name': isEn ? 'Gold 21 Carat' : (isAr ? 'ذهب عيار ٢١' : 'زێڕی عەیار ٢١'),
        'unit': mithqalUnit,
        'price': '١,٠٤٥,٠٠٠',
        'icon': '✨',
        'color': '0xFFECC880',
      },
      {
        'name': isEn ? 'Gold 18 Carat' : (isAr ? 'ذهب عيار ١٨' : 'زێڕی عەیار ١٨'),
        'unit': mithqalUnit,
        'price': '٨٥٥,٠٠٠',
        'icon': '🎗️',
        'color': '0xFFCD7F32',
      },
      {
        'name': isEn ? 'Royal Gold Lira (21k)' : (isAr ? 'الليرة الملكية (٢١ك)' : 'لیرەی مەلەکی (عەیار ٢١)'),
        'unit': pieceUnit,
        'price': '١,٧٢٠,٠٠٠',
        'icon': '🪙',
        'color': '0xFFFFD700',
      },
      {
        'name': isEn ? 'Turkish Gold Lira (22k)' : (isAr ? 'الليرة التركية (٢٢ك)' : 'لیرەی تورکی (عەیار ٢٢)'),
        'unit': pieceUnit,
        'price': '١,٦٨٠,٠٠٠',
        'icon': '👑',
        'color': '0xFFECC880',
      },
      {
        'name': isEn ? 'Pure Silver (999)' : (isAr ? 'فضة نقية (٩٩٩)' : 'زیوی عەیار ٩٩٩ (پوخت)'),
        'unit': gramUnit,
        'price': '٤,٢٥٠',
        'icon': '💿',
        'color': '0xFFB0C4DE',
      },
      {
        'name': isEn ? 'Sterling Silver (925)' : (isAr ? 'فضة استرليني (٩٢٥)' : 'زیوی عەیار ٩٢٥ (ئیسترلینی)'),
        'unit': gramUnit,
        'price': '٣,٨٥٠',
        'icon': '💍',
        'color': '0xFFE6E6FA',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECC880).withOpacity(0.25), width: 1.2), 
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFECC880).withOpacity(0.03),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECC880).withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFECC880).withOpacity(0.25)),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFECC880), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sectionTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // سەردێڕی خشتەی نرخەکان
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    headerName,
                    style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      headerUnit,
                      style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: isEn ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      headerPrice,
                      style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // لیستی سەرجەم نرخەکانی زێڕ و زیو بە جوانی
          ...goldRates.map((rate) {
            final Color rateColor = Color(int.parse(rate['color']!));
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Text(rate['icon']!, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rate['name']!,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: rateColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: rateColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          rate['unit']!,
                          style: TextStyle(color: rateColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: isEn ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        formatDisplayNumbers(rate['price']!),
                        style: const TextStyle(color: Color(0xFFECC880), fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
// SPARKLINE PAINTER
// ============================================================
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool isUp;

  _SparklinePainter(
      {required this.data, required this.color, required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double minVal = data.reduce(math.min);
    final double maxVal = data.reduce(math.max);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double y =
          size.height - ((data[i] - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final lastX = size.width;
    final lastY = size.height -
        ((data.last - minVal) / range) * size.height;
    canvas.drawCircle(Offset(lastX, lastY), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}