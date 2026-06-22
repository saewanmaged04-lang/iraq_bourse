// ignore_for_file: deprecated_member_use
// lib/widgets/auth_sheets.dart

import 'package:flutter/material.dart';
import '../global_state.dart';
import '../main.dart';

String cleanAndFormatPhoneNumber(String raw) {
  String clean = raw.trim();
  if (clean.startsWith('0')) clean = '+964${clean.substring(1)}';
  else if (!clean.startsWith('+964')) clean = '+964$clean';
  return clean;
}

void _toggleLanguage(BuildContext context, StateSetter setModalState) {
  setModalState(() {
    if (appLanguageGlobal == 'کوردی') appLanguageGlobal = 'العربية';
    else if (appLanguageGlobal == 'العربية') appLanguageGlobal = 'English';
    else appLanguageGlobal = 'کوردی';
  });
  BoursePremiumApp.rebuild(context);
}

// ============================================================================
// دیزاینە تایبەتەکان ڕێک هاوشێوەی وێنە ئەسڵییەکە 
// ============================================================================

Widget _buildAuthHeader(BuildContext context, StateSetter setModalState, String title, String subtitle) {
  return Column(
    children: [
      Align(
        alignment: appLanguageGlobal == 'English' ? Alignment.topRight : Alignment.topLeft,
        child: GestureDetector(
          onTap: () => _toggleLanguage(context, setModalState),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.g_translate_rounded, color: Colors.white54, size: 20),
          ),
        ),
      ),
      const SizedBox(height: 10),
      
      // ==========================================
      // لێرەدا وێنە PNG یەکە بە شەفافی دادەنرێت
      // ==========================================
      Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.02),
          // ئەو درەوشانەوەیەی پشت وێنەکە (سپی کاڵ)
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 40,
              spreadRadius: 10,
            )
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/logo.png', // ناوی وێنە نوێیەکەتە کە داینێین
            fit: BoxFit.contain,
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_outlined, size: 50, color: Colors.white24);
            },
          ),
        ),
      ),
      const SizedBox(height: 16),
      
      Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      
      Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 40),
    ],
  );
}

Widget _buildAuthTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
  bool isPassword = false,
  bool isVisible = false,
  VoidCallback? onVisibilityToggle,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword && !isVisible,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Icon(prefixIcon, color: Colors.white.withOpacity(0.3), size: 22),
      ), 
      suffixIcon: isPassword 
          ? GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white.withOpacity(0.3), size: 20),
            ) 
          : null,
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF3BEE7B), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    ),
  );
}

Widget _buildGlowButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF5CF58E), Color(0xFF1CB75D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: const Color(0xFF23D063).withOpacity(0.4), blurRadius: 25, spreadRadius: 2, offset: const Offset(0, 2))
        ],
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Color(0xFF04101A), fontSize: 15, fontWeight: FontWeight.w900))),
    ),
  );
}

Widget _buildOutlineButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2), 
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
    ),
  );
}

