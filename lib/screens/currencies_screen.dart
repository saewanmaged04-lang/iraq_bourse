// lib/screens/currencies_screen.dart

import 'package:flutter/material.dart';
import '../global_state.dart';

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
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTxt('currencies_title'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 2),
              Text(getTxt('vs_100_dollars'), style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.38))),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4ADE80).withOpacity(0.25)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(width: 5, height: 5, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle))),
                const SizedBox(width: 5),
                Text(getTxt('live'), style: const TextStyle(fontSize: 9, color: Color(0xFF4ADE80), fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
        Container(height: 1, color: Colors.white.withOpacity(0.05)),
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
              itemCount: widget.currencyData.length,
              itemBuilder: (context, index) {
                final item = widget.currencyData[index];
                final Color itemColor = item['color'] as Color;
                final double price = item['price'] as double;
                final String code = item['code'] as String;
                final bool isLast = index == widget.currencyData.length - 1;
                
                // داینامیکیکردنی فەرمی ناو و یەکەی سەرجەم دراوەکان بەپێی کلیلەکانی فایلی گشتی
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
                          decoration: BoxDecoration(color: itemColor.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text(code, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: itemColor)),
                        ),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(formatDisplayNumbers(widget.formatPrice(price)), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                          const SizedBox(width: 6),
                          Text(displayUnit, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.5))),
                        ]),
                      ),
                    ]),
                  ),
                  if (!isLast) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Container(height: 1, color: Colors.white.withOpacity(0.05))),
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}