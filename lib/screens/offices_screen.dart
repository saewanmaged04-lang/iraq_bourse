// ignore_for_file: deprecated_member_use
// lib/screens/offices_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // hawerdekrdny url_launcher bo pewandykrdny layf
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
    // فلتەرکردنی گەڕانەکە لەگەڵ ناوی داینامیکی وەرگێڕدراوی نووسینگەکان
    final matchSearch = _searchText.isEmpty || getTxt('office_${o.id}').contains(_searchText) || o.name.contains(_searchText) || o.city.contains(_searchText);
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
                              Text(getTxt('office_${office.id}'), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis), 
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

// ============================================================
// تەواوی پێکهاتەی نوێی پیشاندانی وردەکاری نووسینگەکان
// ============================================================
class OfficeDashboard extends StatelessWidget {
  final OfficeModel office;
  const OfficeDashboard({super.key, required this.office});

  List<Map<String, String>> _getOfficeStaff() {
    final bool isEnglish = appLanguageGlobal == 'English';
    final bool isArabic = appLanguageGlobal == 'العربية';

    if (office.id == '1') {
      return [
        {
          'name': isEnglish ? 'Awât Sadiq' : (isArabic ? 'آوات صديق' : 'ئاوات سدیق'), 
          'phone': '+964 770 123 4567'
        },
        {
          'name': isEnglish ? 'Hiwa Karim' : (isArabic ? 'هيوا كريم' : 'هیوا کەریم'), 
          'phone': '+964 770 987 6543'
        },
      ];
    } else {
      return [
        {
          'name': isEnglish ? 'Soran Rashid' : (isArabic ? 'سوران رشيد' : 'سۆران ڕەشید'), 
          'phone': '+964 750 123 4567'
        },
        {
          'name': isEnglish ? 'Dilan Aziz' : (isArabic ? 'ديلان عزيز' : 'دیلان عەزیز'), 
          'phone': '+964 750 765 4321'
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
    final openTxt = office.isOpen ? getTxt('open_status') : getTxt('closed_status');
    final staffList = _getOfficeStaff();

    final String staffSectionTitle = getTxt('office_staff_header');
    final String staffPrefix = getTxt('office_staff_prefix');

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F), 
        body: SafeArea(
          child: Column(
            children: [
              // ١. هێدەر و دوگمەی گەڕانەوە
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  const SizedBox(width: 12),
                  Text(office.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTxt('office_${office.id}'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis), 
                    Text(getCityName(office.city), style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
                  ])),
                ]),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 🔴 لاکێشەی یەکەم: کاتی کارکردن
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131C2E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.access_time_filled_rounded, color: Color(0xFFECC880), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              getTxt('office_working_hours_header'), 
                              style: const TextStyle(color: Color(0xFFECC880), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${getTxt('working_hours')}:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                            Text('${formatDisplayNumbers(office.openTime)} - ${formatDisplayNumbers(office.closeTime)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTxt('office_live_status'), style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)), 
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: office.isOpen ? const Color(0xFF4ADE80).withOpacity(0.12) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                Container(width: 6, height: 6, decoration: BoxDecoration(color: office.isOpen ? const Color(0xFF4ADE80) : Colors.grey, shape: BoxShape.circle)),
                                const SizedBox(width: 5),
                                Text(openTxt, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: office.isOpen ? const Color(0xFF4ADE80) : Colors.grey)),
                              ]),
                            ),
                          ]),
                        ]),
                      ),
                      const SizedBox(height: 12),

                      // 🔴 لاکێشەی دووەم: ناونیشان و خزمەتگوزارییەکان
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131C2E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.home_work_rounded, color: Color(0xFF00C6FF), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              getTxt('office_address_services_header'), 
                              style: const TextStyle(color: Color(0xFF00C6FF), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${getTxt('address_label')}:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                            Text('${getCityName(office.city)} - ${office.address}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 12),
                          Text('${getTxt('services_label')}:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                          const SizedBox(height: 8),
                          Wrap(spacing: 6, runSpacing: 6, children: office.services.map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              getTxt(s), 
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                          )).toList()),
                        ]),
                      ),
                      const SizedBox(height: 12),

                      // 🔴 لاکێشەی سێیەم: ناوی کارمەندان بە ڕیزبەندی جێگیری چەپ بۆ ڕاست
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131C2E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.people_alt_rounded, color: Color(0xFF76C917), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              staffSectionTitle, 
                              style: const TextStyle(color: Color(0xFF76C917), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          ...staffList.map((staff) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B121F),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.04)),
                            ),
                            child: Row(children: [
                              Expanded(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '$staffPrefix${staff['name']!}', 
                                      style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold)
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•', 
                                      style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12)
                                    ),
                                    const SizedBox(width: 6),
                                    // 🔹 ڕاستکردنەوەی بنەڕەتی ژمارەی مۆبایلەکان بە بەکارهێنانی کۆدی یونیکۆدی LTR ی فەرمی (\u200E) بەبێ formatDisplayNumbers
                                    Text(
                                      '\u200E${staff['phone']!}', 
                                      textDirection: TextDirection.ltr, 
                                      style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Row(children: [
                                GestureDetector(
                                  onTap: () async {
                                    final cleanNumber = staff['phone']!.replaceAll(' ', '').replaceAll('+', '');
                                    final message = Uri.encodeComponent(
                                      appLanguageGlobal == 'English'
                                          ? "Hello, I am using the app and have a question regarding your office..."
                                          : (appLanguageGlobal == 'العربية'
                                              ? "مرحباً يا فندم، أنا أحد مستخدمي التطبيق ولدي استفسار بخصوص مكتبكم..."
                                              : "سڵاو کارمەندی بەڕێز، من یەکێک لە بەکارهێنەرانی ئەپەکەم و پرسیارم هەیە سەبارەت بە نوسینگەکەتان..."),
                                    );
                                    final Uri url = Uri.parse('https://wa.me/$cleanNumber?text=$message');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: const Color(0xFF25D366).withOpacity(0.12), shape: BoxShape.circle),
                                    child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    final cleanNumber = staff['phone']!.replaceAll(' ', '');
                                    final Uri url = Uri.parse('tel:$cleanNumber');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: const Color(0xFF0072FF).withOpacity(0.12), shape: BoxShape.circle),
                                    child: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF4FC3F7), size: 13),
                                  ),
                                ),
                              ]),
                            ]),
                          )),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}