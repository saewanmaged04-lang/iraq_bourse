// ignore_for_file: deprecated_member_use
// lib/widgets/auth_sheets.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // هاوردەکردنی url_launcher
import '../global_state.dart';
import '../main.dart';

String cleanAndFormatPhoneNumber(String raw) {
  String clean = raw.trim().replaceAll(' ', '').replaceAll('-', '');
  
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  for (int i = 0; i < 10; i++) {
    clean = clean.replaceAll(eastern[i], western[i]);
  }

  if (clean.startsWith('0')) {
    clean = '+964${clean.substring(1)}';
  } else if (clean.startsWith('7') || clean.startsWith('5') || clean.startsWith('8')) {
    clean = '+964$clean';
  } else if (!clean.startsWith('+964')) {
    clean = '+964$clean';
  }
  return clean;
}

void _toggleLanguage(BuildContext context, StateSetter setModalState) {
  setModalState(() {
    if (appLanguageGlobal == 'کوردی') {
      appLanguageGlobal = 'العربية';
    } else if (appLanguageGlobal == 'العربية') {
      appLanguageGlobal = 'English';
    } else {
      appLanguageGlobal = 'کوردی';
    }
  });
  BoursePremiumApp.rebuild(context);
}

// ============================================================================
// دیزاینی ئەوپەڕی کورتکراوە و ڕێکخراوی هێدەر بێ کێشەی سکرۆڵ
// ============================================================================
Widget _buildAuthHeader(BuildContext context, StateSetter setModalState, String title, String subtitle) {
  final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _toggleLanguage(context, setModalState),
            child: Container(
              padding: const EdgeInsets.all(5), 
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.g_translate_rounded, color: Colors.white54, size: 16), 
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                textDirection == TextDirection.ltr 
                    ? Icons.arrow_back_ios_new_rounded 
                    : Icons.arrow_back_ios_rounded, 
                color: Colors.white54, 
                size: 16
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6), 
      
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.02),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 30,
              spreadRadius: 8,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'assets/log.png', 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.image_outlined, size: 36, color: Colors.white24),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 8), 
      Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold), 
      ),
      const SizedBox(height: 4), 
      Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.5), 
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12), 
    ],
  );
}

Widget _buildSleekErrorBox(String message) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF2E1212), 
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE53E3E).withOpacity(0.25), width: 1.2),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline_rounded, color: Color(0xFFE53E3E), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Color(0xFFFF9E9E),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

void showSupportContactDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
      return Directionality(
        textDirection: textDirection,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF13151B), 
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF16181F),
                    border: Border.all(color: const Color(0xFF76C917).withOpacity(0.2), width: 2),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded, 
                    size: 38, 
                    color: Color(0xFF76C917)
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  appLanguageGlobal == 'English' ? 'Change Password' : (appLanguageGlobal == 'العربية' ? 'تغيير كلمة السر' : 'گۆڕینی پاسۆرد'),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  appLanguageGlobal == 'English' 
                      ? 'To change or recover your password, please contact our support team.' 
                      : (appLanguageGlobal == 'العربية' ? 'لتغيير كلمة السر أو استعادتها، يرجى التواصل مع فريق الدعم.' : 'بۆ گۆڕین یان وەرگرتنەوەی پاسۆردەکەت, تکایە پەیوەندیدە بە تیمی پشتگیریمانەوە بکە.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _buildContactCardItem('+964 773 145 4737'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2129),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      appLanguageGlobal == 'English' ? 'Close' : (appLanguageGlobal == 'العربية' ? 'إغلاق' : 'داخستن'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
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
    style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Icon(prefixIcon, color: Colors.white.withOpacity(0.3), size: 20),
      ), 
      suffixIcon: isPassword 
          ? GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(
                isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                color: Colors.white.withOpacity(0.3), 
                size: 18
              ),
            ) 
          : null,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF3BEE7B), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12), 
    ),
  );
}

