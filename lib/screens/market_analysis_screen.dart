// ignore_for_file: deprecated_member_use
// lib/screens/market_analysis_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_state.dart';

// ============================================================
// مۆدێلەکان
// ============================================================
class AnalystModel {
  final String id, name, title, emoji, description;
  final String? imagePath;
  final List<VideoAnalysis> videos;
  final List<WrittenAnalysis> articles;

  const AnalystModel({
    required this.id, required this.name, required this.title,
    required this.emoji, required this.description,
    this.imagePath,
    required this.videos, required this.articles,
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
  const WrittenAnalysis({
    required this.id, required this.title,
    required this.content, required this.date,
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
      spans.add(TextSpan(text: text.substring(start, match.start), style: baseStyle));
    }
    final String link = match.group(0)!;
    spans.add(TextSpan(
      text: link,
      style: baseStyle.copyWith(color: linkColor, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
      recognizer: TapGestureRecognizer()..onTap = () async {
        final Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
      },
    ));
    start = match.end;
  }
  if (start < text.length) spans.add(TextSpan(text: text.substring(start), style: baseStyle));
  return RichText(
    text: TextSpan(children: spans),
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
    videos: [
      VideoAnalysis(id: 'v1', title: 'شیکاریی نوێ: بەهای دۆلار بەرامبەر دینار بۆ کۆتایی ساڵی ٢٠٢٦', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '12:45', date: '٢٧/٦/٢٠٢٦', longDescription: 'لەم ڤیدیۆیەدا، دکتۆر ڕێبین شیکارییەکی زۆر ورد پێشکەش دەکات سەبارەت بە هەڵئاوسانی نێوخۆیی و بڕیارە درەنگوەختەکانی بانکی ناوەندی عێراق کە ڕاستەوخۆ کاریگەری لەسەر بەهای بازاڕی هاوتەریبی دۆلار دادەنێت لە بازارەکانی سلێمانی و بەغداد. زۆر گرنگی بۆ ئەوانەی کە سەرمایەیان هەیە.'),
      VideoAnalysis(id: 'v2', title: 'کاریگەری بڕیارەکانی بانکی ناوەندی لەسەر بەهای بازاڕ', youtubeUrl: 'https://www.youtube.com/watch?v=y6Sxv-sUYtM', duration: '09:15', date: '٢٠/٦/٢٠٢٦', longDescription: 'لەم بابەتەدا، بە قووڵی باس لە ستراتیژی تەمویلکردنی نوێ دەکرێت کە چۆن گۆڕانکاری بەسەر جوڵەی بازرگانی گشتی دەهێنێت و چۆن کار دەکاتە سەر کەمکردنەوەی جیاوازی نێوان نرخی فەرمی و نافەرمی دۆلار.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art1', title: 'سیستمی تەمویلکردنی بازرگانی گشتی و کێشەی بازارە هاوتەریبەکان', content: 'لەم شرۆڤە فەرمییەدا، بە تەواوی ئاماژە بە هۆکارەکانی بەرزبوونەوەی کاتیی بەهای فرۆشتنی دۆلار لە بازارەکانی سلێمانی و بەغداد دەکەین. بۆ خوێندنەوەی ڕاپۆرتی فەرمی بانکی ناوەندی عێراق سەردانی ئەم بەستەرە بکە: https://cbi.iq هۆکاری سەرەکی گرفتەکە بریتییە لە نەبوونی متمانەی تەواوی نووسینگە بازرگانییە کاتییەکان بە مێتۆدە ئەلەکترۆنییەکان.', date: '٢٧/٦/٢٠٢٦'),
      WrittenAnalysis(id: 'art2', title: 'پێشبینییەکانی تمەن بەرامبەر دۆلار بەپێی جووڵە نێودەوڵەتییەکان', content: 'جووڵەی دراوی تمەنی ئێرانی بە تەواوی بەستراوەتەوە بە سیاسەتە نێودەوڵەتییە گشتییەکان. هۆکاری جێگیربوونی نرخەکە لە کاتی نوێدا بۆ پەیوەندییە هاوبەشە بازرگانییەکان دەگەڕێتەوە، بەڵام پێشبینی دەکرێت لە مانگەکانی داهاتوودا سەرلەنوێ کێشە لە توانای دارایی بازارە کاتییەکانی تمەندا دروست ببێتەوە.', date: '٢٥/٦/٢٠٢٦'),
    ],
  ),
  const AnalystModel(
    id: 'a2', name: 'هەورامان عومەر',
    title: 'شرۆڤەکاری دارایی و ڕاوێژکاری بۆرسەی سلێمانی',
    emoji: '📊', imagePath: null,
    description: 'شرۆڤەکاری لایڤی جووڵەی بازار و بۆرسەی بەغداد و سلێمانی.',
    videos: [
      VideoAnalysis(id: 'v3', title: 'کلیلەکانی سەرکەوتن لە کڕین و فرۆشتنی بازاڕی بۆرسەدا', youtubeUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU', duration: '15:20', date: '٢٥/٦/٢٠٢٦', longDescription: 'تەواوی مەرج و یاساکانی سەرکەوتن لە کڕین و فرۆشتنی سەرەکی لەم کورتە شرۆڤەیەدا کۆکراوەتەوە، کە یارمەتیدەرێکی بەهێزی بازرگانانی سەرەکی دراو دەبێت.'),
    ],
    articles: [
      WrittenAnalysis(id: 'art3', title: 'گرنگی حاسیبە و نرخە لایڤەکان بۆ کۆنتڕۆڵکردنی سەرمایەکان', content: 'هەموو بازرگانێکی دراو پێویستی بە مێکانیزمی خێرا هەیە بۆ کۆنتڕۆڵکردنی قازانج و زیان. بەکارهێنانی نرخەکانی لایڤی بازار لەبری نرخە کۆنەکان هێزی دڵنیایی دەبەخشێت بە بازرگانان تا بتوانن لە خێراترین کاتدا بڕیاردان لەسەر سەفقە گەورەکان دەدەن.', date: '٢٠/٦/٢٠٢٦'),
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
// شاشەی سەرەکی
// ============================================================
class MarketAnalysisScreen extends StatefulWidget {
  const MarketAnalysisScreen({super.key});
  @override
  State<MarketAnalysisScreen> createState() => _MarketAnalysisScreenState();
}

class _MarketAnalysisScreenState extends State<MarketAnalysisScreen> {

  void _showNotificationCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131C2E),
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
                  const Text('ئاگادارکردنەوە فەرمییەکان', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => _simulatePublishDialog(context, setSheetState),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76C917).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF76C917).withOpacity(0.3)),
                      ),
                      child: const Row(children: [
                        Icon(Icons.campaign_rounded, color: Color(0xFF76C917), size: 12),
                        SizedBox(width: 4),
                        Text('ناردنی نوێ', style: TextStyle(color: Color(0xFF76C917), fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
                Expanded(
                  child: _globalNotifications.isEmpty
                      ? const Center(child: Text('هیچ ئاگادارکردنەوەیەک نییە', style: TextStyle(color: Colors.white24)))
                      : ListView.builder(
                          itemCount: _globalNotifications.length,
                          itemBuilder: (context, idx) {
                            final notif = _globalNotifications[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B121F),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(child: Text(notif.title, style: const TextStyle(color: Color(0xFFECC880), fontSize: 12, fontWeight: FontWeight.bold))),
                                  Text(formatDisplayNumbers(notif.date), style: const TextStyle(color: Colors.white24, fontSize: 9)),
                                ]),
                                const SizedBox(height: 5),
                                Text(notif.body, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11, height: 1.45)),
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

  void _simulatePublishDialog(BuildContext context, StateSetter setSheetState) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF131C2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('بڵاوکردنەوەی ئاگادارکردنەوەی نوێ', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white, fontSize: 13), decoration: InputDecoration(hintText: 'ناونیشانی ئاگادارکردنەوە...', hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))))),
            const SizedBox(height: 10),
            TextField(controller: bodyCtrl, style: const TextStyle(color: Colors.white, fontSize: 13), decoration: InputDecoration(hintText: 'نامەی ئاگادارکردنەوە...', hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))))),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('پاشگەزبوونەوە', style: TextStyle(color: Colors.white38))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF76C917)),
              onPressed: () {
                if (titleCtrl.text.isEmpty || bodyCtrl.text.isEmpty) return;
                _globalNotifications.insert(0, SystemNotification(id: DateTime.now().toString(), title: titleCtrl.text, body: bodyCtrl.text, date: '٢٩/٦/٢٠٢٦'));
                Navigator.pop(context);
                Navigator.pop(context);
                _showPushBanner(titleCtrl.text, bodyCtrl.text);
              },
              child: const Text('بڵاوکردنەوە', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPushBanner(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.notifications_active_rounded, color: Color(0xFF76C917), size: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(body, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
      backgroundColor: const Color(0xFF131C2E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: const Color(0xFF76C917).withOpacity(0.3))),
      duration: const Duration(seconds: 4),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        color: const Color(0xFF0B121F),
        child: Column(children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
              itemCount: _mockAnalysts.length,
              itemBuilder: (context, i) => _AnalystCard(analyst: _mockAnalysts[i], index: i),
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
          Text(getTxt('analysis_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 3),
          Text(
            appLanguageGlobal == 'English' ? 'Expert Financial Commentary' : (appLanguageGlobal == 'العربية' ? 'مرئيات ومقالات خبراء المال' : 'ڤیدیۆ و نووسینی شرۆڤەکارانی دارایی'),
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.35)),
          ),
        ]),
        GestureDetector(
          onTap: () => _showNotificationCenter(context),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.08))),
              child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFECC880), size: 16),
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
// کارتی شرۆڤەکار
// ============================================================
class _AnalystCard extends StatelessWidget {
  final AnalystModel analyst;
  final int index;
  const _AnalystCard({required this.analyst, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [const Color(0xFF0072FF), const Color(0xFF8B5CF6)];
    final Color accent = colors[index % colors.length];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnalystPortalScreen(analyst: analyst))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
        ),
        child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: accent.withOpacity(0.2))),
            child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildDynamicAvatar(analyst.imagePath, analyst.emoji, 24)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(analyst.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(analyst.title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(children: [
              _chip('${analyst.videos.length}', Icons.play_circle_rounded, const Color(0xFFFF6B6B)),
              const SizedBox(width: 6),
              _chip('${analyst.articles.length}', Icons.article_rounded, const Color(0xFF4ADE80)),
            ]),
          ])),
          Icon(appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded, color: Colors.white24, size: 13),
        ]),
      ),
    );
  }

  Widget _chip(String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

// ============================================================
// پۆڕتاڵی شرۆڤەکار - فیدی تێکەڵ
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
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(children: [
          _buildTopBar(),
          _buildProfile(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
            child: Row(children: [
              const Icon(Icons.dynamic_feed_rounded, color: Color(0xFFECC880), size: 15),
              const SizedBox(width: 8),
              Text(
                appLanguageGlobal == 'English' ? 'Recent Analyses' : 'دواین شرۆڤەکان',
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Expanded(
            child: feed.isEmpty
                ? Center(child: Text(getTxt('no_content'), style: TextStyle(color: Colors.white.withOpacity(0.3))))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: feed.length,
                    itemBuilder: (context, i) {
                      final item = feed[i];
                      if (item is VideoAnalysis) return _VideoCard(video: item, index: i);
                      return _ArticleCard(article: item as WrittenAnalysis, index: i);
                    },
                  ),
          ),
        ])),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))),
            child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: Colors.white, size: 15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(widget.analyst.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
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
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildDynamicAvatar(widget.analyst.imagePath, widget.analyst.emoji, 28)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.analyst.title, style: const TextStyle(color: Color(0xFFECC880), fontSize: 11.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(widget.analyst.description, style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12, height: 1.5)),
        ])),
      ]),
    );
  }
}