// -----------------------------------------------------------------------------
// بەشی ١: شاشەی چوونەژوورەوەی سەرەکی (Login)
// -----------------------------------------------------------------------------
void showLoginBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
          
          return Directionality(
            textDirection: textDirection,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95, 
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAuthHeader(context, setModalState, appLanguageGlobal == 'English' ? 'Log In' : (appLanguageGlobal == 'العربية' ? 'تسجيل الدخول' : 'چوونەژوورەوە'), appLanguageGlobal == 'English' ? 'Welcome to Kurdistan Bourse - Iraq' : (appLanguageGlobal == 'العربية' ? 'مرحباً بك في بورصة كوردستان - العراق' : 'بەخێربێیت بۆ بۆرسەی کوردستان - عێراق')),
                    _buildAuthTextField(controller: phoneController, hintText: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژمارەی مۆبایل'), prefixIcon: Icons.phone_iphone_rounded, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildAuthTextField(controller: passwordController, hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'), prefixIcon: Icons.lock_outline_rounded, isPassword: true, isVisible: isPasswordVisible, onVisibilityToggle: () { setModalState(() => isPasswordVisible = !isPasswordVisible); }),
                    const SizedBox(height: 12),
                    Align(
                      alignment: appLanguageGlobal == 'English' ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () { Navigator.pop(context); showForgotPasswordPhoneBottomSheet(context, onStateChanged: onStateChanged); },
                        child: Text(appLanguageGlobal == 'English' ? 'Forgot password?' : (appLanguageGlobal == 'العربية' ? 'هل نسيت كلمة السر؟' : 'ووشەی نهێنی لەبیرکردووە؟'), style: const TextStyle(color: Color(0xFF6DE899), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildGlowButton(appLanguageGlobal == 'English' ? 'Log In' : (appLanguageGlobal == 'العربية' ? 'تسجيل الدخول' : 'چوونەژوورەوە'), () {
                      String phone = phoneController.text.trim();
                      String pass = passwordController.text.trim();
                      if (phone.isEmpty || pass.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Please fill all fields' : 'تکایە هەموو خانەکان پڕبکەوە'))); return; }
                      phone = cleanAndFormatPhoneNumber(phone);
                      if (registeredUsersDb.containsKey(phone) && registeredUsersDb[phone] == pass) {
                        isLoggedInGlobal = true; userPhoneNumberGlobal = phone;
                        if (phone == '+9647701234567') { isPremiumActiveGlobal = false; activationDateGlobal = '١٨ / ٤ / ٢٠٢٦'; expiryDateGlobal = '١٨ / ٦ / ٢٠٢٦'; } 
                        else { isPremiumActiveGlobal = true; activationDateGlobal = '١٨ / ٦ / ٢٠٢٦'; expiryDateGlobal = '١٨ / ٨ / ٢٠٢٦'; }
                        Navigator.pop(context); onStateChanged();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Login successful!' : 'بە سەرکەوتوویی چوویتە ژوورەوە!'), backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Phone or password incorrect!' : 'ژمارە یان پاسۆردەکە هەڵەیە!'), backgroundColor: Colors.redAccent));
                      }
                    }),
                    const SizedBox(height: 24),
                    Row(children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(appLanguageGlobal == 'English' ? 'OR' : (appLanguageGlobal == 'العربية' ? 'أو' : 'یان'), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11))),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
                    ]),
                    const SizedBox(height: 24),
                    _buildOutlineButton(appLanguageGlobal == 'English' ? 'Create New Account' : (appLanguageGlobal == 'العربية' ? 'إنشاء حساب جديد' : 'دروستکردنی هەژماری نوێ'), () {
                      Navigator.pop(context); showRegisterPhoneBottomSheet(context, onStateChanged: onStateChanged);
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// -----------------------------------------------------------------------------
// بەشی ٢: دروستکردنی ئەژماری نوێ 
// -----------------------------------------------------------------------------
void showRegisterPhoneBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController phoneController = TextEditingController();
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildAuthHeader(context, setModalState, getTxt('register_title'), appLanguageGlobal == 'English' ? 'Enter your phone number to start' : (appLanguageGlobal == 'العربية' ? 'أدخل رقم هاتفك للبدء' : 'ژمارەی مۆبایلەکەت بنووسە بۆ دەستپێکردن')),
                _buildAuthTextField(controller: phoneController, hintText: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژماری مۆبایل'), prefixIcon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                const SizedBox(height: 40),
                _buildGlowButton(getTxt('submit_btn'), () {
                  String phone = phoneController.text.trim();
                  if (phone.isEmpty) return;
                  phone = cleanAndFormatPhoneNumber(phone);
                  if (registeredUsersDb.containsKey(phone)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Phone already registered!' : 'ئەم ژمارەیە پێشتر تۆمارکراوە!'), backgroundColor: Colors.redAccent)); return;
                  }
                  Navigator.pop(context); showRegisterOtpBottomSheet(context, phone, onStateChanged: onStateChanged);
                }),
              ]),
            ),
          ),
        );
      }
    ),
  );
}

// -----------------------------------------------------------------------------
// بەشی ٣: کۆدی OTP
// -----------------------------------------------------------------------------
void showRegisterOtpBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController otpController = TextEditingController();
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildAuthHeader(context, setModalState, getTxt('otp_title'), '${getTxt('otp_desc')} ($phoneNumber)'),
                _buildAuthTextField(controller: otpController, hintText: getTxt('otp_hint'), prefixIcon: Icons.message_outlined, keyboardType: TextInputType.number),
                const SizedBox(height: 40),
                _buildGlowButton(getTxt('submit_btn'), () {
                  if (otpController.text.trim() == '1234') { Navigator.pop(context); showRegisterPasswordBottomSheet(context, phoneNumber, onStateChanged: onStateChanged); } 
                  else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Code incorrect!' : 'کۆدەکە هەڵەیە!'), backgroundColor: Colors.redAccent)); }
                }),
              ]),
            ),
          ),
        );
      }
    ),
  );
}

