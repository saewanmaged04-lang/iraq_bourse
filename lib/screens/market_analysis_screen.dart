// ignore_for_file: deprecated_member_use
// lib/screens/market_analysis_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math; // هاوردەکردنی ماتماتیک
import '../global_state.dart';

// ============================================================
// ڕەنگە ڕاستەقینەکانی فەیسبووک (Dark Mode)
// ============================================================
const Color kPageBg = Color(0xFF18191A);
const Color kCardBg = Color(0xFF242526);
const Color kCardBg2 = Color(0xFF3A3B3C);
const Color kDividerLine = Color(0xFF3E4042);
const Color kTextPrimary = Color(0xFFE4E6EB);
const Color kTextSecondary = Color(0xFFB0B3B8);
const Color kFbBlue = Color(0xFF2374E1);
const Color kFbBlueLight = Color(0xFF4599FF);

// ============================================================
// مۆدێلەکان
// ============================================================
class AnalystModel {
  final String id, name, title, emoji, description;
  final String? imagePath;
  final List<VideoAnalysis> videos;
  final List<WrittenAnalysis> articles;
  final String language; // 🔹 گۆڕاوی زمان: 'Kurdish' یان 'Arabic'

  const AnalystModel({
    required this.id, required this.name, required this.title,
    required this.emoji, required this.description,
    this.imagePath,
    required this.videos, required this.articles,
    required this.language, // 🔹 جێگیرکردنی زمان
  });
}

class VideoAnalysis {
  final String id, title, youtubeUrl, duration, date, longDescription;
  const VideoAnalysis({
    required this.id, required this.title, required this.youtubeUrl,
    required this.duration, required this.date, required this.longDescription,
  });
}

// خانەی نوێ: imageUrl (ئۆپشناڵ) بۆ ئەوەی بتوانی وێنە لەگەڵ وتار دابنێیت
class WrittenAnalysis {
  final String id, title, content, date;
  final String? imageUrl;
  const WrittenAnalysis({
    required this.id, required this.title,
    required this.content, required this.date,
    this.imageUrl,
  });
}

class SystemNotification {
  final String id, title, body, date;
  SystemNotification({required this.id, required this.title, required this.body, required this.date});
}

String? extractYoutubeId(String url) {
  final RegExp regExp = RegExp(
    r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    caseSensitive: false,
  );
  return regExp.firstMatch(url)?.group(1);
}

Widget _buildLinkableText(String text, TextStyle baseStyle, Color linkColor) {
  final RegExp linkRegExp = RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);
  final List<TextSpan> spans = [];
  int start = 0;
  for (final match in linkRegExp.allMatches(text)) {
    if (match.start > start) {
      spans.add(TextSpan(text: text.substring(start, match.start))); // لێرەدا بۆڵد و سپی ناوەکی دەپارێزێت
    }
    final String link = match.group(0)!;
    spans.add(TextSpan(
      text: link,
      style: TextStyle(
        color: linkColor, 
        decoration: TextDecoration.underline, 
        fontWeight: FontWeight.bold
      ),
    ));
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start))); // لێرەدا بۆڵد و سپی کۆتایی دەپارێزێت
  }
  return RichText(
    text: TextSpan(style: baseStyle, children: spans), // 🔹 گواستنەوەی فەرمی ستایلەکە بۆ ناو دەقی سەرەکی
    textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
  );
}

final List<SystemNotification> _globalNotifications = [
  SystemNotification(id: 'n1', title: 'شیکاریی گرنگی ئەمڕۆ بۆ دۆلار! 🚨', body: 'د. ڕێبین جەمال شیکارییەکی زۆر وردی لەسەر جووڵەی بازارەکانی سلێمانی و بەغداد بڵاوکردەوە.', date: '٢٩/٦/٢٠٢٦'),
  SystemNotification(id: 'n2', title: 'نوێکردنەوەی نرخەکانی بۆرسە 📊', body: 'سەرجەم نرخەکانی بۆرسەی شارەکان و دراوە جیهانییەکان لە بازاردا بە لایڤی نوێکرانەوە.', date: '٢٨/٦/٢٠٢٦'),
];

