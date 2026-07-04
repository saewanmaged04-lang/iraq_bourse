// ignore_for_file: deprecated_member_use
// lib/screens/market_analysis_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math; // هاوردەکردنی ماتماتیک
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // هاوردەکردنی لێدەری یوتیوب
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
  final String language;

  const AnalystModel({
    required this.id, required this.name, required this.title,
    required this.emoji, required this.description,
    this.imagePath,
    required this.videos, required this.articles,
    required this.language,
  });
}

class VideoAnalysis {
  final String id, title, youtubeUrl, duration, date, longDescription;
  const VideoAnalysis({
    required this.id, required this.title, required this.youtubeUrl,
    required this.duration, required this.date, required this.longDescription,
  });
}

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
      spans.add(TextSpan(text: text.substring(start, match.start)));
    }
    final String link = match.group(0)!;
    spans.add(TextSpan(
      text: link,
      style: TextStyle(color: linkColor, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
      recognizer: TapGestureRecognizer()..onTap = () { 
        launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication); 
      },
    ));
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start)));
  }
  
  return SelectableText.rich(
    TextSpan(style: baseStyle, children: spans), 
    textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
  );
}

final List<SystemNotification> _globalNotifications = [
  SystemNotification(id: 'n1', title: 'شیکاریی گرنگی ئەمڕۆ بۆ دۆلار! 🚨', body: 'د. ڕێبین جەمال شیکارییەکی زۆر وردی لەسەر جووڵەی بازارەکانی سلێمانی و بەغداد بڵاوکردەوە.', date: '٢٩/٦/٢٠٢٦'),
  SystemNotification(id: 'n2', title: 'نوێکردنەوەی نرخەکانی بۆرسە 📊', body: 'سەرجەم نرخەکانی بۆرسەی شارەکان و دراوە جیهانییەکان لە بازاردا بە لایڤی نوێکرانەوە.', date: '٢٨/٦/٢٠٢٦'),
];

