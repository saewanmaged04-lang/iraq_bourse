// ignore_for_file: deprecated_member_use
// lib/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import '../global_state.dart';

class CalculatorScreen extends StatefulWidget {
  final TabController tabController;
  final List<String> availableCurrencies;
  final Map<String, double> rateToIQD;
  final String fromAmount;
  final String toAmount;
  final String fromCurrencySelected;
  final String toCurrencySelected;
  final String amountVal;
  final String buyPriceVal;
  final String sellPriceVal;
  final String commissionVal;
  final String selectedCurrency;
  final Map<String, dynamic>? profitResult;
  final Function(String) onKeyTap;
  final Function(String) onConverterTap;
  final Function() onCalculateProfit;
  final Function(String, double, bool) onConverterFieldsChanged;
  final Function(String) onProfitCurrencyChanged;
  final Function(String, String) onFieldTapped;
  final String activeField;

  const CalculatorScreen({
    super.key,
    required this.tabController,
    required this.availableCurrencies,
    required this.rateToIQD,
    required this.fromAmount,
    required this.toAmount,
    required this.fromCurrencySelected,
    required this.toCurrencySelected,
    required this.amountVal,
    required this.buyPriceVal,
    required this.sellPriceVal,
    required this.commissionVal,
    required this.selectedCurrency,
    required this.profitResult,
    required this.onKeyTap,
    required this.onConverterTap,
    required this.onCalculateProfit,
    required this.onConverterFieldsChanged,
    required this.onProfitCurrencyChanged,
    required this.onFieldTapped,
    required this.activeField,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _addCommas(String raw) {
    if (raw.isEmpty) return '';
    final clean = raw.replaceAll(',', '');
    final parts = clean.split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (parts.length > 1) return '$intPart.${parts[1]}';
    return intPart;
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Column(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          height: 32,
          decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF1E293B))),
          child: TabBar(
            controller: widget.tabController,
            indicator: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]), borderRadius: BorderRadius.circular(6)),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white, unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.zero,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.all(2),
            dividerColor: Colors.transparent,
            tabs: [Tab(text: getTxt('exchange_tab')), Tab(text: getTxt('profit_tab'))],
          ),
        ),
        Expanded(child: TabBarView(controller: widget.tabController, children: [
          _buildConverterTab(),
          _buildProfitTab()
        ])),
      ]),
    );
  }

  Widget _buildConverterTab() {
    return Column(children: [
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
        child: Column(children: [
          _buildConverterField(widget.fromCurrencySelected, formatDisplayNumbers(widget.fromAmount), Colors.blueAccent, true),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: CircleAvatar(
              radius: 14, backgroundColor: Colors.blueAccent.withOpacity(0.15),
              child: IconButton(iconSize: 12, icon: const Icon(Icons.swap_vert, color: Colors.blueAccent), onPressed: () {
                widget.onConverterFieldsChanged(widget.toCurrencySelected, 0.0, true);
              }),
            ),
          ),
          _buildConverterField(widget.toCurrencySelected, formatDisplayNumbers(widget.toAmount), Colors.greenAccent, false),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E293B))),
            child: Column(children: [
              Text(getTxt('current_rates'), style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              ...widget.availableCurrencies.where((c) => c != 'دینار IQD').map((c) {
                final rate = widget.rateToIQD[c] ?? 1.0;
                return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getCurrencyDisplayName(c), style: const TextStyle(fontSize: 10, color: Colors.white70)),
                  Text('= ${formatDisplayNumbers(rate >= 1 ? _addCommas(rate.toStringAsFixed(0)) : rate.toStringAsFixed(6))} د.ع', style: const TextStyle(fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ]));
              }),
            ]),
          ),
        ]),
      )),
      _buildNumericKeyboard(onTap: widget.onConverterTap),
    ]);
  }

  Widget _buildConverterField(String currency, String amount, Color color, bool isFrom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.8),
      ),
      child: Row(children: [
        DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: currency, dropdownColor: const Color(0xFF131C2E),
          icon: Icon(Icons.arrow_drop_down, color: color),
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12),
          // گۆڕینی خۆکاری ناوی دراوەکان لە لیستی حاسیبەکەدا بۆ عەرەبی یان ئینگلیزی
          items: widget.availableCurrencies.map((val) => DropdownMenuItem<String>(value: val, child: Text(getCurrencyDisplayName(val)))).toList(),
          onChanged: (val) {
            if (val != null) {
              widget.onConverterFieldsChanged(val, widget.rateToIQD[val] ?? 1.0, isFrom);
            }
          },
        )),
        const Spacer(),
        Text(amount.isEmpty ? '0' : amount, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    );
  }

  Widget _buildProfitTab() {
    final bool isProfit = widget.profitResult != null && (widget.profitResult!['isProfit'] as bool? ?? false);
    final Color resultColor = widget.profitResult == null ? Colors.grey : isProfit ? const Color(0xFF4ADE80) : const Color(0xFFFF6B6B);
    return Column(children: [
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E293B))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(appLanguageGlobal == 'English' ? 'Currency Type' : 'جۆری دراو', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6))),
              DropdownButtonHideUnderline(child: DropdownButton<String>(
                value: widget.selectedCurrency, dropdownColor: const Color(0xFF131C2E),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                items: widget.availableCurrencies.map((val) => DropdownMenuItem<String>(value: val, child: Text(getCurrencyDisplayName(val)))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    widget.onProfitCurrencyChanged(val);
                  }
                },
              )),
            ]),
          ),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(child: _buildTappableField(getTxt('amount_label'), formatDisplayNumbers(widget.amountVal), 'amount', const Color(0xFF0072FF))),
            const SizedBox(width: 5),
            Expanded(child: _buildTappableField(getTxt('buy_price_label'), formatDisplayNumbers(widget.buyPriceVal), 'buy', const Color(0xFFFF6B6B)))
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: _buildTappableField(getTxt('sell_price_label'), formatDisplayNumbers(widget.sellPriceVal), 'sell', const Color(0xFF4ADE80))),
            const SizedBox(width: 5),
            Expanded(child: _buildTappableField(getTxt('commission_label'), formatDisplayNumbers(widget.commissionVal), 'commission', Colors.orange))
          ]),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: widget.onCalculateProfit,
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: const Color(0xFF0072FF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]),
              child: Center(child: Text(getTxt('calculate_btn'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white))),
            ),
          ),
          const SizedBox(height: 6),
          if (widget.profitResult != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: resultColor.withOpacity(0.2), width: 1.5)),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(isProfit ? Icons.trending_up : Icons.trending_down, color: resultColor, size: 16),
                  const SizedBox(width: 6),
                  Text(isProfit ? getTxt('profit_won') : getTxt('profit_lost'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: resultColor)),
                ]),
                const SizedBox(height: 6),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 5),
                _buildResultRow(getTxt('profit_iqd_label'), '${(widget.profitResult!['profitIQD'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers(_addCommas((widget.profitResult!['profitIQD'] as double).toStringAsFixed(0)))} د.ع', resultColor, Icons.monetization_on),
                _buildResultRow('${getTxt('profit_curr_label')} ${widget.profitResult!['currency']}', '${(widget.profitResult!['profitCurrency'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers(_addCommas((widget.profitResult!['profitCurrency'] as double).toStringAsFixed(2)))}', resultColor, Icons.currency_exchange),
                _buildResultRow(getTxt('profit_percent_label'), '${(widget.profitResult!['profitPercent'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers((widget.profitResult!['profitPercent'] as double).toStringAsFixed(2))}٪', resultColor, Icons.percent),
                const Divider(color: Color(0xFF1E293B), height: 8),
                _buildResultRow(getTxt('commission_iqd'), '${formatDisplayNumbers(_addCommas((widget.profitResult!['commissionAmount'] as double).toStringAsFixed(0)))} د.ع', Colors.orange, Icons.receipt_long),
                const SizedBox(height: 4),
                _buildResultRow(getTxt('total_sell'), '${formatDisplayNumbers(_addCommas((widget.profitResult!['totalSell'] as double).toStringAsFixed(0)))} د.ع', Colors.white70, Icons.sell),
              ]),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E293B))),
              child: Column(children: [
                Icon(Icons.calculate_outlined, size: 24, color: Colors.white.withOpacity(0.12)),
                const SizedBox(height: 4),
                Text(getTxt('calculator_desc'), style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.32)), textAlign: TextAlign.center),
              ]),
            ),
        ]),
      )),
      _buildNumericKeyboard(onTap: widget.onKeyTap),
    ]);
  }

  Widget _buildTappableField(String label, String value, String fieldKey, Color color) {
    final bool isActive = widget.activeField == fieldKey;
    final String displayValue = value.isEmpty ? '0' : _addCommas(value);
    return GestureDetector(
      onTap: () => widget.onFieldTapped(fieldKey, value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(9),
          border: Border.all(color: isActive ? color.withOpacity(0.7) : Colors.white.withOpacity(0.12), width: 1.0),
          boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.08), blurRadius: 4)] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 9, color: isActive ? color : Colors.white38)),
          const SizedBox(height: 2),
          Row(children: [
            Expanded(child: Text(displayValue, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isActive ? color : Colors.white70))),
            if (isActive) Container(width: 2, height: 14, color: color),
          ]),
        ]),
      ),
    );
  }

  Widget _buildNumericKeyboard({required Function(String) onTap}) {
    final keys = [['9','8','7'],['6','5','4'],['3','2','1'],['.','0','⌫']];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1421),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: keys.map((row) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Row(children: row.map((key) {
          final bool isBack = key == '⌫';
          return Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => onTap(key),
              child: Container(
                height: 46,
                decoration: BoxDecoration(color: isBack ? const Color(0xFF1E293B) : const Color(0xFF131C2E), borderRadius: BorderRadius.circular(10)),
                child: Center(child: isBack
                    ? const Icon(Icons.backspace_outlined, color: Colors.blueAccent, size: 18)
                    : Text(key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))),
              ),
            ),
          ));
        }).toList()),
      )).toList()),
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor, IconData icon) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [Icon(icon, size: 12, color: Colors.white38), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54))]),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: valueColor)),
    ]);
  }
}