// ✅ لێرەدا لیستی شیکارکارەکان نوێکراوەتەوە بۆ هەم کورد و هەم عەرەبە لۆکاڵییە بەڕێزەکان
final List<AnalystModel> _mockAnalysts = [
  const AnalystModel(
    id: 'a1', name: 'د. ڕێبین جەمال',
    title: 'پڕۆفیسۆری سیاسەتی دارایی عێراق',
    emoji: '👨‍🏫', imagePath: null,
    description: 'پسپۆڕی سەرەکی سیاسەتی دراو و چاودێری جووڵەی بازارەکانی عێراق.',
    language: 'Kurdish', // 🔹 کوری
    videos: [
      VideoAnalysis(id: 'v1', title: 'شیکاریی نوێ: بەهای دۆلار بەرامبەر دینار بۆ کۆتایی ساڵی ٢٠٢٦', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '12:45', date: '٢٧/٦/٢٠٢٦', longDescription: 'لەم ڤیدیۆیەدا، دکتۆر ڕێبین شیکارییەکی زۆر ورد پێشکەش دەکات سەبارەت بە هەڵئاوسانی نێوخۆیی و بڕیارە درەنگوەختەکانی بانکی ناوەندی عێراق کە ڕاستەوخۆ کاریگەری لەسەر بەهای بازاڕی هاوتەریبی دۆلار دادەنێت لە بازارەکانی سلێمانی و بەغداد. زۆر گرنگی بۆ ئەوانەی کە سەرمایەیان هەیە.'),
      VideoAnalysis(id: 'v2', title: 'کاریگەری بڕیارەکانی بانکی ناوەندی لەسەر بەهای بازاڕ', youtubeUrl: 'https://www.youtube.com/watch?v=y6Sxv-sUYtM', duration: '09:15', date: '٢٠/٦/٢٠٢٦', longDescription: 'لەم بابەتەدا، بە قووڵی باس لە ستراتیژی تەمویلکردنی نوێ دەکرێت کە چۆن گۆڕانکاری بەسەر جوڵەی بازرگانی گشتی دەهێنێت و چۆن کار دەکاتە سەر کەمکردنەوەی جیاوازی نێوان نرخی فەرمی و نافەرمی دۆلار.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art1', title: 'سیستمی تەمویلکردنی بازرگانی گشتی و کێشەی بازارە هاوتەریبەکان', content: 'لەم شڕۆڤە فەرمییەدا, بە تەواوی ئاماژە بە هۆکارەکانی بەرزبوونەوەی کاتیی بەهای فرۆشتنی دۆلار لە بازارەکانی سلێمانی و بەغداد دەکەین. بۆ خوێندنەوەی ڕاپۆتی فەرمی بانکی ناوەندی عێراق سەردانی ئەم بەستەرە بکە: https://cbi.iq هۆکاری سەرەکی گرفتەکە بریتییە لە نەبوونی متمانەی تەواوی نووسینگە بازرگانییە کاتییەکان بە مێتۆدە ئەلەکترۆنییەکان.', date: '٢٧/٦/٢٠٢٦'),
      WrittenAnalysis(id: 'art2', title: 'پێشبینییەکانی تمەن بەرامبەر دۆلار بەپێی جووڵە نێودەوڵەتییەکان', content: 'جووڵەی دراوی تمەنی ئێرانی بە تەواوی بەستراوەتەوە بە سیاسەتە نێودەوڵەتییە گشتییەکان. هۆکاری جێگیربوونی نرخەکە لە کاتی نوێدا بۆ پەیوەندییە هاوبەشە بازرگانییەکان دەگەڕێتەوە، بەڵام پێشبینی دەکرێت لە مانگەکانی داهاتوودا سەرلەنوێ کێشە لە توانای دارایی بازارە کاتییەکانی تمەندا دروست ببێتەوە.', date: '٢٥/٦/٢٠٢٦'),
    ],
  ),
  const AnalystModel(
    id: 'a2', name: 'هەورامان عومەر',
    title: 'شرۆڤەکاری دارایی و ڕاوێژکاری بۆرسەی سلێمانی',
    emoji: '📊', imagePath: null,
    description: 'شرۆڤەکاری لایڤی جووڵەی بازار و بۆرسەی بەغداد و سلێمانی.',
    language: 'Kurdish', // 🔹 کوری
    videos: [
      VideoAnalysis(id: 'v3', title: 'کلیلەکانی سەرکەوتن لە کڕین و فرۆشتنی بازاڕی بۆرسەدا', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '15:20', date: '٢٥/٦/٢٠٢٦', longDescription: 'تەواوی مەرج و یاساکانی سەرکەوتن لە کڕین و فرۆشتنی سەرەکی لەم کورتە شرۆڤەیەدا کۆکراوەتەوە، کە یارمەتیدەرێکی بەهێزی بازرگانانی سەرەکی دراو دەبێت.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art3', title: 'گرنگی حاسیبە و نرخە لایڤەکان بۆ کۆنتڕۆڵکردنی سەرمایەکان', content: 'هەموو بازرگانێکی دراو پێویستی بە مێکانیزمی خێرا هەیە بۆ کۆنتڕۆڵکردنی قازانج و زیان. بەکارهێنانی نرخەکانی لایڤی بازار لەبری نرخە کۆنەکان هێزی دڵنیایی دەبەخشێت بە بازرگانان تا بتوانن لە خێراترین کاتدا بڕیاردان لەسەر سەفقە گەورەکان دەدەن.', date: '٢٠/٦/٢٠٢٦'),
    ],
  ),
  // 🔹 زیادکردنی شرۆڤەکارە عەرەبییەکان بە وەرگێڕانی تۆخی فەرمی عەرەبی
  const AnalystModel(
    id: 'a3', name: 'أ. أحمد الجبوري',
    title: 'خبير السياسات النقدية ومحلل أسواق الصرف',
    emoji: '👨‍💼', imagePath: null,
    description: 'مستشار مالي عراقي ومتابع لحركة البورصات العراقية والعالمية اليومية لأسعار الدولار.',
    language: 'Arabic', // 🔹 عەرەبی
    videos: [
      VideoAnalysis(id: 'v4', title: 'التحليل الأسبوعي: اتجاهات سعر صرف الدولار مقابل الدينار العراقي لعام ٢٠٢٦', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '10:15', date: '٢٩/٦/٢٠٢٦', longDescription: 'يقدم الأستاذ أحمد الجبوري تحليلاً دقيقاً لسيولة الدينار العراقي والتحويلات المالية عبر المنصة الإلكترونية وأثرها المباشر على أسعار الصرف في الأسواق المحلية.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art4', title: 'تأثير السيولة النقدية للبنك المركزي على حركة مكاتب الصيرفة في بغداد', content: 'نناقش في هذا المقال آليات البنك المركزي الجديدة لتمويل التجارة الخارجية وسد حاجة السوق المحلي للدولار والخطوات المتبعة لاستقرار سعر الصرف في البورصات العراقية. لمزيد من المعلومات، يرجى زيارة الموقع الرسمي للبنك المركزي العراقي: https://cbi.iq', date: '٢٩/٦/٢٠٢٦'),
    ],
  ),
  const AnalystModel(
    id: 'a4', name: 'المستشار عمر الحديثي',
    title: 'مستشار أسواق الأسهم والعملات النقدية والبورصات المحلية',
    emoji: '📈', imagePath: null,
    description: 'محلل مالي يومي ومتابع لحركات البيع والشراء الفوري في بورصتي الكفاح والحارثية.',
    language: 'Arabic', // 🔹 عەرەبی
    videos: [
      VideoAnalysis(id: 'v5', title: 'أسرار التداول والاستثمار المالي الناجح في أسواق الصرف العراقية', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '14:30', date: '٢٨/٦/٢٠٢٦', longDescription: 'شرح كامل حول آليات حماية رأس المال والتحليلات الأساسية الواجب اتباعها من قبل التجار والمكاتب المالية لتجنب تذبذبات الصرف الفورية.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art5', title: 'أهمية الاعتماد على المنصات الرقمية المعتمدة للتحويلات الفورية', content: 'إن التحول المالي الرقمي هو الحل الأمثل لضمان وصول التمويل للتجار بأسعار مناسبة وضمان خفض الفجوة بين السعر الرسمي والوازي للدولار مقابل الدينار العراقي.', date: '٢٨/٦/٢٠٢٦'),
    ],
  ),
];