final List<AnalystModel> _mockAnalysts = [
  const AnalystModel(
    id: 'a1', name: 'د. ڕێبین جەمال',
    title: 'پڕۆفیسۆری سیاسەتی دارایی عێراق',
    emoji: '👨‍🏫', imagePath: null,
    description: 'پسپۆڕی سەرەکی سیاسەتی دراو و چاودێری جووڵەی بازارەکانی عێراق.',
    language: 'Kurdish',
    videos: [
      VideoAnalysis(id: 'v1', title: 'شیکاریی نوێ: بەهای دۆلار بەرامبەر دینار بۆ کۆتایی ساڵی ٢٠٢٦', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '12:45', date: '٢٧/٦/٢٠٢٦', longDescription: 'لەم ڤیدیۆیەدا، دکتۆر ڕێبین شیکارییەکی زۆر ورد پێشکەش دەکات سەبارەت بە هەڵئاوسانی نێوخۆیی و بڕیارە درەنگوەختەکانی بانکی ناوەندی عێراق کە ڕاستەوخۆ کاریگەری لەسەر بەهای بازاڕی هاوتەریبی دۆلار دادەنێت لە بازارەکانی سلێمانی و بەغداد. زۆر گرنگی بۆ ئەوانەی کە سەرمایەیان هەیە.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art1', title: 'سیستمی تەمویلکردنی بازرگانی گشتی و کێشەی بازارە هاوتەریبەکان', content: 'لەم شڕۆڤە فەرمییەدا, بە تەواوی ئاماژە بە هۆکارەکانی بەرزبوونەوەی کاتیی بەهای فرۆشتنی دۆلار لە بازارەکانی سلێمانی و بەغداد دەکەین. بۆ خوێندنەوەی ڕاپۆتی فەرمی بانکی ناوەندی عێراق سەردانی ئەم بەستەرە بکە: https://cbi.iq هۆکاری سەرەکی گرفتەکە بریتییە لە نەبوونی متمانەی تەواوی نووسینگە بازرگانییە کاتییەکان بە مێتۆدە ئەلەکترۆنییەکان.', date: '٢٧/٦/٢٠٢٦'),
    ],
  ),
  const AnalystModel(
    id: 'a2', name: 'هەورامان عومەر',
    title: 'شرۆڤەکاری دارایی و ڕاوێژکاری بۆرسەی سلێمانی',
    emoji: '📊', imagePath: null,
    description: 'شرۆڤەکاری لایڤی جووڵەی بازار و بۆرسەی بەغداد و سلێمانی.',
    language: 'Kurdish',
    videos: [
      VideoAnalysis(id: 'v3', title: 'کلیلەکانی سەرکەوتن لە کڕین و فرۆشتنی بازاڕی بۆرسەدا', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '15:20', date: '٢٥/٦/٢٠٢٦', longDescription: 'تەواوی مەرج و یاساکانی سەرکەوتن لە کڕین و فرۆشتنی سەرەکی لەم کورتە شرۆڤەیەدا کۆکراوەتەوە، کە یارمەتیدەرێکی بەهێزی بازرگانانی سەرەکی دراو دەبێت.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art3', title: 'گرنگی حاسیبە و نرخە لایڤەکان بۆ کۆنتڕۆڵکردنی سەرمایەکان', content: 'هەموو بازرگانێکی دراو پێویستی بە مێکانیزمی خێرا هەیە بۆ کۆنتڕۆڵکردنی قازانج و زیان. بەکارهێنانی نرخەکانی لایڤی بازار لەبری نرخە کۆنەکان هێزی دڵنیایی دەبەخشێت بە بازرگانان تا بتوانن لە خێراترین کاتدا بڕیاردان لەسەر سەفقە گەورەکان دەدەن.', date: '٢٠/٦/٢٠٢٦'),
    ],
  ),
  const AnalystModel(
    id: 'a3', name: 'أ. أحمد الجبوري',
    title: 'خبير السياسات النقدية ومحلل أسواق الصرف',
    emoji: '👨‍💼', imagePath: null,
    description: 'مستشار مالي عراقي ومتابع لحركة البورصات العراقية والعالمية اليومية لأسعار الدولار.',
    language: 'Arabic',
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
    language: 'Arabic',
    videos: [
      VideoAnalysis(id: 'v5', title: 'أسرار التداول والاستثمار المالي الناجح في أسواق الصرف العراقية', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '14:30', date: '٢٨/٦/٢٠٢٦', longDescription: 'شرح كامل حول آليات حماية رأس المال والتحليلات الأساسية الواجب اتباعها من قبل التجار والمكاتب المالية لتجنب تذبذبات الصرف الفورية.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art5', title: 'أهمية الاعتماد على المنصات الرقمية المعتمدة للتحويلات الفورية', content: 'إن التحول المالي الرقمي هو الحل الأمثل لضمان وصول التمويل للتجار بأسعار مناسبة وضمان خفض الفجوة بين السعر الرسمي والوازي للدولار مقابل الدينار العراقي.', date: '٢٨/٦/٢٠٢٦'),
    ],
  ),
];

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
// شاشەی سەرەکى بە سکرۆڵکردنی سەرجەم بەشەکان بەیەکەوە
// ============================================================
class MarketAnalysisScreen extends StatefulWidget {
  const MarketAnalysisScreen({super.key});
  @override
  State<MarketAnalysisScreen> createState() => _MarketAnalysisScreenState();
}