Widget _buildGlowButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12), 
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5CF58E), Color(0xFF1CB75D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF23D063).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFF04101A), fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),
    ),
  );
}

Widget _buildGlowButtonWithCustomBg(String text, VoidCallback onTap, Color color) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12), 
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFF04101A), fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),
    ),
  );
}

Widget _buildOutlineButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12), 
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

// ============================================================================
// فلووی چوونەژوورەوەی ئەوپەڕی کورتکراوی نوێ بێ کێشەی سکرۆڵ
// ============================================================================
void showLoginBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String? localError; 

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, 
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter, 
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330), 
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF131834), Color(0xFF0B0E1D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 12, 
                left: 24, right: 24, top: 12,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    _buildAuthHeader(
                      context, 
                      setModalState, 
                      appLanguageGlobal == 'English' ? 'Log In' : (appLanguageGlobal == 'العربية' ? 'تسجيل الدخول' : 'چوونەژوورەوە'), 
                      appLanguageGlobal == 'English' ? 'Welcome to Kurdistan Bourse - Iraq' : (appLanguageGlobal == 'العربية' ? 'مرحباً بك في بورصة كوردستان - العراق' : 'بەخێربێیت بۆ بۆرسەی کوردستان - عێراق')
                    ),

                    _buildAuthTextField(
                      controller: phoneController,
                      hintText: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژمارەی مۆبایل'),
                      prefixIcon: Icons.phone_iphone_rounded, 
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 8), 
                    
                    _buildAuthTextField(
                      controller: passwordController,
                      hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'),
                      prefixIcon: Icons.lock_outline_rounded, 
                      isPassword: true,
                      isVisible: isPasswordVisible,
                      onVisibilityToggle: () {
                        setModalState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),
                    const SizedBox(height: 8), 

                    Align(
                      alignment: appLanguageGlobal == 'English' ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          showSupportContactDialog(context);
                        },
                        child: Text(
                          appLanguageGlobal == 'English' ? 'Forgot password?' : (appLanguageGlobal == 'العربية' ? 'هل نسيت كلمة السر؟' : 'ووشەی نهێنی لەبیرکردووه؟'), 
                          style: const TextStyle(color: Color(0xFF6DE899), fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), 

                    if (localError != null) _buildSleekErrorBox(localError!),

                    _buildGlowButton(appLanguageGlobal == 'English' ? 'Log In' : (appLanguageGlobal == 'العربية' ? 'تسجيل الدخول' : 'چوونەژوورەوە'), () {
                      String phone = phoneController.text.trim();
                      String pass = passwordController.text.trim();
                      if (phone.isEmpty || pass.isEmpty) {
                        setModalState(() {
                          // 🔹 لۆجیکی نوێ بە پەیڕەوکردنی زمانی عەرەبی
                          localError = appLanguageGlobal == 'English' 
                              ? 'Please fill in all fields!' 
                              : (appLanguageGlobal == 'العربية' ? 'يرجى ملء جميع الحقول!' : 'تکایە سەرجەم خانەکان پڕبکەوە!');
                        });
                        return;
                      }
                      
                      phone = cleanAndFormatPhoneNumber(phone);
                      if (registeredUsersDb.containsKey(phone) && registeredUsersDb[phone] == pass) {
                        isLoggedInGlobal = true;
                        userPhoneNumberGlobal = phone;
                        userDisplayNameGlobal = registeredNamesDb[phone] ?? 'بەکارهێنەر'; 
                        isPremiumActiveGlobal = false; 
                        setModalState(() {
                          localError = null; 
                        });
                        Navigator.pop(context);
                        onStateChanged();
                      } else {
                        setModalState(() {
                          // 🔹 لۆجیکی نوێ بە پەیڕەوکردنی زمانی عەرەبی
                          localError = appLanguageGlobal == 'English' 
                              ? 'Incorrect phone number or password! Please try again.' 
                              : (appLanguageGlobal == 'العربية' 
                                  ? 'رقم الهاتف أو كلمة المرور غير صحيحة! يرجى المحاولة مرة أخرى.' 
                                  : 'ژمارەی مۆبایل یان پاسۆردەکە هەڵەیە! تکایە دووبارە تاقیبکەرەوە.');
                        });
                      }
                    }),
                    
                    const SizedBox(height: 12), 
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(appLanguageGlobal == 'English' ? 'OR' : (appLanguageGlobal == 'العربية' ? 'أو' : 'یان'), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                        ),
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 12), 

                    _buildOutlineButton(appLanguageGlobal == 'English' ? 'Create New Account' : (appLanguageGlobal == 'العربية' ? 'إنشاء حساب جديد' : 'دروستکردنی هەژماری نوێ'), () {
                      setModalState(() {
                        localError = null; 
                      });
                      Navigator.pop(context);
                      showRegisterPhoneBottomSheet(context, onStateChanged: onStateChanged);
                    }),
                    const SizedBox(height: 10), 
                  ],
                ),
              ),
            ),
          ),
        );
      }
    ),
  );
}

