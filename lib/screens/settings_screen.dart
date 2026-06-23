// ignore_for_file: deprecated_member_use
// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import '../global_state.dart';
import '../widgets/auth_sheets.dart';
import '../main.dart'; // بۆ بانگکردنی BoursePremiumApp.rebuild

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _simulateAction(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F),
        body: SafeArea(
          child: Column(
            children: [
              _buildSettingsHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                  children: [
                    _sectionLabel(getTxt('account_section')),
                    isLoggedInGlobal 
                        ? _buildConsolidatedAccountCard() // تەنها یەک ئایکۆنی ڕێکخراو لە جیاتی جەنجاڵی پێشوو
                        : _buildNotLoggedInCard(),
                    
                    const SizedBox(height: 16),
                    _sectionLabel(getTxt('settings_title')),
                    _buildCard([
                      // --- هەڵبژاردنی زمان ---
                      _buildSettingsTile(
                        icon: Icons.language_rounded,
                        title: getTxt('choose_lang'),
                        subtitle: appLanguageGlobal,
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: appLanguageGlobal,
                            dropdownColor: const Color(0xFF131C2E),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            items: ['کوردی', 'العربية', 'English'].map((val) => DropdownMenuItem<String>(value: val, child: Text(val))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  appLanguageGlobal = val;
                                });
                                BoursePremiumApp.rebuild(context);
                              }
                            },
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1),
                      // --- هەڵبژاردنی شێوازی ژمارەکان بە ئازادی ---
                      _buildSettingsTile(
                        icon: Icons.numbers_rounded,
                        title: getTxt('numeral_style'),
                        subtitle: appNumeralStyleGlobal == '123' ? getTxt('numeral_western') : getTxt('numeral_eastern'),
                        iconColor: const Color(0xFF00C6FF),
                        iconBg: const Color(0xFF00C6FF).withOpacity(0.15),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: appNumeralStyleGlobal,
                            dropdownColor: const Color(0xFF131C2E),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            items: [
                              DropdownMenuItem(value: '123', child: Text(getTxt('numeral_western'))),
                              DropdownMenuItem(value: '١٢٣', child: Text(getTxt('numeral_eastern'))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  appNumeralStyleGlobal = val;
                                });
                                BoursePremiumApp.rebuild(context);
                              }
                            },
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1),
                      // --- قەبارەی فۆنت ---
                      _buildSettingsTile(
                        icon: Icons.format_size_rounded,
                        title: getTxt('font_size'),
                        subtitle: fontScaleMultiplierGlobal == 0.85 
                            ? (appLanguageGlobal == 'English' ? 'Small' : (appLanguageGlobal == 'العربية' ? 'صغير' : 'بچووک')) 
                            : fontScaleMultiplierGlobal == 1.25 
                                ? (appLanguageGlobal == 'English' ? 'Large' : (appLanguageGlobal == 'العربية' ? 'كبير' : 'گەورە')) 
                                : (appLanguageGlobal == 'English' ? 'Medium' : (appLanguageGlobal == 'العربية' ? 'متوسط' : 'مامناوەند')),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            value: fontScaleMultiplierGlobal,
                            dropdownColor: const Color(0xFF131C2E),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            items: const [
                              DropdownMenuItem(value: 0.85, child: Text('0.85')),
                              DropdownMenuItem(value: 1.0, child: Text('1.0')),
                              DropdownMenuItem(value: 1.25, child: Text('1.25')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  fontScaleMultiplierGlobal = val;
                                });
                                BoursePremiumApp.rebuild(context);
                              }
                            },
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1),
                      _buildSettingsTile(
                        icon: Icons.notifications_active_rounded,
                        title: getTxt('notifications'),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeColor: const Color(0xFF22C55E),
                          onChanged: (val) => setState(() => _notificationsEnabled = val),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 16),
                    _sectionLabel(getTxt('share_section')),
                    _buildCard([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: _buildDownloadButton(Icons.play_arrow_rounded, 'Android App', const Color(0xFF22C55E))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDownloadButton(Icons.apple_rounded, 'iOS App', Colors.white)),
                          ],
                        ),
                      )
                    ]),

                    const SizedBox(height: 16),
                    _sectionLabel(getTxt('contact_section')),
                    _buildCard([
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                appLanguageGlobal == 'English'
                                    ? 'To activate, contact us via WhatsApp or Viber'
                                    : (appLanguageGlobal == 'العربية' 
                                        ? 'للتفعيل تواصل معنا عبر واتساب أو فایبر' 
                                        : 'بۆ چالاککردنی ئەژمارەکەت پەیوەندیمان پێوە بکە لە واتسئەپ یان ڤایبەر'),
                                style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildContactRow('+964 750 585 6964'),
                            _buildContactRow('+964 772 585 6969'),
                          ],
                        ),
                      )
                    ]),

                    const SizedBox(height: 16),
                    _sectionLabel(getTxt('test_panel')),
                    _buildCard([
                      _buildSettingsTile(
                        icon: Icons.timer_outlined,
                        title: getTxt('trial_active'),
                        subtitle: isGlobalFreeTrialActive ? getTxt('trial_active') : getTxt('trial_inactive'),
                        iconColor: Colors.orangeAccent,
                        iconBg: Colors.orangeAccent.withOpacity(0.15),
                        trailing: Switch(
                          value: isGlobalFreeTrialActive,
                          activeColor: Colors.orangeAccent,
                          onChanged: (val) {
                            setState(() {
                              isGlobalFreeTrialActive = val;
                            });
                          },
                        ),
                      ),
                    ]),

                    const SizedBox(height: 32),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), 
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1))
      ),
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
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(getTxt('settings_title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
        const Icon(Icons.menu_book_rounded, color: Colors.white60, size: 18),
      ]),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon, 
    required String title, 
    String? subtitle, 
    Widget? trailing, 
    Color iconColor = const Color(0xFF22C55E),
    Color? iconBg,
    VoidCallback? onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Container(
            width: 36, height: 36, 
            decoration: BoxDecoration(
              color: iconBg ?? const Color(0xFF22C55E).withOpacity(0.15), 
              borderRadius: BorderRadius.circular(10)
            ), 
            child: Icon(icon, size: 18, color: iconColor)
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white)),
            if (subtitle != null) ...[const SizedBox(height: 3), Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)))],
          ])),
          trailing ?? Icon(
            appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded, 
            size: 12, 
            color: Colors.white24
          ),
        ]),
      ),
    );
  }

  Widget _buildDownloadButton(IconData icon, String text, Color color) {
    return InkWell(
      onTap: () => _simulateAction('داگرتنی پڕۆگرامی $text...'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String number) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0B121F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildCircleActionButton(Icons.phone_rounded, const Color(0xFF0072FF), () {
            _simulateAction('پەیوەندی دەکات بە $number...');
          }),
          const SizedBox(width: 8),
          _buildCircleActionButton(Icons.phone_iphone_rounded, Colors.purpleAccent, () {
            _simulateAction('ڤایبەری $number دەکاتەوە...');
          }),
          const SizedBox(width: 8),
          _buildCircleActionButton(Icons.chat_bubble_rounded, const Color(0xFF22C55E), () {
            _simulateAction('واتسئەپی $number دەکاتەوە...');
          }),
          const Spacer(),
          Text(
            formatDisplayNumbers(number),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }

  // دروستکردنی کارتی نوێ و یەکگرتوو بۆ سەرەوەی لیستەکە بێ جەنجاڵی (iOS Settings Style)
  Widget _buildConsolidatedAccountCard() {
    String displayName = userDisplayNameGlobal;
    if (displayName.isEmpty && userPhoneNumberGlobal.isNotEmpty) {
      displayName = registeredNamesDb[userPhoneNumberGlobal] ?? 'بەکارهێنەر';
    }

    return _buildCard([
      _buildSettingsTile(
        icon: Icons.person_pin_rounded,
        title: appLanguageGlobal == 'English' ? 'My Account' : (appLanguageGlobal == 'العربية' ? 'حسابي' : 'ئەژمارەکەم'),
        subtitle: displayName.isNotEmpty ? formatDisplayNumbers(displayName) : 'بەکارهێنەر',
        iconColor: const Color(0xFF76C917),
        iconBg: const Color(0xFF76C917).withOpacity(0.12),
        onTap: () {
          // هەناردەکردنی بەکارهێنەر بۆ لاپەڕەی نوێی سەربەخۆ بێ شێواندنی مۆدێلی مێنوی ڕێکخستنەکان
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountDetailsScreen()),
          ).then((_) {
            // نوێکردنەوەی لۆکاڵی شاشەی ڕێکخستنەکان ئەگەر لەناو ئەپەکە لۆگ دەرچوو بێت
            setState(() {});
          });
        },
      ),
    ]);
  }

  Widget _buildNotLoggedInCard() {
    return _buildCard([
      _buildSettingsTile(
        icon: Icons.login_rounded,
        title: getTxt('login_btn'),
        onTap: () {
          showLoginBottomSheet(context, onStateChanged: () {
            setState(() {});
          });
        },
      ),
    ]);
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, right: 4, top: 4),
    child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4))),
  );

  Widget _buildFooter() {
    return Center(child: Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1E293B))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
            const SizedBox(width: 6),
            Text(formatDisplayNumbers('وەشانی 1.0.0'), style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        appLanguageGlobal == 'English' 
            ? 'Iraq Bourse • Copyright 2026' 
            : (appLanguageGlobal == 'العربية' ? 'بورصة العراق • حقوق النشر ٢٠٢٦' : 'بۆرسەی عێراق • کۆپیرایت ٢٠٢٦'), 
        style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.2))
      ),
    ]));
  }
}