class _MarketAnalysisScreenState extends State<MarketAnalysisScreen> {
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
                    style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold)
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
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
    final filteredAnalysts = _mockAnalysts.where((a) => a.language == _selectedLanguageFilter).toList();

    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        color: kPageBg,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          itemCount: filteredAnalysts.isEmpty ? 3 : filteredAnalysts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader();
            }
            if (index == 1) {
              return _buildCategorySelector();
            }
            
            if (filteredAnalysts.isEmpty) {
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: Text(getTxt('no_content'), style: TextStyle(color: kTextSecondary.withOpacity(0.6))),
              );
            }
            
            final analyst = filteredAnalysts[index - 2];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AnalystCard(analyst: analyst, index: index - 2),
            );
          },
        ),
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
// کارتی شرۆڤەکار بە قەبارەی ڕێکتر و کەمێک بچووککراوە
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
        margin: const EdgeInsets.only(bottom: 8), 
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), 
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(color: kDividerLine, width: 1),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40, 
            decoration: BoxDecoration(
              color: kFbBlue.withOpacity(0.12), 
              borderRadius: BorderRadius.circular(20), 
              border: Border.all(color: kDividerLine)
            ),
            child: ClipOval(child: _buildDynamicAvatar(analyst.imagePath, analyst.emoji, 18)), 
          ),
          const SizedBox(width: 10), 
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              analyst.name, 
              style: const TextStyle(color: kTextPrimary, fontSize: 13.5, fontWeight: FontWeight.bold) 
            ),
            const SizedBox(height: 2),
            Text(
              analyst.title, 
              style: TextStyle(color: kTextSecondary, fontSize: 10), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis
            ),
            const SizedBox(height: 6), 
            Row(children: [
              _chip('${analyst.videos.length}', Icons.play_circle_rounded, kFbBlueLight),
              const SizedBox(width: 6),
              _chip('${analyst.articles.length}', Icons.article_rounded, kTextSecondary),
            ]),
          ])),
          Icon(
            appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded, 
            color: kTextSecondary.withOpacity(0.6), 
            size: 11 
          ),
        ]),
      ),
    );
  }

  Widget _chip(String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
      decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 9, color: color), 
        const SizedBox(width: 3),
        Text(count, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)), 
      ]),
    );
  }
}

// ============================================================
// پۆڕتاڵی شرۆڤەکار - هێدەری جێگیر + داکێشان بۆ ڕێفرێش
// ============================================================
class AnalystPortalScreen extends StatefulWidget {
  final AnalystModel analyst;
  const AnalystPortalScreen({super.key, required this.analyst});
  @override
  State<AnalystPortalScreen> createState() => _AnalystPortalScreenState();
}

class _AnalystPortalScreenState extends State<AnalystPortalScreen> {
  late ScrollController _portalScrollController;

  @override
  void initState() {
    super.initState();
    _portalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _portalScrollController.dispose();
    super.dispose();
  }

  List<dynamic> _getMixedFeed() {
    final List<dynamic> feed = [];
    int vi = 0, ai = 0;
    while (vi < widget.analyst.videos.length || ai < widget.analyst.articles.length) {
      if (vi < widget.analyst.videos.length) feed.add(widget.analyst.videos[vi++]);
      if (ai < widget.analyst.articles.length) feed.add(widget.analyst.articles[ai++]);
    }
    return feed;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _portalScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = _getMixedFeed();
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kPageBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: kCardBg,
                  color: kFbBlueLight,
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    controller: _portalScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    itemCount: feed.isEmpty ? 3 : feed.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildProfile();
                      }
                      if (index == 1) {
                        return Container(height: 8, color: kPageBg);
                      }
                      
                      if (feed.isEmpty) {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text(getTxt('no_content'), style: TextStyle(color: kTextSecondary.withOpacity(0.6))),
                        );
                      }
                      
                      final item = feed[index - 2];
                      if (item is VideoAnalysis) {
                        return _VideoCard(video: item, index: index - 2, analyst: widget.analyst);
                      }
                      return _ArticleCard(article: item as WrittenAnalysis, index: index - 2, analyst: widget.analyst);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
// هێدەری پۆست 
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
// لۆجیکی چالاککردنی لایک، کۆمێنت و شەیر بە وەرگێڕانی عەرەبی لایڤ
// ============================================================
class _FbActionsBar extends StatefulWidget {
  final int initialLikes;
  final int initialComments;
  final String analystLanguage; // 'Kurdish' یان 'Arabic'
  
  const _FbActionsBar({
    required this.initialLikes, 
    required this.initialComments,
    required this.analystLanguage,
  });