// ============================================================================
// فلووی تۆمارکردنی کورت بێ کێشەی سکرۆڵ
// ============================================================================
void showRegisterPhoneBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  int phoneLength = 0;
  String? localError; 
  bool isSuccessState = false; 

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;

        if (isSuccessState) {
          return Directionality(
            textDirection: textDirection,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 330), 
                height: MediaQuery.of(context).size.height * 0.92,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF131419), Color(0xFF0C0D11)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SingleChildScrollView( 
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF16181F),
                          border: Border.all(color: const Color(0xFF76C917).withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF76C917).withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded, 
                          size: 60, 
                          color: Color(0xFF76C917)
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        getTxt('reg_success_title'), // وەرگێڕانی داینامیکی لۆکاڵی جۆری زمانەکە
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        getTxt('reg_success_subtitle'), // وەرگێڕانی داینامیکی لۆکاڵی جۆری زمانەکە
                        style: const TextStyle(
                          color: Color(0xFFECC880), 
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      _buildContactCardItem('+964 773 145 4737'),
                      const SizedBox(height: 10),
                      _buildContactCardItem('+964 773 154 7371'),
                      const SizedBox(height: 28),
                      _buildOutlineButton(
                        appLanguageGlobal == 'English' ? 'Close' : (appLanguageGlobal == 'العربية' ? 'إغلاق' : 'داخستن'),
                        () {
                          Navigator.pop(context);
                          onStateChanged(); 
                        }
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter, 
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330), 
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF131419), Color(0xFF0C0D11)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                left: 24, right: 24, top: 12,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    _buildAuthHeader(
                      context, 
                      setModalState, 
                      appLanguageGlobal == 'English' ? 'Create Account' : (appLanguageGlobal == 'العربية' ? 'إنشاء حساب' : 'دروستکردنی هەژماری نوێ'), 
                      appLanguageGlobal == 'English' ? 'Welcome to Kurdistan Bourse - Iraq' : (appLanguageGlobal == 'العربية' ? 'مرحباً بك في بورصة كوردستان - العراق' : 'بەخێربێی بۆ کوردستان بۆرسە - عێراق')
                    ),

                    TextField(
                      controller: nameController,
                      textAlign: appLanguageGlobal == 'English' ? TextAlign.left : TextAlign.right,
                      style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF16181F),
                        hintText: appLanguageGlobal == 'English' ? 'Name' : (appLanguageGlobal == 'العربية' ? 'الاسم' : 'ناو'),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.person_outline_rounded, color: Colors.white.withOpacity(0.3), size: 20),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF76C917), width: 1.5)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 8), 

                    Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        Container(
                          width: 95,
                          height: 52, 
                          decoration: BoxDecoration(
                            color: const Color(0xFF16181F),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🇮🇶', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 4),
                              Text('+964', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                            onChanged: (v) {
                              setModalState(() {
                                phoneLength = v.length;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF16181F),
                              hintText: '07XXXXXXXXX',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13.5),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '$phoneLength/11',
                                  style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF76C917), width: 1.5)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), 

                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF16181F),
                        hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.shield_outlined, color: Colors.white.withOpacity(0.3), size: 20),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setModalState(() => isPasswordVisible = !isPasswordVisible);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(
                              isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                              color: Colors.white.withOpacity(0.3), 
                              size: 18
                            ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.06))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF76C917), width: 1.5)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 18), 

                    if (localError != null) _buildSleekErrorBox(localError!),

                    GestureDetector(
                      onTap: () {
                        String name = nameController.text.trim();
                        String phone = phoneController.text.trim();
                        String pass = passwordController.text.trim();
                        
                        if (name.isEmpty || phone.isEmpty || pass.isEmpty) {
                          setModalState(() {
                            // 🔹 لۆجیکی نوێ بە زمانی عەرەبی بۆ تۆمارکردن
                            localError = appLanguageGlobal == 'English' 
                                ? 'Please fill in all fields correctly.' 
                                : (appLanguageGlobal == 'العربية' 
                                    ? 'يرجى ملء جميع الحقول بشكل صحيح.' 
                                    : 'تکایە سەرجەم خانەکان بە دروستی پڕبکەوە.');
                          });
                          return;
                        }

                        String formattedPhone = cleanAndFormatPhoneNumber(phone);

                        if (formattedPhone.length != 14) {
                          setModalState(() {
                            // 🔹 لۆجیکی نوێ بە زمانی عەرەبی بۆ هەڵەی درێژی ژمارە
                            localError = appLanguageGlobal == 'English' 
                                ? 'Phone number must be 11 digits (e.g. 0750xxxxxxx)' 
                                : (appLanguageGlobal == 'العربية' 
                                    ? 'يجب أن يتكون رقم الهاتف من 11 رقماً (مثال: 0750xxxxxxx).' 
                                    : 'ژمارەی مۆبایلەکە ناتەواوە (دەبێت ١١ ژمارە بێت وەک ٠٧٥٠).');
                          });
                          return;
                        }

                        if (pass.length < 4) {
                          setModalState(() {
                            // 🔹 لۆجیکی نوێ بە زمانی عەرەبی بۆ درێژی پاسۆرد
                            localError = appLanguageGlobal == 'English' 
                                ? 'Password must be at least 4 characters.' 
                                : (appLanguageGlobal == 'العربية' 
                                    ? 'يجب أن تكون كلمة المرور 4 أحرف على الأقل.' 
                                    : 'پاسۆردەکە کورتە (دەبێت لانی کەم ٤ پیت بێت).');
                          });
                          return;
                        }

                        if (registeredUsersDb.containsKey(formattedPhone)) {
                          setModalState(() {
                            // 🔹 لۆجیکی نوێ بە زمانی عەرەبی بۆ بوونی هەمان ژمارە لە پێشتردا
                            localError = appLanguageGlobal == 'English' 
                              ? 'This number is already registered! Please log in.' 
                              : (appLanguageGlobal == 'العربية' 
                                  ? 'هذا الرقم مسجل بالفعل! يرجى تسجيل الدخول.' 
                                  : 'ئەم ژمارەیە پێشتر تۆمارکراوە! تکایە بچۆ ژوورەوە.');
                          });
                          return;
                        }

                        registeredUsersDb[formattedPhone] = pass;
                        registeredNamesDb[formattedPhone] = name;

                        isLoggedInGlobal = true;
                        userPhoneNumberGlobal = formattedPhone;
                        userDisplayNameGlobal = name;
                        isPremiumActiveGlobal = false; 

                        setModalState(() {
                          isSuccessState = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14), 
                        decoration: BoxDecoration(
                          color: const Color(0xFF76C917),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF76C917).withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            appLanguageGlobal == 'English' ? 'Create Account' : (appLanguageGlobal == 'العربية' ? 'إنشاء حساب' : 'دروستکردنی هەژماری نوێ'),
                            style: const TextStyle(color: Color(0xFF0F1015), fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), 

                    Container(
                      padding: const EdgeInsets.all(14), 
                      decoration: BoxDecoration(
                        color: const Color(0xFF13151B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            appLanguageGlobal == 'English'
                                ? 'After creating your account, contact us via WhatsApp or Viber to activate your account.'
                                : (appLanguageGlobal == 'العربية'
                                    ? 'بعد إنشاء حسابك، تواصل معنا عبر واتساب أو فايبر لتفعيل حسابك.'
                                    : 'پاش دروستکردنی هەژمارەکەت پەیوەندیمان پێوە بکە لە واتساپ یان ڤایبەر تا هەژمارەکەت چالاک بکریت'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.5, height: 1.5, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          _buildContactCardItem('+964 773 145 4737'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), 
                  ],
                ),
              ),
            ),
          ),
        );
      }
    ),
  );
}

