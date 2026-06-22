// ignore_for_file: deprecated_member_use
// lib/screens/offices_screen.dart

import 'package:flutter/material.dart';
import '../models/office_model.dart';
import '../global_state.dart';

class OfficesScreen extends StatefulWidget {
  final List<OfficeModel> offices;
  const OfficesScreen({super.key, required this.offices});
  @override
  State<OfficesScreen> createState() => _OfficesScreenState();
}

class _OfficesScreenState extends State<OfficesScreen> {
  String _searchText = '';
  String _selectedCity = 'هەمووی';
  final TextEditingController _searchController = TextEditingController();

  List<String> get cities { 
    final Set<String> c = {'هەمووی'}; 
    for (final o in widget.offices) {
      c.add(o.city); 
    }
    return c.toList(); 
  }
  
  List<OfficeModel> get filtered => widget.offices.where((o) {
    final matchCity = _selectedCity == 'هەمووی' || o.city == _selectedCity;
    final matchSearch = _searchText.isEmpty || o.name.contains(_searchText) || o.city.contains(_searchText);
    return matchCity && matchSearch;
  }).toList()..sort((a, b) => b.rating.compareTo(a.rating));

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Container(
        color: const Color(0xFF0B121F),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
            ),
            child: Row(children: [
              const Icon(Icons.search_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none, 
                  hintText: getTxt('search_hint'), 
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)
                ),
                onChanged: (v) => setState(() => _searchText = v),
              )),
              if (_searchText.isNotEmpty)
                GestureDetector(onTap: () { _searchController.clear(); setState(() => _searchText = ''); }, child: const Icon(Icons.close_rounded, color: Colors.white, size: 18)),
            ]),
          ),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              itemCount: cities.length,
              itemBuilder: (context, i) {
                final city = cities[i];
                final bool isSelected = _selectedCity == city;
                // وەرگێڕانی تاقیکردنەوە شاری هەمووی بۆ سێ زمانی جیاواز
                final cityDisplay = city == 'هەمووی' ? getTxt('all_cities') : getCityName(city);
                return GestureDetector(
                  onTap: () => setState(() => _selectedCity = city),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: isSelected ? const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]) : null,
                      color: isSelected ? null : const Color(0xFF131C2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: Center(child: Text(cityDisplay, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white.withOpacity(0.8)))),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${formatDisplayNumbers(filtered.length.toString())} ${getTxt('offices_found')}', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold)),
            ]),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.storefront_rounded, size: 40, color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 10),
                    Text(getTxt('no_office'), style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final office = filtered[i];
                      final openTxt = office.isOpen ? getTxt('open_status') : getTxt('closed_status');
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OfficeDashboard(office: office))),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF131C2E),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                          ),
                          child: Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                              ),
                              child: Center(child: Text(office.emoji, style: const TextStyle(fontSize: 22))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(office.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 5),
                              Row(children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: office.isOpen ? const Color(0xFF4ADE80) : Colors.grey, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text(openTxt, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: office.isOpen ? const Color(0xFF4ADE80) : Colors.white.withOpacity(0.5))),
                                Text(' (${formatDisplayNumbers(office.openTime)} - ${formatDisplayNumbers(office.closeTime)})', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w500)),
                              ]),
                            ])),
                            Icon(
                              appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, 
                              size: 14, 
                              color: Colors.white.withOpacity(0.5)
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class OfficeDashboard extends StatelessWidget {
  final OfficeModel office;
  const OfficeDashboard({super.key, required this.office}); // چالاککردنی کلیلی فەرمی

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
    final openTxt = office.isOpen ? getTxt('open_status') : getTxt('closed_status');

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(color: Color(0xFF0F172A), border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1))),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context), 
                child: Container(
                  padding: const EdgeInsets.all(8), 
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)), 
                  child: Icon(
                    appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, 
                    color: Colors.white, 
                    size: 16
                  )
                )
              ),
              const SizedBox(width: 10),
              Text(office.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(office.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(getCityName(office.city), style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: office.isOpen ? const Color(0xFF4ADE80).withOpacity(0.15) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: office.isOpen ? const Color(0xFF4ADE80).withOpacity(0.4) : Colors.grey.withOpacity(0.3)),
                ),
                child: Row(children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: office.isOpen ? const Color(0xFF4ADE80) : Colors.grey, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text(openTxt, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: office.isOpen ? const Color(0xFF4ADE80) : Colors.grey)),
                ]),
              ),
            ]),
          ),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1565C0)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: const Color(0xFF0072FF).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTxt('rating'), style: const TextStyle(fontSize: 10, color: Colors.white60)),
                    const SizedBox(height: 4),
                    Row(children: [...List.generate(5, (i) => Icon(i < office.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: const Color(0xFFFFD700))), const SizedBox(width: 6), Text(formatDisplayNumbers(office.rating.toStringAsFixed(1)), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))]),
                    Text('${formatDisplayNumbers(office.reviewCount.toString())} ${getTxt('review_count')}', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(getTxt('working_hours'), style: const TextStyle(fontSize: 10, color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text('${formatDisplayNumbers(office.openTime)} - ${formatDisplayNumbers(office.closeTime)}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(office.isOpen ? '✅ $openTxt' : '🔒 $openTxt', style: TextStyle(fontSize: 10, color: office.isOpen ? const Color(0xFF4ADE80) : Colors.redAccent)),
                  ]),
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(children: [
                  _infoRow(Icons.location_on_rounded, getTxt('address_label'), '${getCityName(office.city)} - ${office.address}', Colors.blueAccent),
                  const SizedBox(height: 10),
                  _infoRow(Icons.phone_rounded, getTxt('phone_label'), formatDisplayNumbers(office.phone), const Color(0xFF4ADE80)),
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.monetization_on_rounded, size: 14, color: Colors.blueAccent), const SizedBox(width: 6), Text(getTxt('services_label'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white))]),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: office.services.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: const Color(0xFF0072FF).withOpacity(0.3), blurRadius: 6)],
                    ),
                    child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  )).toList()),
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.chat_bubble_rounded, size: 14, color: Colors.blueAccent), const SizedBox(width: 6), Text(getTxt('reviews_label'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white))]),
                  const SizedBox(height: 10),
                  ...office.reviews.map((review) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E293B))),
                    child: Row(children: [
                      Container(width: 28, height: 28, decoration: BoxDecoration(color: const Color(0xFF0072FF).withOpacity(0.2), shape: BoxShape.circle), child: const Center(child: Text('👤', style: TextStyle(fontSize: 14)))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(review, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8)))),
                      const SizedBox(width: 6),
                      Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 10, color: i < 4 ? const Color(0xFFFFD700) : Colors.grey))),
                    ]),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF059669)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF4ADE80).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('${getTxt('call_btn')} — ${formatDisplayNumbers(office.phone)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFF0072FF).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 18),
                  const SizedBox(width: 8),
                  Text(getTxt('subscribe_btn'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
                ]),
              ),
            ]),
          )),
        ])),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      ])),
    ]);
  }
}