// ============================================================
// کارتی ڤیدیۆ - گەورە و جوان
// ============================================================
class _VideoCard extends StatefulWidget {
  final VideoAnalysis video;
  final int index;
  const _VideoCard({required this.video, required this.index});
  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(widget.video.youtubeUrl) ?? '';
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';

    final List<List<Color>> gradients = [
      [const Color(0xFF0072FF), const Color(0xFF00C6FF)],
      [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
      [const Color(0xFF059669), const Color(0xFF34D399)],
    ];
    final colors = gradients[widget.index % gradients.length];

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _VideoDetailView(video: widget.video, index: widget.index))),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ---- تامبنەیلی گەورە ----
            Container(
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(fit: StackFit.expand, children: [

                  Image.network(thumbUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0].withOpacity(0.3), colors[1].withOpacity(0.1)])),
                        child: const Icon(Icons.video_library_rounded, size: 48, color: Colors.white12),
                      )),

                  // گرادییەنت
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),

                  // دەگمەی پلەی
                  Center(
                    child: Container(
                      width: 62, height: 62,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: colors[0].withOpacity(0.6), blurRadius: 20, spreadRadius: 2)],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                    ),
                  ),

                  // ماوە - سەرەوە
                  Positioned(
                    top: 12,
                    right: appLanguageGlobal == 'English' ? null : 12,
                    left: appLanguageGlobal == 'English' ? 12 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.timer_rounded, size: 10, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(formatDisplayNumbers(widget.video.duration), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),

                  // بەروار - خوارەوە
                  Positioned(
                    bottom: 12,
                    right: appLanguageGlobal == 'English' ? null : 12,
                    left: appLanguageGlobal == 'English' ? 12 : null,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.calendar_today_rounded, size: 10, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(formatDisplayNumbers(widget.video.date), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ]),
              ),
            ),

            // ---- ناونیشان ----
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text('${widget.index ~/ 2 + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.video.title, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),

            // ---- شرۆڤەی کورت ----
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Text(
                widget.video.longDescription.length > 100
                    ? '${widget.video.longDescription.substring(0, 100)}...'
                    : widget.video.longDescription,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11.5, height: 1.55),
              ),
            ),

            // ---- دەگمەکانی ئینتەراکتیڤ ----
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
              child: Row(children: [
                _InteractionBtn(icon: Icons.favorite_border_rounded, label: '٤٢', color: const Color(0xFFFF6B6B)),
                const SizedBox(width: 10),
                _InteractionBtn(icon: Icons.chat_bubble_outline_rounded, label: '١٢', color: const Color(0xFF4FC3F7)),
                const SizedBox(width: 10),
                _InteractionBtn(icon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: const Color(0xFF4ADE80)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 8)],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(appLanguageGlobal == 'English' ? 'Watch' : 'تەماشا', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ]),
            ),

            const SizedBox(height: 8),
            Divider(color: Colors.white.withOpacity(0.06), height: 1),

          ]),
        ),
      ),
    );
  }
}