Widget _buildContactCardItem(String number) {
  final String cleanNumber = '\u200E$number'; 
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
    decoration: BoxDecoration(
      color: const Color(0xFF16181F),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.04)),
    ),
    child: Row(
      textDirection: TextDirection.ltr,
      children: [
        GestureDetector(
          onTap: () async {
            final cleanNumberForWa = number.replaceAll(' ', '').replaceAll('+', '');
            final message = Uri.encodeComponent(
              appLanguageGlobal == 'English'
                  ? "Hello, please renew my account."
                  : (appLanguageGlobal == 'العربية'
                      ? "مرحباً، يرجى تجديد حسابي من فضلك."
                      : "تکایە ئەژمارەکەم بۆ نوێ بکەنەوە ..."),
            );
            final Uri url = Uri.parse('https://wa.me/$cleanNumberForWa?text=$message');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5), 
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3)),
            ),
            child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 13), 
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final cleanNumberForTel = number.replaceAll(' ', '');
            final Uri url = Uri.parse('tel:$cleanNumberForTel');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF0072FF).withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0072FF).withOpacity(0.3)),
            ),
            child: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF4FC3F7), size: 13),
          ),
        ),
        const Spacer(),
        Text(
          cleanNumber, 
          textDirection: TextDirection.ltr, 
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13, 
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ],
    ),
  );
}

void showRegisterOtpBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController otpController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330),
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    _buildAuthHeader(
                      context, 
                      setModalState, 
                      getTxt('otp_title'), 
                      '${getTxt('otp_desc')} ($phoneNumber)'
                    ),
                    _buildAuthTextField(
                      controller: otpController,
                      hintText: getTxt('otp_hint'),
                      prefixIcon: Icons.message_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 40),
                    _buildGlowButton(getTxt('submit_btn'), () {
                      if (otpController.text.trim() == '1234') {
                        Navigator.pop(context);
                        showRegisterPasswordBottomSheet(context, phoneNumber, onStateChanged: onStateChanged);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Code incorrect!' : 'کۆدەکە هەڵەیە!'), backgroundColor: Colors.redAccent));
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    ),
  );
}

void showRegisterPasswordBottomSheet(BuildContext context, String phoneNumber, {required VoidCallback onStateChanged}) {
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330),
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 28, right: 28, top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAuthHeader(
                      context, 
                      setModalState, 
                      getTxt('set_password_title'), 
                      getTxt('password_length_hint')
                    ),
                    _buildAuthTextField(
                      controller: passwordController,
                      hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'),
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      isVisible: isPasswordVisible,
                      onVisibilityToggle: () {
                        setModalState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildGlowButton(getTxt('submit_btn'), () {
                      String pass = passwordController.text.trim();
                      if (pass.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'At least 4 characters!' : 'پاسۆرد نابێت لە ٤ پیت کەمتر بێت'), backgroundColor: Colors.redAccent));
                        return;
                      }
                      registeredUsersDb[phoneNumber] = pass;
                      isLoggedInGlobal = true;
                      userPhoneNumberGlobal = phoneNumber;
                      isPremiumActiveGlobal = true; 
                      Navigator.pop(context);
                      onStateChanged();
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    ),
  );
}