// فەنکشنە گرنگەکان بە سەرکەوتوویی گەڕێنراونەتەوە شوێنی خۆیان بۆ نەهێشتنی تەواوی ئیرۆڕەکان [2]
Widget _buildDynamicAvatar(String? imagePath, String emoji, double size) {
  if (imagePath != null && imagePath.isNotEmpty) {
    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _emojiFallback(emoji, size));
    }
    return Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _emojiFallback(emoji, size));
  }
  return _emojiFallback(emoji, size);
}

Widget _emojiFallback(String emoji, double size) => Center(child: Text(emoji, style: TextStyle(fontSize: size)));

// ============================================================
// شاشەی سەرەکی
// ============================================================
class MarketAnalysisScreen extends StatefulWidget {
  const MarketAnalysisScreen({super.key});
  @override
  State<MarketAnalysisScreen> createState() => _MarketAnalysisScreenState();
}

class _MarketAnalysisScreenState extends State<MarketAnalysisScreen> {
  // 🔹 فلتەری سەرەکی دەسپێک لەسەر کورد دابینکراوە
  String _selectedLanguageFilter = 'Kurdish'; 

  void _showNotificationCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    appLanguageGlobal == 'English' ? 'Official Notifications' : (appLanguageGlobal == 'العربية' ? 'الإشعارات الرسمية' : 'ئاگادارکردنەوە فەرمییەکان'),
                    style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold)
                  ),
                ]),
                const SizedBox(height: 14),
                Expanded(
                  child: _globalNotifications.isEmpty
                      ? Center(child: Text('هیچ ئاگادارکردنەوەیەک نییە', style: TextStyle(color: kTextSecondary.withOpacity(0.5))))
                      : ListView.builder(
                          itemCount: _globalNotifications.length,
                          itemBuilder: (context, idx) {
                            final notif = _globalNotifications[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kCardBg2,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kDividerLine),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(child: Text(notif.title, style: const TextStyle(color: kTextPrimary, fontSize: 12, fontWeight: FontWeight.bold))),
                                  Text(formatDisplayNumbers(notif.date), style: TextStyle(color: kTextSecondary.withOpacity(0.6), fontSize: 9)),
                                ]),
                                const SizedBox(height: 5),
                                Text(notif.body, style: TextStyle(color: kTextSecondary, fontSize: 11, height: 1.45)),
                              ]),
                            );
                          },
                        ),
                ),
              ]),
            ),
          ),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  // ignore: unused_element
  void _simulatePublishDialog(BuildContext context, StateSetter setSheetState) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: kCardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('بڵاوکردنەوەی ئاگادارکردنەوەی نوێ', style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleCtrl, style: TextStyle(color: kTextPrimary, fontSize: 13), decoration: InputDecoration(hintText: 'ناونیشانی ئاگادارکردنەوە...', hintStyle: TextStyle(color: kTextSecondary.withOpacity(0.5)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kDividerLine)))),
            const SizedBox(height: 10),
            TextField(controller: bodyCtrl, style: TextStyle(color: kTextPrimary, fontSize: 13), decoration: InputDecoration(hintText: 'نامەی ئاگادارکردنەوە...', hintStyle: TextStyle(color: kTextSecondary.withOpacity(0.5)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kDividerLine)))),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('پاشگەزبوونەوە', style: TextStyle(color: kTextSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kFbBlue),
              onPressed: () {
                if (titleCtrl.text.isEmpty || bodyCtrl.text.isEmpty) return;
                _globalNotifications.insert(0, SystemNotification(id: DateTime.now().toString(), title: titleCtrl.text, body: bodyCtrl.text, date: '٢٩/٦/٢٠٢٦'));
                Navigator.pop(context);
                Navigator.pop(context);
                _showPushBanner(titleCtrl.text, bodyCtrl.text);
              },
              child: const Text('بڵاوکردنەوە', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showPushBanner(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.notifications_active_rounded, color: kFbBlueLight, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(body, style: TextStyle(color: kTextSecondary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
      backgroundColor: kCardBg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: kFbBlue.withOpacity(0.4))),
      duration: const Duration(seconds: 4),
    ));
    setState(() {});
  }

  // ✅ دروستکردنی کارتی فلتەری لایڤی سەرەوە بۆ جیاکردنەوەی شیکارکاران بە دیزاینێکی زۆر ناوازە
  Widget _buildCategorySelector() {
    final bool isKurdishActive = _selectedLanguageFilter == 'Kurdish';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kDividerLine),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedLanguageFilter = 'Kurdish'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: isKurdishActive ? const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]) : null,
                  color: isKurdishActive ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    getTxt('analyst_tab_kurdish'),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isKurdishActive ? Colors.white : kTextSecondary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedLanguageFilter = 'Arabic'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: !isKurdishActive ? const LinearGradient(colors: [Color(0xFF0072FF), Color(0xFF00C6FF)]) : null,
                  color: !isKurdishActive ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    getTxt('analyst_tab_arabic'),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: !isKurdishActive ? Colors.white : kTextSecondary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 فلتەرکردنی لایڤی شیکارکارەکان لێرەدایە بۆ پیشاندان لەسەر شاشەی فەرمی
    final filteredAnalysts = _mockAnalysts.where((a) => a.language == _selectedLanguageFilter).toList();

    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        color: kPageBg,
        child: Column(children: [
          _buildHeader(),
          _buildCategorySelector(), // 🔹 ڕاکێشانی دروستی فلتەری نوێ
          Expanded(
            child: filteredAnalysts.isEmpty
                ? Center(child: Text(getTxt('no_content'), style: TextStyle(color: kTextSecondary.withOpacity(0.6))))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
                    itemCount: filteredAnalysts.length,
                    itemBuilder: (context, i) => _AnalystCard(analyst: filteredAnalysts[i], index: i),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTxt('analysis_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kTextPrimary)),
          const SizedBox(height: 3),
          Text(
            appLanguageGlobal == 'English' ? 'Expert Financial Commentary' : (appLanguageGlobal == 'العربية' ? 'مرئيات ومقالات خبراء المال' : 'ڤیدیۆ و نووسینی شرۆڤەکارانی دارایی'),
            style: TextStyle(fontSize: 11, color: kTextSecondary.withOpacity(0.7)),
          ),
        ]),
        GestureDetector(
          onTap: () => _showNotificationCenter(context),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: kDividerLine)),
              child: const Icon(Icons.notifications_active_rounded, color: kFbBlueLight, size: 16),
            ),
            if (_globalNotifications.isNotEmpty)
              Positioned(top: -2, right: -2, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))),
          ]),
        ),
      ]),
    );
  }
}