// -----------------------------------------------------------------------------
// بەشی ٤: دانانی پاسۆرد
// -----------------------------------------------------------------------------
void showRegisterPasswordBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Directionality(
            textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _buildAuthHeader(context, setModalState, getTxt('set_password_title'), getTxt('password_length_hint')),
                  _buildAuthTextField(controller: passwordController, hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'), prefixIcon: Icons.lock_outline_rounded, isPassword: true, isVisible: isPasswordVisible, onVisibilityToggle: () { setModalState(() => isPasswordVisible = !isPasswordVisible); }),
                  const SizedBox(height: 40),
                  _buildGlowButton(getTxt('submit_btn'), () {
                    String pass = passwordController.text.trim();
                    if (pass.length < 4) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'At least 4 characters!' : 'پاسۆرد نابێت لە ٤ پیت کەمتر بێت'), backgroundColor: Colors.redAccent)); return; }
                    registeredUsersDb[phoneNumber] = pass; isLoggedInGlobal = true; userPhoneNumberGlobal = phoneNumber; isPremiumActiveGlobal = true; 
                    activationDateGlobal = '١٨ / ٦ / ٢٠٢٦'; expiryDateGlobal = '١٨ / ٨ / ٢٠٢٦'; 
                    Navigator.pop(context); onStateChanged();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Account created!' : 'هەژمارەکەت بە سەرکەوتوویی دروستکرا!'), backgroundColor: Colors.green));
                  }),
                ]),
              ),
            ),
          );
        },
      );
    },
  );
}

// -----------------------------------------------------------------------------
// بەشی ٥: بیرچوونەوەی پاسۆرد
// -----------------------------------------------------------------------------
void showForgotPasswordPhoneBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController phoneController = TextEditingController();
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildAuthHeader(context, setModalState, appLanguageGlobal == 'English' ? 'Reset Password' : (appLanguageGlobal == 'العربية' ? 'استعادة كلمة السر' : 'گۆڕینی پاسۆرد'), getTxt('forgot_pass_phone_desc')),
                _buildAuthTextField(controller: phoneController, hintText: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژماری مۆبایل'), prefixIcon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                const SizedBox(height: 40),
                _buildGlowButton(getTxt('submit_btn'), () {
                  String phone = phoneController.text.trim();
                  if (phone.isEmpty) return;
                  phone = cleanAndFormatPhoneNumber(phone);
                  if (!registeredUsersDb.containsKey(phone)) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Account not found!' : 'ئەم ژمارەیە پێشتر تۆمار نەکراوە!'), backgroundColor: Colors.redAccent)); return; }
                  Navigator.pop(context); showForgotPasswordOtpBottomSheet(context, phone, onStateChanged: onStateChanged);
                }),
              ]),
            ),
          ),
        );
      }
    ),
  );
}

void showForgotPasswordOtpBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController otpController = TextEditingController();
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildAuthHeader(context, setModalState, getTxt('otp_title'), '${getTxt('otp_desc')} ($phoneNumber)'),
                _buildAuthTextField(controller: otpController, hintText: getTxt('otp_hint'), prefixIcon: Icons.message_outlined, keyboardType: TextInputType.number),
                const SizedBox(height: 40),
                _buildGlowButton(getTxt('submit_btn'), () {
                  if (otpController.text.trim() == '1234') { Navigator.pop(context); showForgotPasswordNewPasswordBottomSheet(context, phoneNumber, onStateChanged: onStateChanged); } 
                  else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Code incorrect!' : 'کۆدەکە هەڵەیە!'), backgroundColor: Colors.redAccent)); }
                }),
              ]),
            ),
          ),
        );
      }
    ),
  );
}

void showForgotPasswordNewPasswordBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Directionality(
          textDirection: appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildAuthHeader(context, setModalState, appLanguageGlobal == 'English' ? 'Enter New Password' : (appLanguageGlobal == 'العربية' ? 'أدخل كلمة السر الجديدة' : 'پاسۆردی نوێ بنووسە'), getTxt('password_length_hint')),
                _buildAuthTextField(controller: passwordController, hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'), prefixIcon: Icons.lock_outline_rounded, isPassword: true, isVisible: isPasswordVisible, onVisibilityToggle: () { setModalState(() => isPasswordVisible = !isPasswordVisible); }),
                const SizedBox(height: 40),
                _buildGlowButton(getTxt('submit_btn'), () {
                  String newPass = passwordController.text.trim();
                  if (newPass.length < 4) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'At least 4 characters!' : 'پاسۆرد نابێت لە ٤ پیت کەمتر بێت'), backgroundColor: Colors.redAccent)); return; }
                  registeredUsersDb[phoneNumber] = newPass; Navigator.pop(context); onStateChanged();
                }),
              ]),
            ),
          ),
        );
      }
    ),
  );
}