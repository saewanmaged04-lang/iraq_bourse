// lib/global_state.dart

import 'package:flutter/material.dart';

// --- barudoxi cihani taqikrdnawa (Global State) ---
bool isLoggedInGlobal = false;
bool isGuestGlobal = false;
String userPhoneNumberGlobal = '';
String userDisplayNameGlobal = ''; 
String activationDateGlobal = '١٨ / ٦ / ٢٠٢٦'; 
String expiryDateGlobal = '١٨ / ٨ / ٢٠٢٦';     
bool isPremiumActiveGlobal = false; 
bool isGlobalFreeTrialActive = true; 
double fontScaleMultiplierGlobal = 1.0; 
String appLanguageGlobal = 'کوردی';
String appNumeralStyleGlobal = '١٢٣';

// باری ئۆتۆماتیکی حاسیبە و سەرچاوەی نرخەکە
bool isAutoRateGlobal = true; 
String selectedBaseRateSourceGlobal = 'Sulaymaniyah Bourse'; 

// نرخەکانی دۆلار
double usdToIqdCentralBankRate = 1320.0;  
double usdToIqdMarketRate = 1537.0;       

// گێتەری هۆشمەند بۆ وەرگێڕانی نرخەکان لە حاسیبەدا (ئەمە لە مێین ناڤیگەیشن پڕ دەکرێتەوە)
double activeBaseUsdToIqdRate = 1538.0;

// فەرمانی داینامیکی بۆ کۆنتڕۆڵکردنی قوفڵی بەشەکان
bool get isCitiesLockedGlobal {
  if (isGlobalFreeTrialActive) return false;
  if (isLoggedInGlobal && isPremiumActiveGlobal) return false;
  return true;
}

bool get isCurrenciesLockedGlobal {
  if (isGlobalFreeTrialActive) return false;
  if (isLoggedInGlobal && isPremiumActiveGlobal) return false;
  return true;
}

// --- بنکەی دراوەی کاتی ---
Map<String, String> registeredUsersDb = {'+9647701234567': '1234'};
Map<String, String> registeredNamesDb = {'+9647701234567': 'سەروان'};

// --- فەرهەنگی وەرگێڕانی گشتگیر و فەرمی (تەواوی فایلەکە) ---
final Map<String, Map<String, String>> translations = {
  'کوردی': {
    'cities_tab': 'بۆرسەی شارەکان',
    'currencies_tab': 'دراوەکان',
    'calculator_tab': 'حاسیبە',
    'offices_tab': 'نوسینگەکان',
    'settings_title': 'ڕێکخستنەکان',
    'choose_lang': 'هەڵبژاردنی زمان',
    'font_size': 'قەبارەی نووسین (فۆنت)',
    'numeral_style': 'شێوازی ژمارەکان', 
    'numeral_western': 'ئینگلیزی (123)', 
    'numeral_eastern': 'کوردی (١٢٣)',   
    'notifications': 'ئاگادارکردنەوەکان',
    'share_section': 'مشاركة (هاوبەشکردن)',
    'contact_section': 'التواصل (پەیوەندی و پشتگیری)',
    'account_section': 'الحساب (ڕێکخستنی هەژمار)',
    'expired_status': 'بەسەرچووە',
    'active_status': 'چالاکە',
    'start_date': 'بەرواری دەستپێکردن',
    'end_date': 'بەرواری کۆتایی هاتن',
    'logout': 'چوونە دەرەوە',
    'login_btn': 'چوونەژوورەوە یان دروستکردنی ئەژمار',
    'test_panel': 'کۆنتڕۆڵی تاقیکردنەوە (بۆ گەشەپێدەر)',
    'trial_active': 'باری تاقیکاری چالاکە (بەشەکان کراوەن)',
    'trial_inactive': 'باری تاقیکاری ناچالاکە (بۆرسە قوفڵە)',
    'locked_msg': 'قفڵ کراوە',
    'locked_title': 'هەژمارەکەت بەسەرچوو',
    'locked_desc': 'ماوەی بەکارهێنانی ئەژمارەکەت بەسەر چوو تکاییە ئەگەر ئەژمارت دروست کردووە پەیوەندیمان پێوە بکە بۆ نوێکردنەوە.',
    'refresh_btn': 'هەڵسەنگاندنەوە',
    'lock_create_account_btn': 'دروستکردنی ئەژمار',
    'unlock_btn': 'چوونەژوورەوە و چالاککردنی ئەکاونت',
    'buy': 'کڕین',
    'sell': 'فرۆشتن',
    'app_subtitle': 'بۆرسەی عێراق',
    'currencies_title': 'نرخی دراوەکان',
    'vs_100_dollars': 'بەرامبەر ١٠٠ دۆلار',
    'live': 'زیندوو',
    'auto_text': 'ئەوتۆ',
    'central_bank': 'بانکی ناوەندی',
    'slemani': 'سلێمانی',
    'baghdad': 'بەغداد',
    'exchange_tab': 'ئاڵوگۆڕ',
    'profit_tab': 'قازانج / زیان',
    'profit_won': 'قازانج کردووە! 🎉',
    'profit_lost': 'زیان کردووە 📉',
    'profit_iqd_label': 'قازانج/زیان بە دینار',
    'profit_curr_label': 'قازانج/زیان بە',
    'profit_percent_label': 'ڕێژەی قازانج/زیان',
    'commission_iqd': 'کەمیسیۆن',
    'total_sell': 'کۆی فرۆشتن',
    'calculator_desc': 'خانەکان پڕ بکەوە و حیساب بکە',
    'current_rates': 'نرخەکانی ئێستا',
    'search_hint': 'گەڕان بەناوی نوسینگە...',
    'all_cities': 'هەمووی',
    'offices_found': 'نوسینگە دۆزرایەوە',
    'no_office': 'هیچ نوسینگەیەک نەدۆزرایەوە',
    'rating': 'هەڵسەنگاندن',
    'review_count': 'کۆمێنت',
    'working_hours': 'کاتی ئیش',
    'open_status': 'کراوەیە',
    'closed_status': 'داخراوە',
    'address_label': 'ناونیشان',
    'phone_label': 'ژمارەی تەلەفۆن',
    'services_label': 'خزمەتگوزاریەکان',
    'reviews_label': 'کۆمێنتی کڕیارەکان',
    'call_btn': 'پەیوەندی بکە',
    'subscribe_btn': 'بەشداربوون لەم ئەپەدا',
    'login_title': 'چوونەژوورەوە بۆ هەژمار 🔑',
    'phone_hint': 'ژمارەی مۆبایل (نموونە: 07701234567)',
    'password_hint': 'پاسۆرد',
    'forgot_password': 'پاسۆردت بیرچووە؟',
    'login_action': 'چوونەژوورەوە',
    'register_action': 'تۆمارکۆدنی هەژماری نوێ',
    'register_title': 'دروستکردنی ئەژمار نوێ 👤',
    'otp_title': 'کۆدی دڵنیاکەرەوە دابنێ 💬',
    'otp_desc': 'کۆدی نێردراو بۆ تاقیکردنەوە: 1234',
    'otp_hint': 'کۆدی چوار خانەیی بنووسە',
    'set_password_title': 'پاسۆردی بهێز بنووسە 🔒',
    'password_length_hint': 'لانی کەم ٤ پیت',
    'submit_btn': 'پاشکۆ',
    'forgot_pass_phone_desc': 'تکایە ژمارەی مۆبایلەکەت بنووسە بۆ ناردنی کۆدی دڵنیاکەرەوە',
  },
  'العربية': {
    'cities_tab': 'بورصة المدن',
    'currencies_tab': 'العملات',
    'calculator_tab': 'الحاسبة',
    'offices_tab': 'المكاتب',
    'settings_title': 'الإعدادات',
    'auto_text': 'تلقائي',
    'central_bank': 'البنك المركزي',
    'slemani': 'السليمانية',
    'baghdad': 'بغداد',
  },
  'English': {
    'cities_tab': 'Cities Bourse',
    'currencies_tab': 'Currencies',
    'calculator_tab': 'Calculator',
    'offices_tab': 'Offices',
    'settings_title': 'Settings',
    'auto_text': 'Auto',
    'central_bank': 'Central Bank',
    'slemani': 'Slemani',
    'baghdad': 'Baghdad',
  }
};