  @override
  State<_FbActionsBar> createState() => _FbActionsBarState();
}

class _FbActionsBarState extends State<_FbActionsBar> {
  late int likesCount;
  late int commentsCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likesCount = widget.initialLikes;
    commentsCount = widget.initialComments;
  }

  // 🔹 فەنکشنی لایککردن
  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likesCount++;
      } else {
        likesCount--;
      }
    });
  }

  // 🔹 فەنکشنی کردنەوەی پەنجەرەی کۆمێنت
  void _showCommentsSheet(BuildContext context) {
    final bool isAr = widget.analystLanguage == 'Arabic' || appLanguageGlobal == 'العربية';
    final bool isEn = appLanguageGlobal == 'English';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      isEn ? 'Comments' : (isAr ? 'التعليقات' : 'کۆمێنتەکان'),
                      style: const TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(color: kDividerLine, height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildMockComment(
                        isEn ? 'Sarwan' : (isAr ? 'سروان' : 'سەروان'), 
                        isEn ? 'Excellent analysis, well done.' : (isAr ? 'تحليل رائع، بوركت جهودكم.' : 'شیکارییەکی زۆر نایابە، دەستخۆش.'), 
                        isEn ? '12 minutes ago' : (isAr ? 'قبل ١٢ دقيقة' : '١٢ خولەک پێش ئێستا')
                      ),
                      _buildMockComment(
                        isEn ? 'Ahmed' : (isAr ? 'أحمد' : 'ئەحمەد'), 
                        isEn ? 'But will the dollar price remain stable this week?' : (isAr ? 'ولكن هل سيبقى سعر الدولار مستقراً هذا الأسبوع؟' : 'بەڵام ئایا نرخی دۆلار لەم هەفتەیەدا جێگیر دەبێت؟'), 
                        isEn ? '1 hour ago' : (isAr ? 'قبل ساعة' : '١ کاتژمێر پێش ئێستا')
                      ),
                      _buildMockComment(
                        isEn ? 'Hemin' : (isAr ? 'هيمن' : 'هێمن'), 
                        isEn ? 'Thank you for this information, very helpful.' : (isAr ? 'شكراً جزيلاً على هذه المعلومات القيمة.' : 'سوپاس بۆ ئەم زانیارییانە، زۆر سوودم لێبینی.'), 
                        isEn ? 'Yesterday' : (isAr ? 'بالأمس' : 'دوێنێ')
                      ),
                    ],
                  ),
                ),
                Divider(color: kDividerLine, height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: kCardBg2),
                        child: const Icon(Icons.person, color: kTextSecondary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: kTextPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: isEn ? 'Write a comment...' : (isAr ? 'اكتب تعليقاً...' : 'کۆمێنتێک بنووسە...'),
                            hintStyle: TextStyle(color: kTextSecondary.withOpacity(0.6), fontSize: 13),
                            filled: true,
                            fillColor: kCardBg2,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: kFbBlue),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(isEn ? 'Comment Added!' : (isAr ? 'تم إضافة التعليق!' : 'کۆمێنتەکەت نێردرا!')),
                            backgroundColor: const Color(0xFF22C55E),
                          ));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockComment(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: kCardBg2),
            child: const Icon(Icons.person, color: kTextSecondary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: kCardBg2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 12.5)),
                      const SizedBox(height: 4),
                      Text(text, style: const TextStyle(color: kTextPrimary, fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(time, style: TextStyle(color: kTextSecondary.withOpacity(0.8), fontSize: 10)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🔹 فەنکشنی کردنەوەی پەنجەرەی شەیرکردن
  void _showShareSheet(BuildContext context) {
    final bool isAr = widget.analystLanguage == 'Arabic' || appLanguageGlobal == 'العربية';
    final bool isEn = appLanguageGlobal == 'English';

    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEn ? 'Share to' : (isAr ? 'مشاركة عبر' : 'هاوبەشکردن بۆ'),
                style: const TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareIcon(Icons.copy_rounded, isEn ? 'Copy Link' : (isAr ? 'نسخ الرابط' : 'کۆپیکردن'), Colors.grey),
                  _buildShareIcon(Icons.facebook_rounded, 'Facebook', const Color(0xFF1877F2)),
                  _buildShareIcon(Icons.chat_rounded, 'WhatsApp', const Color(0xFF25D366)),
                  _buildShareIcon(Icons.send_rounded, 'Telegram', const Color(0xFF0088CC)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareIcon(IconData icon, String label, Color color) {
    final bool isAr = widget.analystLanguage == 'Arabic' || appLanguageGlobal == 'العربية';
    final bool isEn = appLanguageGlobal == 'English';

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isEn ? 'Action successful!' : (isAr ? 'تمت العملية بنجاح!' : 'کارەکە سەرکەوتوو بوو!')),
          backgroundColor: kFbBlue,
        ));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.15)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool useArabic = widget.analystLanguage == 'Arabic';
    final bool useEnglish = appLanguageGlobal == 'English';

    final String likeTxt = useEnglish ? 'Like' : (useArabic || appLanguageGlobal == 'العربية' ? 'إعجاب' : 'لایک');
    final String commentTxt = useEnglish ? 'Comment' : (useArabic || appLanguageGlobal == 'العربية' ? 'تعليق' : 'کۆمێنت');
    final String shareTxt = useEnglish ? 'Share' : (useArabic || appLanguageGlobal == 'العربية' ? 'مشاركة' : 'هاوبەشکردن');
    final String commentsLabel = useEnglish ? 'comments' : (useArabic || appLanguageGlobal == 'العربية' ? 'تعليقاً' : 'کۆمێنت');

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
          Text(formatDisplayNumbers('$likesCount'), style: const TextStyle(color: kTextSecondary, fontSize: 11.5, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text('${formatDisplayNumbers('$commentsCount')} $commentsLabel', style: const TextStyle(color: kTextSecondary, fontSize: 11.5, fontWeight: FontWeight.w500)),
        ]),
      ),
      Divider(color: kDividerLine, height: 1),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: _toggleLike,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined, size: 16, color: isLiked ? kFbBlue : kTextSecondary),
                  const SizedBox(width: 6),
                  Text(likeTxt, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isLiked ? kFbBlue : kTextSecondary)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showCommentsSheet(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: kTextSecondary),
                  const SizedBox(width: 6),
                  Text(commentTxt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextSecondary)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showShareSheet(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.share_outlined, size: 16, color: kTextSecondary),
                  const SizedBox(width: 6),
                  Text(shareTxt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextSecondary)),
                ]),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

