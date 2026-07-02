// lib/screens/cities_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global_state.dart';
import '_city_drag_item.dart';

class CitiesScreen extends StatefulWidget {
  final List<Map<String, String>> pinnedRates;
  final List<Map<String, String>> cities;
  final ScrollController citiesScrollController;
  final Function(int, String, String, String, String) onPinUpdated;
  final Function(int, int) onSwap;

  const CitiesScreen({
    super.key,
    required this.pinnedRates,
    required this.cities,
    required this.citiesScrollController,
    required this.onPinUpdated,
    required this.onSwap,
  });

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  int? _activeDragIndex; 

  // مێتۆدی هۆشمەندی پیشاندانی دیالۆگی پینکردنی سەرەوە
  void _showPinSelectionDialog(String city, String buy, String sell, String status) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131C2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Directionality(
        textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16), 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                appLanguageGlobal == 'English' 
                    ? 'Pin (${getCityName(city)}) instead of which cell?' 
                    : (appLanguageGlobal == 'العربية' ? 'تثبيت (${getCityName(city)}) بدلاً من أي خانة؟' : 'جێگیرکردنی (${getCityName(city)}) لە بری کام خانەی سەرەوە؟'), 
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)
              ),
              const SizedBox(height: 10),
              ...List.generate(3, (i) => ListTile(
                title: Text(
                  appLanguageGlobal == 'English'
                      ? 'Cell ${i + 1} (Now: ${getCityName(widget.pinnedRates[i]['city']!)})'
                      : (appLanguageGlobal == 'العربية'
                          ? 'الخانة ${i + 1} (الآن: ${getCityName(widget.pinnedRates[i]['city']!)})'
                          : 'خانەی ${i == 0 ? 'یەکەم' : i == 1 ? 'دووەم' : 'سێیەم'} (ئێستا: ${getCityName(widget.pinnedRates[i]['city']!)})'), // گۆڕینی لاتینی بۆ کوردی سۆرانی ڕەسەن
                  style: const TextStyle(fontSize: 12)
                ),
                leading: Icon(i == 0 ? Icons.looks_one : i == 1 ? Icons.looks_two : i == 2 ? Icons.looks_3 : Icons.looks_one, color: Colors.blueAccent),
                onTap: () { 
                  widget.onPinUpdated(i, city, buy, sell, status); 
                  Navigator.pop(context); 
                },
              )),
              // لێرەدا لاکێشەکانی ژمارەی تەلەفۆنەکانی پشتگیری بە تەواوی لابراون بۆ خاوێنکردنەوەی شاشەکە
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Column(children: [
        Expanded(child: RefreshIndicator(
          backgroundColor: const Color(0xFF131C2E),
          color: Colors.blueAccent,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              widget.cities[0]['buy'] = '١٥٣,٨٠٠';
              widget.cities[0]['sell'] = '١٥٤,١٥٠';
            });
          },
          child: ListView.builder(
            controller: widget.citiesScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: widget.cities.length + 1, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(children: List.generate(widget.pinnedRates.length, (pIndex) {
                        final rate = widget.pinnedRates[pIndex];
                        final String status = rate['status'] ?? 'neutral';
                        final Color trendColor = status == 'down' ? const Color(0xFFFF6B6B) : const Color(0xFF4CD137);
                        final IconData trendIcon = status == 'up' ? Icons.arrow_upward_rounded : status == 'down' ? Icons.arrow_downward_rounded : Icons.remove_rounded;
                        
                        return Expanded(child: DragTarget<Map<String, String>>(
                          onWillAcceptWithDetails: (_) => true,
                          onAcceptWithDetails: (d) => widget.onPinUpdated(pIndex, d.data['city']!, d.data['buy']!, d.data['sell']!, d.data['status']!),
                          builder: (context, candidateData, _) {
                            final bool isHovering = candidateData.isNotEmpty;
                            final List<Color> cardGradient = isHovering
                                ? [const Color(0xFF0072FF), const Color(0xFF00C6FF)]
                                : [const Color(0xFF0D47A1), const Color(0xFF1565C0)]; 
                            
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: cardGradient,
                                  begin: Alignment.bottomCenter, end: Alignment.topCenter,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                  bottomLeft: Radius.circular(10),
                                ),
                                border: Border.all(color: isHovering ? Colors.white : Colors.blueAccent.withValues(alpha: 0.4)),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.push_pin, size: 7, color: Colors.white.withValues(alpha: 0.7)), const SizedBox(width: 2),
                                  Flexible(child: Text(getCityName(rate['city']!), style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis)),
                                ]),
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(trendIcon, size: 9, color: trendColor), const SizedBox(width: 1),
                                  Flexible(child: Text(formatDisplayNumbers(rate['sell']!), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis)),
                                ]),
                                Text(getTxt('sell'), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 7.5, fontWeight: FontWeight.bold)),
                                Container(height: 0.5, color: Colors.white.withValues(alpha: 0.15)),
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(trendIcon, size: 9, color: trendColor), const SizedBox(width: 1),
                                  Flexible(child: Text(formatDisplayNumbers(rate['buy']!), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis)),
                                ]),
                                Text(getTxt('buy'), style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 7.5, fontWeight: FontWeight.bold)),
                              ]),
                            );
                          },
                        ));
                      })),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(appLanguageGlobal == 'English' ? 'Bourse' : (appLanguageGlobal == 'العربية' ? 'البورصة' : 'بۆرسە'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.45))),
                        Row(children: [
                          SizedBox(width: 76, child: Center(child: Text(getTxt('buy'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF4ADE80).withValues(alpha: 0.9))))),
                          const SizedBox(width: 6),
                          SizedBox(width: 76, child: Center(child: Text(getTxt('sell'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFF6B6B).withValues(alpha: 0.9))))),
                        ]),
                      ]),
                    ),
                  ],
                );
              }

              final itemIndex = index - 1;
              final item = widget.cities[itemIndex];
              final String status = item['status'] ?? 'neutral';
              
              final Color trendColor = status == 'down' 
                  ? const Color(0xFFE53E3E) 
                  : const Color(0xFF4CD137);
              final IconData statusIcon = status == 'up' 
                  ? Icons.arrow_upward_rounded 
                  : (status == 'down' ? Icons.arrow_downward_rounded : Icons.remove_rounded);

              return CityDragItem(
                key: ValueKey('drag_${item['name']}'),
                item: item, 
                index: itemIndex, 
                isActive: _activeDragIndex == itemIndex, 
                buyColor: trendColor, 
                sellColor: trendColor, 
                statusIcon: statusIcon,
                scrollController: widget.citiesScrollController,
                onActivate: (idx) { HapticFeedback.mediumImpact(); setState(() => _activeDragIndex = idx); }, 
                onDeactivate: () => setState(() => _activeDragIndex = null), 
                onSwap: widget.onSwap,
                onPinTap: () => _showPinSelectionDialog(item['name']!, item['buy']!, item['sell']!, item['status'] ?? 'neutral'),
              );
            },
          ),
        )),
      ]),
    );
  }
}