// ============================================================
// دەگمەی ئینتەراکتیڤ (لایک، کۆمێنت، هاوبەشکردن)
// ============================================================
class _InteractionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InteractionBtn({required this.icon, required this.label, required this.color});
  @override
  State<_InteractionBtn> createState() => _InteractionBtnState();
}

class _InteractionBtnState extends State<_InteractionBtn> with SingleTickerProviderStateMixin {
  bool _active = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() => _active = !_active);
    _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: ScaleTransition(
        scale: _scale,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            _active ? _filledIcon(widget.icon) : widget.icon,
            color: _active ? widget.color : Colors.white38,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(widget.label, style: TextStyle(color: _active ? widget.color : Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  IconData _filledIcon(IconData icon) {
    if (icon == Icons.favorite_border_rounded) return Icons.favorite_rounded;
    if (icon == Icons.chat_bubble_outline_rounded) return Icons.chat_bubble_rounded;
    return icon;
  }
}

// ============================================================
// پەڕەی گەورەی ڤیدیۆ
// ============================================================
class _VideoDetailView extends StatelessWidget {
  final VideoAnalysis video;
  final int index;
  const _VideoDetailView({required this.video, required this.index});

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(video.youtubeUrl) ?? '';
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    final List<List<Color>> gradients = [
      [const Color(0xFF0072FF), const Color(0xFF00C6FF)],
      [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
      [const Color(0xFF059669), const Color(0xFF34D399)],
    ];
    final colors = gradients[index % gradients.length];

    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))),
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: Colors.white, size: 15),
                ),
              ),
              const SizedBox(width: 14),
              const Text('شرۆڤەی ڤیدیۆیی', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ]),
          ),

          // تامبنەیلی گەورە
          Container(
            height: 230,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: colors[0].withOpacity(0.25), blurRadius: 30)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(thumbUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0].withOpacity(0.3), colors[1].withOpacity(0.1)])),
                    )),
                Container(color: Colors.black.withOpacity(0.4)),
                Center(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(appLanguageGlobal == 'English' ? 'Live Player Coming Soon.' : 'لێدەری ڕاستەوخۆ بەمزوانە جێگیر دەکرێت.'),
                      backgroundColor: const Color(0xFF0072FF), behavior: SnackBarBehavior.floating,
                    )),
                    child: Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: colors[0].withOpacity(0.5), blurRadius: 20, spreadRadius: 2)],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14, left: 14, right: 14,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(formatDisplayNumbers(video.date), style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    Text(formatDisplayNumbers(video.duration), style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(video.title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                const SizedBox(height: 14),

                // دەگمەکانی ئینتەراکتیڤ
                Row(children: [
                  _InteractionBtn(icon: Icons.favorite_border_rounded, label: '٤٢', color: const Color(0xFFFF6B6B)),
                  const SizedBox(width: 14),
                  _InteractionBtn(icon: Icons.chat_bubble_outline_rounded, label: '١٢', color: const Color(0xFF4FC3F7)),
                  const SizedBox(width: 14),
                  _InteractionBtn(icon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: const Color(0xFF4ADE80)),
                ]),

                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.08), height: 1),
                const SizedBox(height: 16),

                // ناونیشانی شرۆڤە
                Row(children: [
                  Container(width: 4, height: 16, decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  const Text('نووسینی ڕوونکەرەوەی شرۆڤەکار', style: TextStyle(color: Color(0xFFECC880), fontSize: 13, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),

                Text(video.longDescription, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14, height: 1.75, fontWeight: FontWeight.w500)),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ])),
      ),
    );
  }
}