// ============================================================
// کارتی شرۆڤەکار (لیستی سەرەکی)
// ============================================================
class _AnalystCard extends StatelessWidget {
  final AnalystModel analyst;
  final int index;
  const _AnalystCard({required this.analyst, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnalystPortalScreen(analyst: analyst))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kDividerLine, width: 1),
        ),
        child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: kFbBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(25), border: Border.all(color: kDividerLine)),
            child: ClipOval(child: _buildDynamicAvatar(analyst.imagePath, analyst.emoji, 24)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(analyst.name, style: const TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(analyst.title, style: TextStyle(color: kTextSecondary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(children: [
              _chip('${analyst.videos.length}', Icons.play_circle_rounded, kFbBlueLight),
              const SizedBox(width: 6),
              _chip('${analyst.articles.length}', Icons.article_rounded, kTextSecondary),
            ]),
          ])),
          Icon(appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded, color: kTextSecondary.withOpacity(0.6), size: 13),
        ]),
      ),
    );
  }

  Widget _chip(String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

// ============================================================
// پۆڕتاڵی شرۆڤەکار - فیدی تێکەڵ (وەک لاپەڕەی فەیسبووک)
// ============================================================
class AnalystPortalScreen extends StatefulWidget {
  final AnalystModel analyst;
  const AnalystPortalScreen({super.key, required this.analyst});
  @override
  State<AnalystPortalScreen> createState() => _AnalystPortalScreenState();
}

class _AnalystPortalScreenState extends State<AnalystPortalScreen> {

  List<dynamic> _getMixedFeed() {
    final List<dynamic> feed = [];
    int vi = 0, ai = 0;
    while (vi < widget.analyst.videos.length || ai < widget.analyst.articles.length) {
      if (vi < widget.analyst.videos.length) feed.add(widget.analyst.videos[vi++]);
      if (ai < widget.analyst.articles.length) feed.add(widget.analyst.articles[ai++]);
    }
    return feed;
  }

  @override
  Widget build(BuildContext context) {
    final feed = _getMixedFeed();
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kPageBg,
        body: SafeArea(child: Column(children: [
          _buildTopBar(),
          _buildProfile(),
          Container(height: 8, color: kPageBg),
          Expanded(
            child: feed.isEmpty
                ? Center(child: Text(getTxt('no_content'), style: TextStyle(color: kTextSecondary.withOpacity(0.6))))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    itemCount: feed.length,
                    itemBuilder: (context, i) {
                      final item = feed[i];
                      if (item is VideoAnalysis) return _VideoCard(video: item, index: i, analyst: widget.analyst);
                      return _ArticleCard(article: item as WrittenAnalysis, index: i, analyst: widget.analyst);
                    },
                  ),
          ),
        ])),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      color: kPageBg,
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDividerLine)),
            child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: kTextPrimary, size: 15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(widget.analyst.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextPrimary))),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: kCardBg2, border: Border.all(color: kDividerLine)),
          child: ClipOval(child: _buildDynamicAvatar(widget.analyst.imagePath, widget.analyst.emoji, 16)),
        ),
      ]),
    );
  }

  Widget _buildProfile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kDividerLine),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), border: Border.all(color: kDividerLine)),
          child: ClipOval(child: _buildDynamicAvatar(widget.analyst.imagePath, widget.analyst.emoji, 28)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.analyst.title, style: const TextStyle(color: kFbBlueLight, fontSize: 11.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(widget.analyst.description, style: TextStyle(color: kTextSecondary, fontSize: 12, height: 1.5)),
        ])),
      ]),
    );
  }
}