// ============================================================
// کارتی ڤیدیۆ 
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
        border: Border.all(color: kDividerLine, width: 1), 
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
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: kDividerLine), bottom: BorderSide(color: kDividerLine))), 
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
              Positioned( // 🔹 ڕاستکرایەوە لە هێڵیی ١٠٠٧دا لە تێکچوونی ڕێنووسەکە
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
          child: Text(
            video.longDescription.length > 110 ? '${video.longDescription.substring(0, 110)}...' : video.longDescription,
            style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.55, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 6),

        _FbActionsBar(initialLikes: 42, initialComments: 12, analystLanguage: analyst.language),
      ]),
    );
  }
}

// ============================================================
// پەڕەی گەورەی ڤیدیۆ
// ============================================================
class _VideoDetailView extends StatefulWidget {
  final VideoAnalysis video;
  final AnalystModel analyst;
  const _VideoDetailView({required this.video, required this.analyst});

  @override
  State<_VideoDetailView> createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends State<_VideoDetailView> {
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    final videoId = extractYoutubeId(widget.video.youtubeUrl) ?? '';
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kCardBg, 
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDividerLine)), 
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: kTextPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                appLanguageGlobal == 'English' ? 'Video Analysis' : (appLanguageGlobal == 'العربية' ? 'التحليل المرئي' : 'شرۆڤەی ڤیدیۆیی'), 
                style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold)
              ),
            ]),
          ),

          _FbPostHeader(analyst: widget.analyst, date: widget.video.date),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDividerLine, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: YoutubePlayer(
                controller: _ytController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: kFbBlue,
                progressColors: const ProgressBarColors(
                  playedColor: kFbBlue,
                  handleColor: kFbBlueLight,
                ),
                onReady: () {
                  // ئامادەیە
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(widget.video.title, style: const TextStyle(color: kTextPrimary, fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                const SizedBox(height: 16),
                Divider(color: kDividerLine, height: 1),
                const SizedBox(height: 16),

                Row(children: [
                  Container(width: 4, height: 16, decoration: BoxDecoration(color: kFbBlue, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  Text(
                    appLanguageGlobal == 'English' ? 'Analyst Explanation' : (appLanguageGlobal == 'العربية' ? 'شرح وتحليل الخبير' : 'نووسینی ڕوونکەرەوەی شرۆڤەکار'), 
                    style: const TextStyle(color: kFbBlueLight, fontSize: 13, fontWeight: FontWeight.bold)
                  ),
                ]),
                const SizedBox(height: 12),

                Text(widget.video.longDescription, style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.8, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _FbActionsBar(initialLikes: 145, initialComments: 34, analystLanguage: widget.analyst.language),
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
// ============================================================
class _ArticleCard extends StatelessWidget {
  final WrittenAnalysis article;
  final int index;
  final AnalystModel analyst;
  const _ArticleCard({required this.article, required this.index, required this.analyst});

  String _readTime(String content) {
    final minutes = (content.split(' ').length / 200).ceil();
    if (appLanguageGlobal == 'English') return '$minutes min read';
    if (appLanguageGlobal == 'العربية') return 'قراءة في $minutes دقائق';
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
          border: Border.all(color: kDividerLine, width: 1), 
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
            child: Text(
              _preview(article.content),
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.7, fontWeight: FontWeight.bold),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kCardBg2,
              border: Border(top: BorderSide(color: kDividerLine), bottom: BorderSide(color: kDividerLine)),
            ),
            child: (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                ? Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image_rounded, size: 36, color: kTextSecondary.withOpacity(0.5))),
                  )
                : Center(child: Icon(Icons.broken_image_rounded, size: 40, color: kTextSecondary.withOpacity(0.5))),
          ),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(children: [
              const Icon(Icons.timer_outlined, size: 11, color: kTextSecondary),
              const SizedBox(width: 4),
              Text(_readTime(article.content), style: const TextStyle(color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(
                appLanguageGlobal == 'English' ? 'Read More' : (appLanguageGlobal == 'العربية' ? 'اقرأ المزيد' : 'زیاتر بخوێنەوە'), 
                style: const TextStyle(color: kFbBlueLight, fontSize: 11.5, fontWeight: FontWeight.bold)
              ),
            ]),
          ),
          const SizedBox(height: 8),

          _FbActionsBar(initialLikes: 28, initialComments: 7, analystLanguage: analyst.language),
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
        backgroundColor: kCardBg, 
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: kCardBg2, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDividerLine)), 
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: kTextPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: kFbBlue, borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.trending_up_rounded, color: Colors.white, size: 13),
                  const SizedBox(width: 5),
                  Text(
                    appLanguageGlobal == 'English' ? 'Iraq Bourse' : (appLanguageGlobal == 'العربية' ? 'العراق بورصة' : 'بۆرسەی عێراق'), 
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)
                  ),
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
                const Icon(Icons.timer_outlined, size: 12, color: kFbBlueLight),
                const SizedBox(width: 5),
                Text(readTime, style: const TextStyle(color: kFbBlueLight, fontSize: 11.5, fontWeight: FontWeight.bold)),
              ]),
            ]),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

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
                    _buildLinkableText(
                      article.content,
                      const TextStyle(color: Colors.white, fontSize: 16.5, height: 1.85, fontWeight: FontWeight.bold), 
                      kFbBlueLight,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: kDividerLine, width: 1)),
                      child: _FbActionsBar(initialLikes: 112, initialComments: 23, analystLanguage: analyst.language),
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