// ============================================================================
// شاشەی تایبەت و سەربەخۆ بۆ نیشاندانی وردەکاری ئەکاونت (Account Details Screen)
// ============================================================================
class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

    String displayName = userDisplayNameGlobal;
    if (displayName.isEmpty && userPhoneNumberGlobal.isNotEmpty) {
      displayName = registeredNamesDb[userPhoneNumberGlobal] ?? 'بەکارهێنەر';
    }

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B121F), // پاشبنەمای فەرمی تاریکی ئەپەکە
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF131C2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Column(
                        children: [
                          _buildTile(
                            icon: Icons.person_rounded,
                            title: displayName.isNotEmpty ? formatDisplayNumbers(displayName) : 'بەکارهێنەر',
                            subtitle: appLanguageGlobal == 'English' ? 'Name' : (appLanguageGlobal == 'العربية' ? 'الاسم' : 'ناو'),
                            iconColor: Colors.white70,
                          ),
                          const Divider(color: Color(0xFF1E293B), height: 1),
                          _buildTile(
                            icon: Icons.phone_iphone_rounded,
                            title: userPhoneNumberGlobal.isNotEmpty ? formatDisplayNumbers(userPhoneNumberGlobal) : formatDisplayNumbers('+964 773 154 7371'),
                            subtitle: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژمارەی مۆبایل'),
                            iconColor: Colors.white70,
                          ),
                          const Divider(color: Color(0xFF1E293B), height: 1),
                          _buildTile(
                            icon: Icons.calendar_month_rounded,
                            title: formatDisplayNumbers(activationDateGlobal),
                            subtitle: appLanguageGlobal == 'English' ? 'Subscription Start' : (appLanguageGlobal == 'العربية' ? 'تاريخ البدء' : 'سەرەتای بەشداری'),
                            iconColor: Colors.white70,
                          ),
                          const Divider(color: Color(0xFF1E293B), height: 1),
                          _buildTile(
                            icon: Icons.calendar_today_rounded,
                            title: formatDisplayNumbers(expiryDateGlobal),
                            subtitle: appLanguageGlobal == 'English' ? 'Subscription End' : (appLanguageGlobal == 'العربية' ? 'انتهاء الاشتراك' : 'کۆتایی هاتنی بەشداری'),
                            iconColor: Colors.white70,
                          ),
                          const Divider(color: Color(0xFF1E293B), height: 1),
                          _buildTile(
                            icon: Icons.vpn_key_rounded,
                            title: appLanguageGlobal == 'English' ? 'Change Password' : (appLanguageGlobal == 'العربية' ? 'تغيير كلمة السر' : 'گۆڕینی پاسۆرد'),
                            iconColor: Colors.white70,
                            trailing: Icon(
                              appLanguageGlobal == 'English' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, 
                              size: 12, 
                              color: Colors.white30
                            ),
                            onTap: () {
                              // پیشاندانی دیالۆگی ناوەڕاستی پشتگیری بۆ گۆڕینی پاسۆرد
                              showSupportContactDialog(context);
                            },
                          ),
                          const Divider(color: Color(0xFF1E293B), height: 1),
                          _buildTile(
                            icon: Icons.logout_rounded,
                            title: getTxt('logout'),
                            iconColor: Colors.redAccent,
                            iconBg: const Color(0xFF2E0F0F),
                            onTap: () {
                              // پرۆسەی چوونە دەرەوە و گەڕانەوە بۆ لاپەڕەی پێشوو
                              isLoggedInGlobal = false;
                              isPremiumActiveGlobal = false;
                              userPhoneNumberGlobal = '';
                              userDisplayNameGlobal = '';
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), 
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1))
      ),
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
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            appLanguageGlobal == 'English' ? 'My Account' : (appLanguageGlobal == 'العربية' ? 'حسابي' : 'ئەژمارەکەم'), 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
          )
        ),
      ]),
    );
  }

  Widget _buildTile({
    required IconData icon, 
    required String title, 
    String? subtitle, 
    Widget? trailing, 
    Color iconColor = Colors.white70,
    Color? iconBg,
    VoidCallback? onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Container(
            width: 36, height: 36, 
            decoration: BoxDecoration(
              color: iconBg ?? const Color(0xFF1E293B), 
              borderRadius: BorderRadius.circular(10)
            ), 
            child: Icon(icon, size: 18, color: iconColor)
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white)),
            if (subtitle != null) ...[const SizedBox(height: 3), Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)))],
          ])),
          trailing ?? const SizedBox(),
        ]),
      ),
    );
  }
}