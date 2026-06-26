// ignore_for_file: deprecated_member_use
// lib/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../global_state.dart';
import '../main.dart';

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

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  bool _isAutomatic = true;
  late AnimationController _glowController;
  late AnimationController _swapController;
  late Animation<double> _glowAnim;
  late Animation<double> _swapAnim;

  String _addCommas(String raw) {
    if (raw.isEmpty) return '';
    final clean = raw.replaceAll(',', '');
    final parts = clean.split('.');
    final intPart = parts[0].replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    if (parts.length > 1) return '$intPart.${parts[1]}';
    return intPart;
  }

  String _getCurrencyFlag(String code) {
    if (code.contains('USD')) return '🇺🇸';
    if (code.contains('IQD')) return '🇮🇶';
    if (code.contains('IRR')) return '🇮🇷';
    if (code.contains('EUR')) return '🇪🇺';
    if (code.contains('GBP')) return '🇬🇧';
    return '🏳️';
  }

  String _getShortCode(String code) {
    return code
        .replaceAll('دۆلار ', '')
        .replaceAll('دینار ', '')
        .replaceAll('تمەن ', '')
        .replaceAll('یۆرۆ ', '')
        .replaceAll('پاوەند ', '');
  }

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _swapController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _glowAnim =
        Tween<double>(begin: 0.4, end: 1.0).animate(_glowController);
    _swapAnim = Tween<double>(begin: 0.0, end: math.pi)
        .animate(CurvedAnimation(parent: _swapController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  void _triggerSwap() {
    _swapController.forward(from: 0).then((_) => _swapController.reset());
    
    // پاشەکەوتکردنی کاتی بۆ دراوی یەکەم (From)
    final String tempCurrency = widget.fromCurrencySelected;
    
    // گۆڕینی دراوی یەکەم بۆ دراوی دووەم (To -> From)
    widget.onConverterFieldsChanged(
        widget.toCurrencySelected, widget.rateToIQD[widget.toCurrencySelected] ?? 1.0, true);
        
    // گۆڕینی دراوی دووەم بۆ دراوی یەکەم (From -> To)
    widget.onConverterFieldsChanged(
        tempCurrency, widget.rateToIQD[tempCurrency] ?? 1.0, false);
  }

  @override
  Widget build(BuildContext context) {
    final textDirection =
        appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Column(children: [
        _buildModernTabBar(),
        Expanded(
          child: TabBarView(
              controller: widget.tabController,
              children: [_buildConverterTab(), _buildProfitTab()]),
        ),
      ]),
    );
  }

  // ============================================================
  // TAB BAR
  // ============================================================
  Widget _buildModernTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: TabBar(
        controller: widget.tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0072FF).withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 0)
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelPadding: EdgeInsets.zero,
        labelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.swap_horiz_rounded, size: 15),
              const SizedBox(width: 5),
              Text(getTxt('exchange_tab')),
            ]),
          ),
          Tab(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.show_chart_rounded, size: 15),
              const SizedBox(width: 5),
              Text(getTxt('profit_tab')),
            ]),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONVERTER TAB
  // ============================================================
  Widget _buildConverterTab() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(children: [
            _buildAutoSourceRow(),
            const SizedBox(height: 10),
            _buildConverterCard(), 
          ]),
        ),
      ),
      _buildKeyboard(onTap: widget.onConverterTap, isConverter: true),
    ]);
  }

  // --- ئۆتۆماتیک / سەرچاوە ---
  Widget _buildAutoSourceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, __) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isAutomatic
                    ? const Color(0xFF4ADE80)
                    : Colors.orange,
                boxShadow: [
                  BoxShadow(
                    color: (_isAutomatic
                            ? const Color(0xFF4ADE80)
                            : Colors.orange)
                        .withOpacity(_glowAnim.value * 0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isAutomatic
                ? (appLanguageGlobal == 'English'
                    ? 'Auto Rate'
                    : 'نرخی ئۆتۆماتیک')
                : (appLanguageGlobal == 'English'
                    ? 'Manual'
                    : 'دەستی'),
            style: TextStyle(
              color: _isAutomatic
                  ? const Color(0xFF4ADE80)
                  : Colors.orange,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: _isAutomatic,
              activeColor: const Color(0xFF4ADE80),
              activeTrackColor: const Color(0xFF4ADE80).withOpacity(0.2),
              inactiveThumbColor: Colors.orange,
              inactiveTrackColor: Colors.orange.withOpacity(0.2),
              onChanged: (val) {
                setState(() {
                  _isAutomatic = val;
                  if (_isAutomatic) {
                    selectedBaseRateSourceGlobal = 'Sulaymaniyah Bourse';
                    BoursePremiumApp.rebuild(context);
                  }
                });
              },
            ),
          ),
        ]),
        if (!_isAutomatic)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBaseRateSourceGlobal,
                dropdownColor: const Color(0xFF131C2E),
                isDense: true,
                icon: const Icon(Icons.expand_more_rounded,
                    color: Colors.orange, size: 16),
                style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                items: [
                  DropdownMenuItem(
                      value: 'Central Bank',
                      child: Text(appLanguageGlobal == 'English'
                          ? 'Central Bank'
                          : 'بانکی ناوەندی')),
                  DropdownMenuItem(
                      value: 'Sulaymaniyah Bourse',
                      child: Text(appLanguageGlobal == 'English'
                          ? 'Slemani Bourse'
                          : 'بۆرسەی سلێمانی')),
                  DropdownMenuItem(
                      value: 'Baghdad Bourse',
                      child: Text(appLanguageGlobal == 'English'
                          ? 'Baghdad Bourse'
                          : 'بۆرسەی بەغداد')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(
                        () => selectedBaseRateSourceGlobal = val);
                    BoursePremiumApp.rebuild(context);
                  }
                },
              ),
            ),
          )
        else
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF4ADE80).withOpacity(0.25)),
            ),
            child: Text(
              '1 USD = ${formatDisplayNumbers(_addCommas(activeBaseUsdToIqdRate.toStringAsFixed(0)))} IQD',
              style: const TextStyle(
                  color: Color(0xFF4ADE80),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  // --- کارتی گشتی گۆڕینەوە ---
  Widget _buildConverterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32), 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0072FF).withOpacity(0.06),
            blurRadius: 32,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              _buildCurrencyRow(
                currency: widget.fromCurrencySelected,
                amount: widget.fromAmount,
                isFrom: true,
              ),
              const SizedBox(height: 14), 
              _buildCurrencyRow(
                currency: widget.toCurrencySelected,
                amount: widget.toAmount,
                isFrom: false,
              ),
            ],
          ),
          Positioned(
            left: appLanguageGlobal == 'English' ? null : 110, 
            right: appLanguageGlobal == 'English' ? 110 : null,
            child: _buildDividerWithSwap(),
          ),
        ],
      ),
    );
  }

  // --- دوو لاکێشە ناوەکییە کورتەکان ---
  Widget _buildCurrencyRow({
    required String currency,
    required String amount,
    required bool isFrom,
  }) {
    final String flag = _getCurrencyFlag(currency);
    final String shortCode = _getShortCode(currency);
    final bool isEmpty = amount.isEmpty || amount == '0' || amount == '';
    final Color amountColor = isFrom ? Colors.white : const Color(0xFF4ADE80);

    return Container(
      height: 54, 
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E).withOpacity(0.4), 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
      ),
      child: Row(children: [
        // ناوی دراوەکە
        GestureDetector(
          onTap: () {},
          child: Stack(alignment: Alignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: isFrom
                    ? const Color(0xFF0072FF).withOpacity(0.08)
                    : const Color(0xFF4ADE80).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isFrom
                      ? const Color(0xFF0072FF).withOpacity(0.15)
                      : const Color(0xFF4ADE80).withOpacity(0.15),
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  shortCode,
                  style: TextStyle(
                    color: isFrom ? const Color(0xFF4FC3F7) : const Color(0xFF4ADE80),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isFrom
                      ? const Color(0xFF4FC3F7).withOpacity(0.6)
                      : const Color(0xFF4ADE80).withOpacity(0.6),
                  size: 13,
                ),
              ]),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.0,
                child: DropdownButton<String>(
                  value: currency,
                  items: widget.availableCurrencies
                      .map((val) => DropdownMenuItem<String>(
                          value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.onConverterFieldsChanged(
                          val, widget.rateToIQD[val] ?? 1.0, isFrom);
                    }
                  },
                ),
              ),
            ),
          ]),
        ),
        
        // هێڵی جیاکەرەوە
        Container(
          height: 18,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: VerticalDivider(
            color: Colors.white.withOpacity(0.1),
            thickness: 1,
          ),
        ),

        // بڕەکە
        Expanded(
          child: Text(
            isEmpty
                ? (appLanguageGlobal == 'English' ? 'Enter amount' : 'بڕێک بنووسە')
                : formatDisplayNumbers(amount),
            style: TextStyle(
              color: isEmpty ? Colors.white.withOpacity(0.2) : amountColor,
              fontSize: isEmpty ? 11 : 15,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }

  Widget _buildDividerWithSwap() {
    return AnimatedBuilder(
      animation: _swapAnim,
      builder: (_, child) => Transform.rotate(
        angle: _swapAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _triggerSwap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF4ADE80).withOpacity(0.4),
                width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ADE80).withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: const Icon(Icons.swap_vert_rounded,
              color: Color(0xFF4ADE80), size: 16),
        ),
      ),
    );
  }

  // ============================================================
  // PROFIT TAB
  // ============================================================
  Widget _buildProfitTab() {
    final bool isProfit = widget.profitResult != null &&
        (widget.profitResult!['isProfit'] as bool? ?? false);
    final Color resultColor = widget.profitResult == null
        ? Colors.grey
        : isProfit
            ? const Color(0xFF4ADE80)
            : const Color(0xFFFF6B6B);

    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(children: [
            _buildProfitCurrencySelector(),
            const SizedBox(height: 12),
            _buildInputGrid(),
            const SizedBox(height: 12),
            _buildCalculateButton(),
            const SizedBox(height: 12),
            if (widget.profitResult != null)
              _buildResultCard(isProfit, resultColor)
            else
              _buildEmptyResult(),
          ]),
        ),
      ),
      _buildKeyboard(onTap: widget.onKeyTap, isConverter: false),
    ]);
  }

  Widget _buildProfitCurrencySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0072FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.currency_exchange_rounded,
                    color: Color(0xFF4FC3F7), size: 14),
              ),
              const SizedBox(width: 10),
              Text(
                appLanguageGlobal == 'English'
                    ? 'Base Currency'
                    : 'دراوی بنەڕەت',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.7)),
              ),
            ]),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.selectedCurrency,
                dropdownColor: const Color(0xFF131C2E),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF4FC3F7), size: 18),
                style: const TextStyle(
                    color: Color(0xFF4FC3F7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                items: widget.availableCurrencies
                    .map((val) => DropdownMenuItem<String>(
                        value: val,
                        child: Text(getCurrencyDisplayName(val))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) widget.onProfitCurrencyChanged(val);
                },
              ),
            ),
          ]),
    );
  }

  Widget _buildInputGrid() {
    return Column(children: [
      Row(children: [
        Expanded(
            child: _buildModernField(
                getTxt('amount_label'),
                widget.amountVal,
                'amount',
                const Color(0xFF0072FF),
                Icons.attach_money_rounded)),
        const SizedBox(width: 10),
        Expanded(
            child: _buildModernField(
                getTxt('buy_price_label'),
                widget.buyPriceVal,
                'buy',
                const Color(0xFFFF6B6B),
                Icons.trending_down_rounded)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
            child: _buildModernField(
                getTxt('sell_price_label'),
                widget.sellPriceVal,
                'sell',
                const Color(0xFF4ADE80),
                Icons.trending_up_rounded)),
        const SizedBox(width: 10),
        Expanded(
            child: _buildModernField(
                getTxt('commission_label'),
                widget.commissionVal,
                'commission',
                const Color(0xFFEAB308),
                Icons.percent_rounded)),
      ]),
    ]);
  }

  Widget _buildModernField(String label, String value, String fieldKey,
      Color color, IconData icon) {
    final bool isActive = widget.activeField == fieldKey;
    final String display = value.isEmpty ? '' : _addCommas(value);

    return GestureDetector(
      onTap: () => widget.onFieldTapped(fieldKey, value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? color.withOpacity(0.06)
              : const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? color.withOpacity(0.5)
                : Colors.white.withOpacity(0.07),
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 12, color: isActive ? color : Colors.white24),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 9.5,
                    color: isActive
                        ? color.withOpacity(0.9)
                        : Colors.white.withOpacity(0.35),
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(
              child: Text(
                display.isEmpty
                    ? (appLanguageGlobal == 'English' ? 'Tap to enter' : 'بنووسە')
                    : formatDisplayNumbers(display),
                style: TextStyle(
                  fontSize: display.isEmpty ? 11 : 16,
                  fontWeight: FontWeight.w900,
                  color: display.isEmpty
                      ? Colors.white.withOpacity(0.15)
                      : (isActive ? color : Colors.white.withOpacity(0.85)),
                ),
              ),
            ),
            if (isActive)
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => Opacity(
                  opacity: _glowAnim.value,
                  child: Container(
                      width: 2, height: 18, color: color),
                ),
              ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return GestureDetector(
      onTap: widget.onCalculateProfit,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0072FF).withOpacity(0.35),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.calculate_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            getTxt('calculate_btn'),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
        ]),
      ),
    );
  }

  Widget _buildResultCard(bool isProfit, Color resultColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: resultColor.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: resultColor.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: resultColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    isProfit
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: resultColor,
                    size: 22),
                const SizedBox(width: 10),
                Text(
                  isProfit
                      ? getTxt('profit_won')
                      : getTxt('profit_lost'),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: resultColor),
                ),
              ]),
        ),
        const SizedBox(height: 14),
        _buildResultRow(
          getTxt('profit_iqd_label'),
          '${(widget.profitResult!['profitIQD'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers(_addCommas((widget.profitResult!['profitIQD'] as double).toStringAsFixed(0)))} د.ع',
          resultColor,
          Icons.monetization_on_rounded,
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          '${getTxt('profit_curr_label')} ${widget.profitResult!['currency']}',
          '${(widget.profitResult!['profitCurrency'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers(_addCommas((widget.profitResult!['profitCurrency'] as double).toStringAsFixed(2)))}',
          resultColor,
          Icons.currency_exchange_rounded,
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          getTxt('profit_percent_label'),
          '${(widget.profitResult!['profitPercent'] as double) >= 0 ? '+' : ''}${formatDisplayNumbers((widget.profitResult!['profitPercent'] as double).toStringAsFixed(2))}٪',
          resultColor,
          Icons.percent_rounded,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
              color: Colors.white.withOpacity(0.06), height: 1),
        ),
        _buildResultRow(
          getTxt('commission_iqd'),
          '${formatDisplayNumbers(_addCommas((widget.profitResult!['commissionAmount'] as double).toStringAsFixed(0)))} د.ع',
          Colors.orange,
          Icons.receipt_long_rounded,
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          getTxt('total_sell'),
          '${formatDisplayNumbers(_addCommas((widget.profitResult!['totalSell'] as double).toStringAsFixed(0)))} د.ع',
          Colors.white60,
          Icons.sell_rounded,
        ),
      ]),
    );
  }

  Widget _buildEmptyResult() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(children: [
        Icon(Icons.calculate_outlined,
            size: 36, color: Colors.white.withOpacity(0.08)),
        const SizedBox(height: 8),
        Text(
          getTxt('calculator_desc'),
          style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.25)),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  Widget _buildResultRow(
      String label, String value, Color valueColor, IconData icon) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon,
                size: 13,
                color: valueColor.withOpacity(0.5)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 10.5, color: Colors.white54)),
          ]),
          Text(value,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: valueColor)),
        ]);
  }

  // ============================================================
  // KEYBOARD
  // ============================================================
  Widget _buildKeyboard(
      {required Function(String) onTap, required bool isConverter}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(56, 0, 56, 0),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF080C12),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          _buildSpecialKey('⌫', onTap,
              bgColor: const Color(0xFF1A0808),
              iconColor: const Color(0xFFFF6B6B)),
          _buildKey('9', onTap),
          _buildKey('8', onTap),
          _buildKey('7', onTap),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          _buildSpecialKey('C', onTap,
              bgColor: const Color(0xFF0D1117),
              textColor: Colors.orange),
          _buildKey('6', onTap),
          _buildKey('5', onTap),
          _buildKey('4', onTap),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          _buildKey('.', onTap),
          _buildKey('3', onTap),
          _buildKey('2', onTap),
          _buildKey('1', onTap),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          _buildSpecialKey('⇅', onTap,
              bgColor: const Color(0xFF4ADE80).withOpacity(0.06),
              iconColor: const Color(0xFF4ADE80),
              flex: 1),
          _buildKey('000', onTap, flex: 1),
          _buildKey('0', onTap, flex: 2),
        ]),
      ]),
    );
  }

  Widget _buildKey(String key, Function(String) onTap, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () => onTap(key),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withOpacity(0.07)),
            ),
            child: Center(
              child: Text(
                key,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(
    String key,
    Function(String) onTap, {
    required Color bgColor,
    Color? iconColor,
    Color? textColor,
    int flex = 1,
  }) {
    final bool isDelete = key == '⌫';
    final bool isSwap = key == '⇅';

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () => onTap(key),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSwap
                    ? const Color(0xFF4ADE80).withOpacity(0.2)
                    : isDelete
                        ? const Color(0xFFFF6B6B).withOpacity(0.15)
                        : Colors.white.withOpacity(0.06),
              ),
            ),
            child: Center(
              child: isDelete
                  ? Icon(Icons.backspace_outlined,
                      color: iconColor, size: 15)
                  : isSwap
                      ? Icon(Icons.swap_vert_rounded,
                          color: iconColor, size: 16)
                      : Text(
                          key,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor ?? Colors.white),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}