// ============================================================
// کارتی وتار
// ============================================================
class _ArticleCard extends StatelessWidget {
  final WrittenAnalysis article;
  final int index;
  const _ArticleCard({required this.article, required this.index});

  String _readTime(String content) {
    final minutes = (content.split(' ').length / 200).ceil();
    if (appLanguageGlobal == 'English') return '$minutes min read';
    return '$minutes خولەک خوێندن';
  }

  String _preview(String content) {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> accents = [const Color(0xFF0072FF), const Color(0xFF8B5CF6), const Color(0xFF059669)];
    final Color accent = accents[index % accents.length];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ArticleReadView(article: article, accent: accent, readTime: _readTime(article.content)))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF131C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: accent.withOpacity(0.2))),
              child: Icon(Icons.article_rounded, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, height: 1.35), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(6)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.calendar_today_rounded, size: 9, color: Colors.white.withOpacity(0.35)),
                    const SizedBox(width: 4),
                    Text(formatDisplayNumbers(article.date), style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10)),
                  ]),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: accent.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.timer_outlined, size: 9, color: accent.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text(_readTime(article.content), style: TextStyle(color: accent.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ]),
            ])),
          ]),

          const SizedBox(height: 10),

          // پوختەی دەق
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF0B121F), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.04))),
            child: Text(_preview(article.content), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11.5, height: 1.6, fontStyle: FontStyle.italic)),
          ),

          const SizedBox(height: 10),

          // دەگمەکانی ئینتەراکتیڤ
          Row(children: [
            _InteractionBtn(icon: Icons.favorite_border_rounded, label: '٢٨', color: const Color(0xFFFF6B6B)),
            const SizedBox(width: 10),
            _InteractionBtn(icon: Icons.chat_bubble_outline_rounded, label: '٧', color: const Color(0xFF4FC3F7)),
            const SizedBox(width: 10),
            _InteractionBtn(icon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: const Color(0xFF4ADE80)),
            const Spacer(),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(appLanguageGlobal == 'English' ? 'Read more' : 'زیاتر بخوێنەوە', style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Icon(appLanguageGlobal == 'English' ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded, color: accent, size: 13),
            ]),
          ]),

        ]),
      ),
    );
  }
}