String getTxt(String key) {
  return translations[appLanguageGlobal]?[key] ?? key;
}

String getCityName(String input) {
  if (input.contains('هەمووی')) return getTxt('all_cities');
  if (appLanguageGlobal == 'English') {
    if (input.contains('سلێمانی')) return 'Sulaymaniyah';
    if (input.contains('هەولێر')) return 'Erbil';
    if (input.contains('بەغداد')) return 'Baghdad';
    if (input.contains('کەرکوک')) return 'Kirkuk';
    if (input.contains('دهۆک')) return 'Duhok';
    if (input.contains('نەجەف')) return 'Najaf';
    if (input.contains('بەسرە')) return 'Basra';
    if (input.contains('بەغداد (کِفاح)')) return 'Baghdad (Al-Kifah)';
    if (input.contains('کەڕادە')) return 'Karrada';
    if (input.contains('حاریشیە')) return 'Harithiya';
  } else if (appLanguageGlobal == 'العربية') {
    if (input.contains('سلێمانی')) return 'السليمانية';
    if (input.contains('هەولێر')) return 'أربيل';
    if (input.contains('بەغداد')) return 'بغداد';
    if (input.contains('کەرکوک')) return 'كركوك';
    if (input.contains('دهۆک')) return 'دهوك';
    if (input.contains('نەجەف')) return 'النجف';
    if (input.contains('بەسرە')) return 'البصرة';
    if (input.contains('بەغداد (کِفاح)')) return 'بغداد (الكفاح)';
    if (input.contains('کەڕادە')) return 'الكرادة';
    if (input.contains('حاریشیە')) return 'الحارثية';
  }
  return input;
}

String getCurrencyDisplayName(String rawName) {
  if (rawName.contains('دۆلار USD')) {
    return appLanguageGlobal == 'English' ? 'USD Dollar' : (appLanguageGlobal == 'العربية' ? 'دولار USD' : 'دۆلار USD');
  }
  if (rawName.contains('دینار IQD')) {
    return appLanguageGlobal == 'English' ? 'IQD Dinar' : (appLanguageGlobal == 'العربية' ? 'دينار IQD' : 'دینار IQD');
  }
  if (rawName.contains('تمەن IRR')) {
    return appLanguageGlobal == 'English' ? 'IRR Toman' : (appLanguageGlobal == 'العربية' ? 'تومان IRR' : 'تمەن IRR');
  }
  if (rawName.contains('یۆرۆ EUR')) {
    return appLanguageGlobal == 'English' ? 'EUR Euro' : (appLanguageGlobal == 'العربية' ? 'يورو EUR' : 'یۆرۆ EUR');
  }
  if (rawName.contains('پاوەند GBP')) {
    return appLanguageGlobal == 'English' ? 'GBP Pound' : (appLanguageGlobal == 'العربية' ? 'جنيه GBP' : 'پاوەند GBP');
  }
  return rawName;
}

String formatDisplayNumbers(String input) {
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  String result = input;
  
  if (appNumeralStyleGlobal == '123') { 
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(eastern[i], western[i]);
    }
  } else { 
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
  }
  return result;
}