void showForgotPasswordPhoneBottomSheet(BuildContext context, {required VoidCallback onStateChanged}) {
  final TextEditingController phoneController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330),
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _buildAuthHeader(
                    context, 
                    setModalState, 
                    appLanguageGlobal == 'English' ? 'Reset Password' : (appLanguageGlobal == 'العربية' ? 'استعادة كلمة السر' : 'گۆڕینی پاسۆرد'), 
                    getTxt('forgot_pass_phone_desc')
                  ),
                  _buildAuthTextField(
                    controller: phoneController,
                    hintText: appLanguageGlobal == 'English' ? 'Phone Number' : (appLanguageGlobal == 'العربية' ? 'رقم الهاتف' : 'ژماری مۆبایل'),
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 40),
                  _buildGlowButton(getTxt('submit_btn'), () {
                    String phone = phoneController.text.trim();
                    if (phone.isEmpty) return;
                    phone = cleanAndFormatPhoneNumber(phone);
                    if (!registeredUsersDb.containsKey(phone)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Account not found!' : 'ئەم ژمارەیە پێشتر تۆمار نەکراوە!'), backgroundColor: Colors.redAccent));
                      return;
                    }
                    Navigator.pop(context);
                    showForgotPasswordOtpBottomSheet(context, phone, onStateChanged: onStateChanged);
                  }),
                ]),
              ),
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
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330),
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 28, right: 28, top: 20),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _buildAuthHeader(
                    context, 
                    setModalState, 
                    getTxt('otp_title'), 
                    '${getTxt('otp_desc')} ($phoneNumber)'
                  ),
                  _buildAuthTextField(
                    controller: otpController,
                    hintText: getTxt('otp_hint'),
                    prefixIcon: Icons.message_outlined,
                    keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 40),
                  _buildGlowButton(getTxt('submit_btn'), () {
                    if (otpController.text.trim() == '1234') {
                      Navigator.pop(context);
                      showForgotPasswordNewPasswordBottomSheet(context, phoneNumber, onStateChanged: onStateChanged);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'Code incorrect!' : 'کۆدەکە هەڵەیە!'), backgroundColor: Colors.redAccent));
                    }
                  }),
                ]),
              ),
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
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final textDirection = appLanguageGlobal == 'English' ? TextDirection.ltr : TextDirection.rtl;
        return Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 330),
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF131834), Color(0xFF0B0E1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), 
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 28, right: 28, top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAuthHeader(
                      context, 
                      setModalState, 
                      appLanguageGlobal == 'English' ? 'Enter New Password' : (appLanguageGlobal == 'العربية' ? 'أدخل كلمة السر الجديدة' : 'پاسۆردی نوێ بنووسە'), 
                      getTxt('password_length_hint')
                    ),
                    _buildAuthTextField(
                      controller: passwordController,
                      hintText: appLanguageGlobal == 'English' ? 'Password' : (appLanguageGlobal == 'العربية' ? 'كلمة السر' : 'ووشەی نهێنی'),
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      isVisible: isPasswordVisible,
                      onVisibilityToggle: () {
                        setModalState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildGlowButton(getTxt('submit_btn'), () {
                      String newPass = passwordController.text.trim();
                      if (newPass.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLanguageGlobal == 'English' ? 'At least 4 characters!' : 'پاسۆرد نابێت لە ٤ پیت کەمتر بێت'), backgroundColor: Colors.redAccent));
                        return;
                      }
                      registeredUsersDb[phoneNumber] = newPass;
                      Navigator.pop(context);
                      onStateChanged();
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    ),
  );
}