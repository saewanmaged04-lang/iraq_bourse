// ignore_for_file: deprecated_member_use
// lib/screens/currencies_screen.dart

import 'package:flutter/material.dart';
import '../global_state.dart';
import '../main.dart'; // بۆ بانگکردنی BoursePremiumApp.rebuild لە کاتی گۆڕینی درۆپ داونەکەدا

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

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  // فەنکشنی هۆشمەندی فێڵباک بۆ فۆرماتکردنی گشتی نرخەکان بە فاریزە بێ تێکچوونی دەیییەکان
  String _formatWithCommas(double price) {
    if (price % 1 == 0) {
      // ئەگەر ژمارەی تەواو بوو وەک دینار یان تمەن
      String raw = price.toStringAsFixed(0);
      return raw.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    } else {
      // ئەگەر ژمارەی دەیی بوو وەک پاوەند, یۆرۆ, لیرە یان درام
      String raw = price.toStringAsFixed(2);
      if (raw.endsWith('0')) {
        raw = raw.substring(0, raw.length - 1); // لابردنی سفری کۆتایی زیادە وەک 79.40 بۆ 79.4
      }
      final parts = raw.split('.');
      final intPart = parts[0].replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
      return '$intPart.${parts[1]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Column(children: [
        Expanded(
          child: RefreshIndicator(
            backgroundColor: const Color(0xFF131C2E),
            color: Colors.blueAccent,
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                widget.currencyData[0]['price'] = 153800.0;
              });
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              itemCount: widget.currencyData.length + 1, // زیادکردنی یەک هێڵ بۆ نیشاندانی هێدەرەکە بە داینامیکی
              itemBuilder: (context, index) {
                // هێڵی یەکەم (Index 0): نیشاندانی فەرمی هێدەر و درۆپ داونەکە تا خۆکار بەرەو سەرەوە بجوڵێت
                if (index == 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4), // کەمکردنەوەی پادینگی گشتی بۆ جووڵانی زیاتر بەرەو سەرەوە
                        child: Column(
                          children: [
                            // ڕیزی سەرەکی: ناونیشان و دوگمەی لایڤ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getTxt('currencies_title'), 
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ADE80).withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.25)),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    const SizedBox(width: 5, height: 5, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle))),
                                    const SizedBox(width: 5),
                                    Text(getTxt('live'), style: const TextStyle(fontSize: 9, color: Color(0xFF4ADE80), fontWeight: FontWeight.w700)),
                                  ]),
                                ),
                              ],
                            ),
                            
                            // ڕیزی دووەم: سێنتەرکردنی تەواوی درۆپ داونی هەڵبژاردنی دۆلاری ناوەندی/شارەکان بە شێوازێکی زۆر شاهانە
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appLanguageGlobal == 'English' 
                                      ? 'vs ${formatDisplayNumbers('100')} USD ' 
                                      : (appLanguageGlobal == 'العربية' 
                                          ? 'مقابل ${formatDisplayNumbers('100')} دولار ' 
                                          : 'بەرامبەر ${formatDisplayNumbers('100')} دۆلاری '),
                                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.38), fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedBaseRateSourceGlobal,
                                    dropdownColor: const Color(0xFF131C2E),
                                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFC59A5C), size: 14),
                                    style: const TextStyle(color: Color(0xFFC59A5C), fontSize: 11, fontWeight: FontWeight.w900),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Central Bank', 
                                        child: Text(appLanguageGlobal == 'English' ? 'Central Bank' : (appLanguageGlobal == 'العربية' ? 'البنك المركزي' : 'بانکی ناوەندی'))
                                      ),
                                      DropdownMenuItem(
                                        value: 'Baghdad Bourse', 
                                        child: Text(appLanguageGlobal == 'English' ? 'Baghdad Bourse' : (appLanguageGlobal == 'العربية' ? 'بورصة بغداد' : 'بۆرسەی بەغداد'))
                                      ),
                                      DropdownMenuItem(
                                        value: 'Sulaymaniyah Bourse', 
                                        child: Text(appLanguageGlobal == 'English' ? 'Sulaymaniyah Bourse' : (appLanguageGlobal == 'العربية' ? 'بورصة السليمانية' : 'بۆرسەی سلێمانی'))
                                      ),
                                      DropdownMenuItem(
                                        value: 'Erbil Bourse', 
                                        child: Text(appLanguageGlobal == 'English' ? 'Erbil Bourse' : (appLanguageGlobal == 'العربية' ? 'بورصة أربيل' : 'بۆرسەی هەولێر'))
                                      ),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                    ],
                  );
                }

                // ڕێکخستنی سەرجەم نرخەکانی خوارەوە بە داینامیکی بەپێی ئیندێکسە نوێیەکە (Index - 1)
                final itemIndex = index - 1;
                final item = widget.currencyData[itemIndex];
                final Color itemColor = item['color'] as Color;
                final double price = item['price'] as double;
                final String code = item['code'] as String;
                final bool isLast = itemIndex == widget.currencyData.length - 1;
                
                final String nameKey = '${code}_name';
                final String unitKey = '${code}_unit';
                final String displayName = getTxt(nameKey);
                final String displayUnit = getTxt(unitKey);

                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(children: [
                      Text(item['flag'] as String, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(displayName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: itemColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text(code, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: itemColor)),
                        ),
                      ])),
                      
                      Container(
                        width: 130,
                        height: 44,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatDisplayNumbers(_formatWithCommas(price)),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              displayUnit,
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5)),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  if (!isLast) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05))),
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}