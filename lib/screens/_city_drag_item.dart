// lib/screens/_city_drag_item.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global_state.dart';

class CityDragItem extends StatefulWidget {
  final Map<String, String> item;
  final int index;
  final bool isActive;
  final Color buyColor, sellColor;
  final IconData statusIcon;
  final ScrollController scrollController;
  final Function(int) onActivate;
  final VoidCallback onDeactivate;
  final Function(int from, int to) onSwap;
  final VoidCallback onPinTap;

  const CityDragItem({
    super.key,
    required this.item,
    required this.index,
    required this.isActive,
    required this.buyColor,
    required this.sellColor,
    required this.statusIcon,
    required this.scrollController,
    required this.onActivate,
    required this.onDeactivate,
    required this.onSwap,
    required this.onPinTap,
  });

  @override
  State<CityDragItem> createState() => _CityDragItemState();
}

class _CityDragItemState extends State<CityDragItem> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _stopAutoScroll();
    super.dispose();
  }

  void _startAutoScroll() {
    if (_scrollTimer != null) return;
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      double t = widget.scrollController.offset - 6.5;
      if (t < 0) t = 0;
      widget.scrollController.jumpTo(t);
      if (t == 0) _stopAutoScroll();
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  @override
  void didUpdateWidget(CityDragItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isActive;
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != widget.index,
      onAcceptWithDetails: (details) => widget.onSwap(details.data, widget.index),
      builder: (context, candidateData, _) {
        final bool isDragOver = candidateData.isNotEmpty;
        return LongPressDraggable<int>(
          data: widget.index,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          delay: const Duration(milliseconds: 1500),
          maxSimultaneousDrags: 1,
          onDragUpdate: (d) { if (d.globalPosition.dy < 250) {
            _startAutoScroll();
          } else {
            _stopAutoScroll();
          } },
          onDragEnd: (_) { _stopAutoScroll(); widget.onDeactivate(); },
          onDraggableCanceled: (_, __) { _stopAutoScroll(); widget.onDeactivate(); },
          onDragStarted: () { widget.onActivate(widget.index); _shakeController.forward(from: 0); HapticFeedback.mediumImpact(); },
          feedback: Material(
            color: Colors.transparent,
            child: Transform.scale(scale: 1.02, child: Container(
              width: MediaQuery.of(context).size.width - 24,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueAccent, width: 2),
                boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)],
              ),
              child: Row(children: [
                Icon(widget.statusIcon, size: 13, color: widget.buyColor),
                const SizedBox(width: 8),
                Text(getCityName(widget.item['name']!), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.drag_indicator_rounded, size: 16, color: Colors.blueAccent),
              ]),
            )),
          ),
          childWhenDragging: Container(
            margin: const EdgeInsets.symmetric(vertical: 4), height: 52,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.arrow_downward_rounded, size: 14, color: Colors.blueAccent.withValues(alpha: 0.5)),
              const SizedBox(width: 6),
              Text('ئێرە دابنێ', style: TextStyle(fontSize: 11, color: Colors.blueAccent.withValues(alpha: 0.5))),
            ])),
          ),
          child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) => Transform.translate(offset: Offset(isActive ? ((_shakeController.value * 2 - 1).abs() * 2) : 0.0, 0), child: child),
            child: GestureDetector(
              onTap: isActive ? () { widget.onDeactivate(); } : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDragOver ? const Color(0xFF1A3050) : isActive ? const Color(0xFF0D2040) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDragOver ? Colors.blueAccent : isActive ? Colors.blueAccent : const Color(0xFF1E293B), width: isDragOver ? 2 : 1),
                  boxShadow: isActive ? [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 1)] : isDragOver ? [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.2), blurRadius: 10)] : [],
                ),
                child: Row(children: [
                  GestureDetector(onTap: widget.onPinTap, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.push_pin, size: 15, color: Colors.blueAccent))),
                  const SizedBox(width: 10),
                  Expanded(child: Row(children: [
                    Icon(widget.statusIcon, size: 13, color: widget.buyColor),
                    const SizedBox(width: 6),
                    Expanded(child: Text(getCityName(widget.item['name']!), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                    if (isActive) ...[
                      Icon(Icons.drag_indicator_rounded, size: 16, color: Colors.blueAccent.withValues(alpha: 0.9)),
                      const SizedBox(width: 4),
                      Text('ڕاکێشە', style: TextStyle(fontSize: 10, color: Colors.blueAccent.withValues(alpha: 0.8), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                    ],
                  ])),
                  Row(children: [
                    _priceBox(widget.item['buy']!, widget.buyColor, widget.statusIcon),
                    const SizedBox(width: 5),
                    _priceBox(widget.item['sell']!, widget.sellColor, widget.statusIcon),
                  ]),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priceBox(String price, Color color, IconData icon) => Container(
    width: 76, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.9)),
      const SizedBox(width: 3),
      Text(formatDisplayNumbers(price), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
    ]),
  );
}