// ============================================================
// هێدەری پۆست - هەمان شێوازی فەیسبووک بۆ هەموو پۆستێک
// ============================================================
class _FbPostHeader extends StatelessWidget {
  final AnalystModel analyst;
  final String date;
  const _FbPostHeader({required this.analyst, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: kCardBg2, border: Border.all(color: kDividerLine)),
          child: ClipOval(child: _buildDynamicAvatar(analyst.imagePath, analyst.emoji, 20)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(analyst.name, style: const TextStyle(color: kTextPrimary, fontSize: 13.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Row(children: [
            Text(formatDisplayNumbers(date), style: TextStyle(color: kTextSecondary, fontSize: 10.5, fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            Icon(Icons.public_rounded, size: 10, color: kTextSecondary.withOpacity(0.8)),
          ]),
        ])),
        Icon(Icons.more_horiz_rounded, color: kTextSecondary, size: 20),
      ]),
    );
  }
}

// ============================================================
// شریتی لایک/کۆمێنت/هاوبەشکردن
// ============================================================
class _FbActionsBar extends StatelessWidget {
  final String likeLabel, commentLabel;
  const _FbActionsBar({required this.likeLabel, required this.commentLabel});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: kFbBlue, shape: BoxShape.circle),
            child: const Icon(Icons.thumb_up_rounded, size: 9, color: Colors.white),
          ),
          const SizedBox(width: 6),
          Text(likeLabel, style: TextStyle(color: kTextSecondary, fontSize: 11.5, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(commentLabel, style: TextStyle(color: kTextSecondary, fontSize: 11.5, fontWeight: FontWeight.w500)),
        ]),
      ),
      Divider(color: kDividerLine, height: 1),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(children: [
          Expanded(child: _FbActionBtn(icon: Icons.thumb_up_outlined, activeIcon: Icons.thumb_up_rounded, label: appLanguageGlobal == 'English' ? 'Like' : 'لایک', color: kFbBlue)),
          Expanded(child: _FbActionBtn(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: appLanguageGlobal == 'English' ? 'Comment' : 'کۆمێنت', color: kFbBlue)),
          Expanded(child: _FbActionBtn(icon: Icons.share_outlined, activeIcon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: kFbBlue)),
        ]),
      ),
    ]);
  }
}