// ============================================================
// شاشەی خوێندنەوەی وتار - وەک بۆرسەی عێراق
// ============================================================
class _ArticleReadView extends StatelessWidget {
  final WrittenAnalysis article;
  final Color accent;
  final String readTime;
  const _ArticleReadView({required this.article, required this.accent, required this.readTime});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // تۆپ بار
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))),
                  child: Icon(appLanguageGlobal == 'English' ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_rounded, color: Colors.white, size: 15),
                ),
              ),
              const SizedBox(width: 12),
              // لۆگۆی بۆرسەی عێراق وەک تایتڵ
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [accent, accent.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 13),
                    SizedBox(width: 5),
                    Text('بۆرسەی عێراق', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                  ]),
                ),
              ]),
            ]),
          ),

          // هێدەری وتار
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, height: 1.4)),
              const SizedBox(height: 12),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Icon(Icons.calendar_today_rounded, size: 10, color: Colors.white.withOpacity(0.4)),
                    const SizedBox(width: 5),
                    Text(formatDisplayNumbers(article.date), style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ]),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: accent.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Icon(Icons.timer_outlined, size: 10, color: accent),
                    const SizedBox(width: 5),
                    Text(readTime, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
                const Spacer(),
                // دەگمەی هاوبەشکردن
                _InteractionBtn(icon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: const Color(0xFF4ADE80)),
              ]),
            ]),
          ),

          const SizedBox(height: 14),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(color: Colors.white.withOpacity(0.07), height: 1)),
          const SizedBox(height: 16),

          // ناوەڕۆکی وتار
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    // هێڵی رەنگین لە لای
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [accent, accent.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildLinkableText(
                        article.content,
                        TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 15.5, height: 1.85, fontWeight: FontWeight.w500),
                        const Color(0xFF00C6FF),
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 24),

                // دەگمەکانی لایک و کۆمێنت
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.07))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _InteractionBtn(icon: Icons.favorite_border_rounded, label: '٢٨', color: const Color(0xFFFF6B6B)),
                    Container(width: 1, height: 24, color: Colors.white.withOpacity(0.07)),
                    _InteractionBtn(icon: Icons.chat_bubble_outline_rounded, label: '٧', color: const Color(0xFF4FC3F7)),
                    Container(width: 1, height: 24, color: Colors.white.withOpacity(0.07)),
                    _InteractionBtn(icon: Icons.share_rounded, label: appLanguageGlobal == 'English' ? 'Share' : 'هاوبەشکردن', color: const Color(0xFF4ADE80)),
                  ]),
                ),

                const SizedBox(height: 30),
              ]),
            ),
          ),

        ])),
      ),
    );
  }
}