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
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;

  // ئایندێکسی دراوی هەڵبژێردراو بۆ تەفسیلات
  int? _expandedIndex;

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
    if (code == 'IQD') return appLanguageGlobal == 'English' ? 'Iraqi Dinar' : (appLanguageGlobal == 'العربية' ? 'دينار عراقي' : 'دینار عێراقی');
    if (code == 'IRR') return appLanguageGlobal == 'English' ? 'Iranian Toman' : (appLanguageGlobal == 'العربية' ? 'تومان إيراني' : 'تمەنی ئێرانی');
    if (code == 'GBP') return appLanguageGlobal == 'English' ? 'British Pound' : (appLanguageGlobal == 'العربية' ? 'جنيه إسترليني' : 'پاوەندی بەریتانی');
    if (code == 'EUR') return appLanguageGlobal == 'English' ? 'Euro' : (appLanguageGlobal == 'العربية' ? 'يورو أوروبي' : 'یۆرۆی ئەورووپی');
    if (code == 'TRY') return appLanguageGlobal == 'English' ? 'Turkish Lira' : (appLanguageGlobal == 'العربية' ? 'ليرة تركية' : 'لیرەی تورکی');
    if (code == 'AED') return appLanguageGlobal == 'English' ? 'UAE Dirham' : (appLanguageGlobal == 'العربية' ? 'درهم إماراتي' : 'درامی ئیماراتی');
    return code;
  }

  String _getLocalUnit(String code) {
    if (code == 'IQD') return appLanguageGlobal == 'English' ? 'IQD' : 'د.ع';
    if (code == 'IRR') return appLanguageGlobal == 'English' ? 'Toman' : (appLanguageGlobal == 'العربية' ? 'تومان' : 'تمەن');
    if (code == 'GBP') return appLanguageGlobal == 'English' ? 'GBP' : (appLanguageGlobal == 'العربية' ? 'جنيه' : 'پاوەند');
    if (code == 'EUR') return appLanguageGlobal == 'English' ? 'EUR' : (appLanguageGlobal == 'العربية' ? 'يورو' : 'یۆرۆ');
    if (code == 'TRY') return appLanguageGlobal == 'English' ? 'TRY' : (appLanguageGlobal == 'العربية' ? 'ليرة' : 'لیرە');
    if (code == 'AED') return appLanguageGlobal == 'English' ? 'AED' : (appLanguageGlobal == 'العربية' ? 'درهم' : 'درام');
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
    _shimmerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    _pulseAnim =
        Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);
    _shimmerAnim =
        Tween<double>(begin: -1.0, end: 2.0).animate(_shimmerController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
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
            itemCount: widget.currencyData.length + 1, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSummaryStrip(),
                  ],
                );
              }
              return _buildCurrencyCard(index - 1); 
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER (دروستکردنی ڕیزی سەرەوە بە درۆپداونی داینامیکی فەرمی)
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
                  color: Colors.white.withValues(alpha: 0.35)),
            ),
          ]),
          // ڕیزکردنی لای چەپ بۆ درۆپ داونی سەرچاوەی دۆلار لەگەڵ لایڤ باجەکەت
          Row(
            children: [
              _buildBaseUsdSelector(), // درۆپداونی داینامیکی لێرەیە
              const SizedBox(width: 8),
              _buildLiveBadge(),
            ],
          ),
        ],
      ),
    );
  }

  // دروستکردنی درۆپداونی مۆدێرن و بچووک بۆ گۆڕینی لایڤی سەرچاوەی دۆلار
  Widget _buildBaseUsdSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBaseRateSourceGlobal,
          dropdownColor: const Color(0xFF131C2E),
          isDense: true,
          icon: const Icon(Icons.expand_more_rounded, color: Color(0xFFECC880), size: 14),
          style: const TextStyle(color: Color(0xFFECC880), fontSize: 10.5, fontWeight: FontWeight.bold),
          items: [
            DropdownMenuItem(value: 'Central Bank', child: Text(appLanguageGlobal == 'English' ? 'Central' : 'ناوەندی')),
            DropdownMenuItem(value: 'Sulaymaniyah Bourse', child: Text(appLanguageGlobal == 'English' ? 'Slemani' : 'سلێمانی')),
            DropdownMenuItem(value: 'Baghdad Bourse', child: Text(appLanguageGlobal == 'English' ? 'Baghdad' : 'بەغداد')),
            DropdownMenuItem(value: 'Erbil Bourse', child: Text(appLanguageGlobal == 'English' ? 'Erbil' : 'هەولێر')),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                selectedBaseRateSourceGlobal = val;
              });
              BoursePremiumApp.rebuild(context); // سەرلەنوێ کێشانەوەی خۆکاری دراوەکان بەگوێرەی نرخەکەت
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
          color: const Color(0xFF4ADE80).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4ADE80)
                .withValues(alpha: 0.2 + _pulseAnim.value * 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ADE80)
                  .withValues(alpha: _pulseAnim.value * 0.12),
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
                  .withValues(alpha: 0.6 + _pulseAnim.value * 0.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ADE80)
                      .withValues(alpha: _pulseAnim.value * 0.6),
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
  // SUMMARY STRIP - ئیستاتیستیکی کورتەیی
  // ============================================================
  Widget _buildSummaryStrip() {
    int upCount = 0, downCount = 0;
    for (final item in widget.currencyData) {
      final bool isUp = item['isUp'] as bool? ?? true;
      if (isUp) upCount++; else downCount++;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStripStat(
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF4ADE80),
            label: appLanguageGlobal == 'English' ? 'Rising' : 'بەرزبووە',
            value: '$upCount',
          ),
          Container(
              width: 1, height: 28, color: Colors.white.withValues(alpha: 0.06)),
          _buildStripStat(
            icon: Icons.trending_down_rounded,
            color: const Color(0xFFFF6B6B),
            label: appLanguageGlobal == 'English' ? 'Falling' : 'کەمبووە',
            value: '$downCount',
          ),
          Container(
              width: 1, height: 28, color: Colors.white.withValues(alpha: 0.06)),
          _buildStripStat(
            icon: Icons.access_time_rounded,
            color: const Color(0xFF4FC3F7),
            label: appLanguageGlobal == 'English' ? 'Updated' : 'نوێکراوە',
            value: '12:00',
          ),
        ],
      ),
    );
  }

  Widget _buildStripStat(
      {required IconData icon,
      required Color color,
      required String label,
      required String value}) {
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w900)),
      ]),
      const SizedBox(height: 2),
      Text(label,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 9,
              fontWeight: FontWeight.w600)),
    ]);
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
                ? itemColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.06),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: itemColor.withValues(alpha: 0.1),
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
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.15)),
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
            color: color.withValues(alpha: 0.1),
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

  // ============================================================
  // EXPANDED DETAILS - پیشاندانی گۆڕینەوەی لایڤی ١، ١٠، ١٠٠ دۆلار
  // ============================================================
  Widget _buildExpandedDetails(
      Map<String, dynamic> item, Color color, String displayName) {
    final double price = item['price'] as double;
    final String displayUnit = _getLocalUnit(item['code'] as String);

    // لۆجیکی حیسابکردنی خۆکاری ١, ١٠, ١٠٠ دۆلار بەگوێرەی تێکرای بۆرسەکان
    final double per100 = price;
    final double per10 = price / 10;
    final double per1 = price / 100;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        Row(children: [
          Container(width: 3, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(
            appLanguageGlobal == 'English'
                ? 'Quick Convert'
                : (appLanguageGlobal == 'العربية'
                    ? 'تحويل سريع'
                    : 'گەڕاندنەوەی خێرا'),
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.8)),
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
            color: Colors.white.withValues(alpha: 0.05),
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
            size: 12, color: Colors.white.withValues(alpha: 0.2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
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
                  color: color.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600),
            ),
          ]),
        ),
      ],
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
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
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