class _FbActionBtn extends StatefulWidget {
  final IconData icon, activeIcon;
  final String label;
  final Color color;
  const _FbActionBtn({required this.icon, required this.activeIcon, required this.label, required this.color});
  @override
  State<_FbActionBtn> createState() => _FbActionBtnState();
}

class _FbActionBtnState extends State<_FbActionBtn> {
  bool _active = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _active = !_active),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(_active ? widget.activeIcon : widget.icon, size: 16, color: _active ? widget.color : kTextSecondary),
          const SizedBox(width: 6),
          Text(widget.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _active ? widget.color : kTextSecondary)),
        ]),
      ),
    );
  }
}

// ============================================================
// کارتی ڤیدیۆ - وەک پۆستی ڤیدیۆیی فەیسبووک
// ✅ خەتی باریک دەوری هەموو چوارچێوەکە
// ============================================================
class _VideoCard extends StatelessWidget {
  final VideoAnalysis video;
  final int index;
  final AnalystModel analyst;
  const _VideoCard({required this.video, required this.index, required this.analyst});

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(video.youtubeUrl) ?? '';
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kDividerLine, width: 1), // ✅ خەتی باریک
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        _FbPostHeader(analyst: analyst, date: video.date),

        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Text(video.title, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold, height: 1.4)),
        ),

        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _VideoDetailView(video: video, analyst: analyst))),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: kDividerLine), bottom: BorderSide(color: kDividerLine))), // ✅ خەتی باریک دەوری میدیا
            child: Stack(fit: StackFit.expand, children: [
              Image.network(thumbUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: kCardBg2,
                    child: const Icon(Icons.video_library_rounded, size: 44, color: Colors.white24),
                  )),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.85), width: 2),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                ),
              ),
              Positioned(
                bottom: 10,
                right: appLanguageGlobal == 'English' ? null : 10,
                left: appLanguageGlobal == 'English' ? 10 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.75), borderRadius: BorderRadius.circular(6)),
                  child: Text(formatDisplayNumbers(video.duration), style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          // ✅ گۆڕینی نووسین بۆ سپی درەوشاوە و بۆڵدی قورس
          child: Text(
            video.longDescription.length > 110 ? '${video.longDescription.substring(0, 110)}...' : video.longDescription,
            style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.55, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 6),

        _FbActionsBar(likeLabel: formatDisplayNumbers('42'), commentLabel: '${formatDisplayNumbers('12')} ${appLanguageGlobal == 'English' ? 'comments' : 'کۆمێنت'}'),
      ]),
    );
  }
}

// ============================================================
// پەڕەی گەورەی ڤیدیۆ
// ============================================================
class _VideoDetailView extends StatelessWidget {
  final VideoAnalysis video;
  final AnalystModel analyst;
  const _VideoDetailView({required this.video, required this.analyst});

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(video.youtubeUrl) ?? '';
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kCardBg, // 🔹 گۆڕینی پاشبنەمای شاشەی خوێندنەوەی ڤیدیۆ بۆ خۆڵەمێشی ماتی فەیسبووکی (kCardBg)
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDividerLine)), // 🔹 گۆڕینی بۆ kCardBg2 بۆ تۆخکردنی زیاتری دوگمەکە
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: kTextPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 14),
              const Text('شرۆڤەی ڤیدیۆیی', style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
            ]),
          ),

          _FbPostHeader(analyst: analyst, date: video.date),

          Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDividerLine, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(thumbUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: kCardBg2)),
                Container(color: Colors.black.withOpacity(0.3)),
                Center(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(appLanguageGlobal == 'English' ? 'Live Player Coming Soon.' : 'لێدەری ڕاستەوخۆ بەمزوانە جێگیر دەکرێت.'),
                      backgroundColor: kFbBlue, behavior: SnackBarBehavior.floating,
                    )),
                    child: Container(
                      width: 66, height: 66,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.85), width: 2),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12, left: 12, right: 12,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(6)),
                      child: Text(formatDisplayNumbers(video.duration), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(video.title, style: const TextStyle(color: kTextPrimary, fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                const SizedBox(height: 16),
                Divider(color: kDividerLine, height: 1),
                const SizedBox(height: 16),

                Row(children: [
                  Container(width: 4, height: 16, decoration: BoxDecoration(color: kFbBlue, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  const Text('نووسینی ڕوونکەرەوەی شرۆڤەکار', style: TextStyle(color: kFbBlueLight, fontSize: 13, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),

                // ✅ نووسینی ڤیدیۆکان لێرەش بە تەواوی سپی درەوشاوە و بۆڵدی تۆخە
                Text(video.longDescription, style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.8, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _FbActionsBar(likeLabel: formatDisplayNumbers('42'), commentLabel: '${formatDisplayNumbers('12')} ${appLanguageGlobal == 'English' ? 'comments' : 'کۆمێنت'}'),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ])),
      ),
    );
  }
}

// ============================================================
// کارتی وتار - وەک پۆستی تێکستی/وێنەی فەیسبووک
// ✅ خەتی باریک دەوری چوارچێوە + پشتگیری وێنە
// ============================================================
class _ArticleCard extends StatelessWidget {
  final WrittenAnalysis article;
  final int index;
  final AnalystModel analyst;
  const _ArticleCard({required this.article, required this.index, required this.analyst});

  String _readTime(String content) {
    final minutes = (content.split(' ').length / 200).ceil();
    if (appLanguageGlobal == 'English') return '$minutes min read';
    return '$minutes خولەک خوێندن';
  }

  String _preview(String content) {
    if (content.length <= 220) return content;
    return '${content.substring(0, 220)}...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ArticleReadView(article: article, analyst: analyst, readTime: _readTime(article.content)))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kDividerLine, width: 1), // ✅ خەتی باریک
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          _FbPostHeader(analyst: analyst, date: article.date),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(article.title, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold, height: 1.4)),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            // ✅ تێکستی وتارەکانی سەر شاشە لێرەش بە تەواوی سپی درەوشاوە و بۆڵدە
            child: Text(
              _preview(article.content),
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.7, fontWeight: FontWeight.bold),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ✅ ئەگەر وێنە هەبوو پیشانی بدە، ئەگینا بۆکسی ئایکۆن
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kCardBg2,
              border: Border(top: BorderSide(color: kDividerLine), bottom: BorderSide(color: kDividerLine)),
            ),
            child: (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                ? Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image_rounded, size: 36, color: kTextSecondary.withOpacity(0.5))),
                  )
                : Center(child: Icon(Icons.article_rounded, size: 40, color: kTextSecondary.withOpacity(0.5))),
          ),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(children: [
              Icon(Icons.timer_outlined, size: 11, color: kTextSecondary),
              const SizedBox(width: 4),
              Text(_readTime(article.content), style: TextStyle(color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('زیاتر بخوێنەوە', style: TextStyle(color: kFbBlueLight, fontSize: 11.5, fontWeight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 8),

          _FbActionsBar(likeLabel: formatDisplayNumbers('28'), commentLabel: '${formatDisplayNumbers('7')} ${appLanguageGlobal == 'English' ? 'comments' : 'کۆمێنت'}'),
        ]),
      ),
    );
  }
}

// ============================================================
// شاشەی خوێندنەوەی وتار
// ============================================================
class _ArticleReadView extends StatelessWidget {
  final WrittenAnalysis article;
  final AnalystModel analyst;
  final String readTime;
  const _ArticleReadView({required this.article, required this.analyst, required this.readTime});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kCardBg, // 🔹 گۆڕینی پاشبنەمای شاشەی خوێندنەوەی وتار بۆ خۆڵەمێشی ماتی فەیسبووکی (kCardBg)
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDividerLine)), // 🔹 گۆڕینی بۆ kCardBg2 بۆ تۆخکردنی زیاتری دوگمەکە
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: kTextPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: kFbBlue, borderRadius: BorderRadius.circular(8)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.trending_up_rounded, color: Colors.white, size: 13),
                  SizedBox(width: 5),
                  Text('بۆرسەی عێراق', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                ]),
              ),
            ]),
          ),

          _FbPostHeader(analyst: analyst, date: article.date),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(article.title, style: const TextStyle(color: kTextPrimary, fontSize: 19, fontWeight: FontWeight.bold, height: 1.4)),
              const SizedBox(height: 10),
              Row(children: [
                Icon(Icons.timer_outlined, size: 12, color: kFbBlueLight),
                const SizedBox(width: 5),
                Text(readTime, style: const TextStyle(color: kFbBlueLight, fontSize: 11.5, fontWeight: FontWeight.bold)),
              ]),
            ]),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // وێنەی گەورەی وتار (ئەگەر هەبوو)
                if (article.imageUrl != null && article.imageUrl!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    height: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kDividerLine, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: kCardBg2, child: Center(child: Icon(Icons.broken_image_rounded, color: kTextSecondary.withOpacity(0.5)))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ] else
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(color: kDividerLine, height: 1)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (article.imageUrl == null || article.imageUrl!.isEmpty) const SizedBox(height: 16),
                    // ✅ گۆڕینی نووسینی بەینی وتارەکان بۆ سپی تەواو و بۆڵدی زۆر تۆخ بە هاوسەنگی لایڤ
                    _buildLinkableText(
                      article.content,
                      const TextStyle(color: Colors.white, fontSize: 16.5, height: 1.85, fontWeight: FontWeight.bold), // 🔹 گەورەکردنی فۆنت بۆ ١٦.٥ بۆ خوێندنەوەی بەرز و لایڤی سپی تەواو
                      kFbBlueLight,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: kDividerLine, width: 1)),
                      child: _FbActionsBar(likeLabel: formatDisplayNumbers('28'), commentLabel: '${formatDisplayNumbers('7')} ${appLanguageGlobal == 'English' ? 'comments' : 'کۆمێنت'}'),
                    ),
                    const SizedBox(height: 30),
                  ]),
                ),
              ]),
            ),
          ),

        ])),
      ),
    );
  }
}

// ============================================================
// فۆرماتکردنی مێسۆدی کۆتایی
// ============================================================
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool isUp;

  _SparklinePainter({required this.data, required this.color, required this.isUp});

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
      final double y = size.height - ((data[i] - minVal) / range) * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
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
    final lastY = size.height - ((data.last - minVal) / range) * size.height;
    canvas.drawCircle(Offset(lastX, lastY), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}