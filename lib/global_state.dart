// lib/global_state.dart

// --- barudoxi cihani taqikrdnawa (Global Mock State) ---
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

String selectedBaseRateSourceGlobal = 'Central Bank'; 

double usdToIqdMarketRate = 1537.0;       
double usdToIqdCentralBankRate = 1320.0;  
double usdToIqdBaghdadRate = 1539.5;       
double usdToIqdSulaymaniyahRate = 1538.0;   
double usdToIqdErbilRate = 1537.5;          

double get activeBaseUsdToIqdRate {
  switch (selectedBaseRateSourceGlobal) {
    case 'Central Bank':
      return usdToIqdCentralBankRate;
    case 'Baghdad Bourse':
      return usdToIqdBaghdadRate;
    case 'Sulaymaniyah Bourse':
      return usdToIqdSulaymaniyahRate;
    case 'Erbil Bourse':
      return usdToIqdErbilRate;
    default:
      return usdToIqdCentralBankRate;
  }
}

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

Map<String, String> registeredUsersDb = {
  '+9647701234567': '1234'
};

Map<String, String> registeredNamesDb = {
  '+9647701234567': 'سەروان'
};

final Map<String, Map<String, String>> translations = {
  'کوردی': {
    'cities_tab': 'بۆرسەی شارەکان',
    'currencies_tab': 'دراوەکان',
    'calculator_tab': 'حاسیبە',
    'offices_tab': 'نوسینگەکان',
    'analysis_tab': 'شیکارییەکان',
    'analysis_title': 'شیکارییەکان', 
    'videos_tab': 'شیکاریی ڤیدیۆیی',
    'articles_tab': 'شیکاریی نووسراو',
    'no_content': 'هیچ ناوەڕۆکێک بەردەست نییە لە ئێستادا.',
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
    'test_panel': 'کۆنتڕۆڵی تاقیکردنیەوە (بۆ گەشەپێدەر)',
    'trial_active': 'باری تاقیکاری چالاکە (بەشەکان کراوەن)',
    'trial_inactive': 'باری تاقیکاری ناچالاکە (بۆرسە قوفڵە)',
    'locked_msg': 'قفڵ کراوە',
    'locked_title': 'هەژمارەکەت بەسەرچوو',
    // ✅ دەقە نوێی و فەرمییە داواکراوەکەت لێرەدا بە تەواوی گۆڕدراوە
    'locked_desc': 'ماوەی بەکارهێنانی ئەژمارەکەت بەسەرچوو. بۆ نوێکردنەوە دەست بنێ بە ئایکۆنی ناردنی نامەدا لەخوارەوە یان لەڕێگای ئەو ژمارە مۆبایلەوە پەیوەندیمان پێوە بکە.',
    // ✅ دەقە نوێی و فەرمییە داواکراوەکەت لێرەدا بە تەواوی گۆڕدراوە
    'locked_note': 'تێبینی: گەر ئەژمارت دروست نەکردووە ئەوە لەخوارەوە ئەژمارێک دروست بکە و دواتر پەیوەندیمان پێوە بکە.',
    'refresh_btn': 'هەڵسەنگاندنەوە',
    'lock_create_account_btn': 'دروستکردنی ئەژمار',
    'unlock_btn': 'چوونە دەرەوە و چالاککردنی ئەکاونت',
    'buy': 'کڕین',
    'sell': 'فرۆشتن',
    'app_subtitle': 'بۆرسەی عێراق - کوردستان',
    'currencies_title': 'نرخی دراوەکان',
    'vs_100_dollars': 'بەرامبەر ١٠٠ دۆلار',
    'live': 'زیندوو',
    'IQD_name': 'دینار عێراقی',
    'IRR_name': 'تمەنی ئێرانی',
    'GBP_name': 'پاوەندی بەریتانی',
    'EUR_name': 'یۆرۆی ئەورووپی',
    'TRY_name': 'لیرەی تورکی',
    'AED_name': 'درامی ئیماراتی',
    'IQD_unit': 'د.ع',
    'IRR_unit': 'تمەن',
    'GBP_unit': 'پاوەند',
    'EUR_unit': 'یۆرۆ',
    'TRY_unit': 'لیرە',
    'AED_unit': 'درام',
    'heuler': 'هەولێر',
    'slemani': 'سلێمانی',
    'baghdad_kifah': 'بەغداد (کِفاح)',
    'baghdad': 'بەغداد',
    'karrada': 'کەڕادە',
    'harishia': 'حاریشیە',
    'kerkuk': 'کەرکوک',
    'dhok': 'دهۆک',
    'najaf': 'نەجەف',
    'basra': 'بەسرە',
    'amount_label': 'بڕی پارە',
    'buy_price_label': 'نرخی کڕین',
    'sell_price_label': 'نرخی فرۆشتن',
    'commission_label': 'کەمیسیۆن ٪',
    'calculate_btn': 'حیساب بکە',
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
    'news_ticker': 'هەواڵ: نرخەکان نوێکرانەوە.',
    'header_time': 'شەممە • ١٢:٠٠ پ.ن',
    'rate_source_central': 'ناوەندی', 
    'rate_source_slemani': 'سلێمانی', 
    'rate_source_baghdad': 'بەغداد', 
    'rate_source_erbil': 'هەولێر', 
    'strip_rising': 'بەرزبووە', 
    'strip_falling': 'کەمبووە', 
    'strip_updated': 'نوێکراوە', 
    'quick_convert_title': 'گۆڕینەوەی خێرا',
    'calc_auto_rate': 'نرخی ئۆتۆماتیک', 
    'calc_manual_rate': 'دەستی', 
    'calc_base_currency': 'دراوی بنەڕەت', 
    'office_working_hours_header': 'کاتی کارکردنی نووسینگە', 
    'office_live_status': 'باری ئێستا:',
    'office_address_services_header': 'ناونیشان و خزمەتگوزارییەکان',
    'office_staff_header': 'ناو و ژمارەی کارمەندانی نووسینگە',
    'office_staff_prefix': 'کارمەند: ',
    'حەواڵ': 'حەواڵ', 
    'کڕین و فرۆشتن': 'کڕین و فرۆشتن',
    'گۆڕینەوەی خێرا': 'گۆڕینەوەی خێرا',
    'reg_success_title': 'پیرۆزە کارەکە سەرکەوتووبوو.', 
    'reg_success_subtitle': 'بۆ تەواوکردنی کارەکەت ئێستا پەیوەندیمان پێوەبکە:', 
    'app_version_label': 'وەشانی',
    'office_1': 'نووسینگەی ڕاستگۆ', 
    'office_2': 'کۆمپانیای بازاڕی ناوەندی', 
  },
  'العربية': {
    'cities_tab': 'بورصة المدن',
    'currencies_tab': 'العملات',
    'calculator_tab': 'الحاسبة',
    'offices_tab': 'المكاتب',
    'analysis_tab': 'التحليلات',
    'analysis_title': 'التحليلات', 
    'videos_tab': 'التحليل المرئي',
    'articles_tab': 'التحليل المكتوب',
    'no_content': 'لا يوجد محتوى متاح حالياً.',
    'settings_title': 'الإعدادات',
    'choose_lang': 'تغيير اللغة',
    'font_size': 'تغيير حجم الخط',
    'numeral_style': 'شكل الأرقام', 
    'numeral_western': 'إنجليزي (123)', 
    'numeral_eastern': 'عربي/كردي (١٢٣)', 
    'notifications': 'الإشعارات',
    'share_section': 'مشاركة التطبيق',
    'contact_section': 'التواصل والدعم',
    'account_section': 'إعدادات الحساب',
    'expired_status': 'منتهي الصلاحية',
    'active_status': 'نشط',
    'start_date': 'تاريخ البدء',
    'end_date': 'تاريخ الانتهاء',
    'logout': 'تسجيل الخروج',
    'login_btn': 'تسجيل الدخول أو إنشاء حساب',
    'test_panel': 'لوحة التحكم بالتجربة (للمطور)',
    'trial_active': 'الفترة التجريبية نشطة (الأقسام مفتوحة)',
    'trial_inactive': 'الفترة التجريبية منتهية (البورصة مغلقة)',
    'locked_msg': 'مغلق حالياً',
    'locked_title': 'انتهت صلاحية الحساب',
    'locked_desc': 'لقد انتهت فترة استخدام حسابك. للتجديد, فقط اضغط على أيقونة الواتساب أدناه لإرسال رسالة تجديد تلقائية إلينا.',
    'locked_note': 'ملاحظة: إذا لم يكن لديك حساب، قم بإنشاء حساب أدناه ثم تواصل معنا.',
    'refresh_btn': 'إعادة المحاولة',
    'lock_create_account_btn': 'إنشاء حساب',
    'unlock_btn': 'تسجيل الدخول وتفعيل الحساب',
    'buy': 'طلب',
    'sell': 'عرض',
    'app_subtitle': 'البورصة العراقية - كوردستان', 
    'currencies_title': 'أسعار العملات',
    'live': 'مباشر',
    'vs_100_dollars': 'مقابل ١٠٠ دولار',
    'IQD_name': 'دينار عراقي',
    'IRR_name': 'تومان إيراني',
    'GBP_name': 'جنيه إسترليني',
    'EUR_name': 'يورو أوروبي',
    'TRY_name': 'ليرة تركية',
    'AED_name': 'درهم إماراتي',
    'IQD_unit': 'د.ع',
    'IRR_unit': 'تومان',
    'GBP_unit': 'جنيه',
    'EUR_unit': 'يورو',
    'TRY_unit': 'ليرة',
    'AED_unit': 'درهم',
    'heuler': 'أربيل',
    'slemani': 'السليمانية',
    'baghdad_kifah': 'بغداد (الكفاح)',
    'baghdad': 'بغداد',
    'karrada': 'الكرادة',
    'harishia': 'الحارثية',
    'kerkuk': 'كركوك',
    'dhok': 'دهوك',
    'najaf': 'النجف',
    'basra': 'البصرة',
    'amount_label': 'قيمة المبلغ',
    'buy_price_label': 'سعر الطلب',
    'sell_price_label': 'سعر العرض',
    'commission_label': 'العمولة ٪',
    'calculate_btn': 'احسب',
    'exchange_tab': 'التحويل',
    'profit_tab': 'الربح / الخسارة',
    'profit_won': 'ربحت! 🎉',
    'profit_lost': 'خسرت 📉',
    'profit_iqd_label': 'الربح/الخسارة بالدينار',
    'profit_curr_label': 'الربح/الخسارة بـ',
    'profit_percent_label': 'نسبة الربح/الخسارة',
    'commission_iqd': 'العمولة',
    'total_sell': 'إجمالي البيع',
    'calculator_desc': 'املأ الخانات واحسب',
    'current_rates': 'الأسعار الحالية',
    'search_hint': 'البحث باسم المكتب...',
    'all_cities': 'الكل',
    'offices_found': 'مكتب تم العثور عليه',
    'no_office': 'لم يتم العثور على أي مكتب',
    'rating': 'التقييم',
    'review_count': 'تعليق',
    'working_hours': 'أوقات العمل',
    'open_status': 'مفتوح',
    'closed_status': 'مغلق',
    'address_label': 'العنوان',
    'phone_label': 'رقم الهاتف',
    'services_label': 'الخدمات',
    'reviews_label': 'آراء العملاء',
    'call_btn': 'اتصل بنا',
    'subscribe_btn': 'الاشتراك في التطبيق',
    'login_title': 'تسجيل الدخول إلى الحساب 🔑',
    'phone_hint': 'رقم الهاتف (مثال: 07701234567)',
    'password_hint': 'كلمة السر',
    'forgot_password': 'هل نسيت كلمة السر؟',
    'login_action': 'تسجيل الدخول',
    'register_action': 'إنشاء حساب جديد',
    'register_title': 'إنشاء حساب جديد 👤',
    'otp_title': 'أدخل رمز التأكيد 💬',
    'otp_desc': 'رمز التأكيد للتجربة: 1234',
    'otp_hint': 'أدخل الرمز المكون من ٤ أرقام',
    'set_password_title': 'أدخل كلمة سر قوية 🔒',
    'password_length_hint': 'على الأقل ٤ رموز',
    'submit_btn': 'تأكيد',
    'forgot_pass_phone_desc': 'يرجى إدخال رقم هاتفك لإرسال رمز التأكيد',
    'news_ticker': 'الأخبار: تم تحديث الأسعار.',
    'header_time': 'السبت • ١٢:٠٠ ص',
    'rate_source_central': 'المركزي', 
    'rate_source_slemani': 'السليمانية', 
    'rate_source_baghdad': 'بغداد', 
    'rate_source_erbil': 'أربيل', 
    'strip_rising': 'ارتفع', 
    'strip_falling': 'انخفض', 
    'strip_updated': 'محدث', 
    'quick_convert_title': 'تحويل سريع', 
    'calc_auto_rate': 'سعر تلقائي', 
    'calc_manual_rate': 'يدوي', 
    'calc_base_currency': 'العملة الأساسية', 
    'office_working_hours_header': 'أوقات عمل المكتب', 
    'office_live_status': 'الحالة المباشرة:',
    'office_address_services_header': 'العنوان والخدمات',
    'office_staff_header': 'أسماء وأرقام هواتف موظفي المكتب',
    'office_staff_prefix': 'الموظف: ',
    'حەواڵ': 'حوالات', 
    'کڕین و فرۆشتن': 'بيع وشراء',
    'گۆڕینەوەی خێرا': 'تبديل سريع',
    'reg_success_title': 'تمت العملية بنجاح! مبروك.', 
    'reg_success_subtitle': 'لإكمال عمليتك اتصل بنا الآن:', 
    'app_version_label': 'الإصدار',
    'نوسینگەی ڕاستگۆ': 'مكتب راستكو للصيرفة', 
    'کۆمپانیای بازاڕی ناوەندی': 'مكتب السوق المركزي', 
  },
  'English': {
    'cities_tab': 'Cities Bourse',
    'currencies_tab': 'Currencies',
    'calculator_tab': 'Calculator',
    'offices_tab': 'Offices',
    'analysis_tab': 'Analyses', 
    'analysis_title': 'Analyses', 
    'videos_tab': 'Video Analysis',
    'articles_tab': 'Written Analysis',
    'no_content': 'No content available at the moment.',
    'settings_title': 'Settings',
    'choose_lang': 'Change Language',
    'font_size': 'Change Font Size',
    'numeral_style': 'Numeral Style', 
    'numeral_western': 'English (123)', 
    'numeral_eastern': 'Kurdish/Arabic (١٢٣)', 
    'notifications': 'Notifications',
    'share_section': 'Share Application',
    'contact_section': 'Contact & Support',
    'account_section': 'Account Settings',
    'expired_status': 'Expired',
    'active_status': 'Active',
    'start_date': 'Start Date',
    'end_date': 'End Date',
    'logout': 'Logout',
    'login_btn': 'Login or Create Account',
    'test_panel': 'Test Panel (For Developer)',
    'trial_active': 'Free Trial Active (Sections Unlocked)',
    'trial_inactive': 'Free Trial Expired (Bourse Locked)',
    'locked_msg': 'Locked',
    'locked_title': 'Account Expired',
    'locked_desc': 'Your account usage period has expired. To renew, simply tap the WhatsApp icon below to send us an automatic account renewal message.',
    'locked_note': 'Note: If you do not have an account, create one below and then contact us.',
    'refresh_btn': 'Refresh',
    'lock_create_account_btn': 'Create Account',
    'unlock_btn': 'Login & Activate Account',
    'buy': 'Buy',
    'sell': 'Sell',
    'app_subtitle': 'Iraq - Kurdistan Bourse', 
    'currencies_title': 'Currency Rates',
    'live': 'Live',
    'vs_100_dollars': 'vs 100 Dollars',
    'IQD_name': 'Iraqi Dinar',
    'IRR_name': 'Iranian Toman',
    'GBP_name': 'British Pound',
    'EUR_name': 'Euro',
    'TRY_name': 'Turkish Lira',
    'AED_name': 'UAE Dirham',
    'IQD_unit': 'IQD',
    'IRR_unit': 'Toman',
    'GBP_unit': 'Pound',
    'EUR_unit': 'Euro',
    'TRY_unit': 'Lira',
    'AED_unit': 'Dirham',
    'heuler': 'Erbil',
    'slemani': 'Sulaymaniyah',
    'baghdad_kifah': 'Baghdad (Kifah)',
    'baghdad': 'Baghdad',
    'karrada': 'Karrada',
    'harishia': 'Harithiya',
    'kerkuk': 'Kirkuk',
    'dhok': 'Duhok',
    'najaf': 'Najaf',
    'basra': 'Basra',
    'amount_label': 'Amount',
    'buy_price_label': 'Buy Price',
    'sell_price_label': 'Sell Price',
    'commission_label': 'Commission %',
    'calculate_btn': 'Calculate',
    'exchange_tab': 'Exchange',
    'profit_tab': 'Profit / Loss',
    'profit_won': 'Profit Made! 🎉',
    'profit_lost': 'Loss Made! 📉',
    'profit_iqd_label': 'Profit/Loss in IQD',
    'profit_curr_label': 'Profit/Loss in',
    'profit_percent_label': 'Profit/Loss %',
    'commission_iqd': 'Commission',
    'total_sell': 'Total Sell',
    'calculator_desc': 'Fill fields and calculate',
    'current_rates': 'Current Rates',
    'search_hint': 'Search by office name...',
    'all_cities': 'All',
    'offices_found': 'offices found',
    'no_office': 'No offices found',
    'rating': 'Rating',
    'review_count': 'reviews',
    'working_hours': 'Working Hours',
    'open_status': 'Open',
    'closed_status': 'Closed',
    'address_label': 'Address',
    'phone_label': 'Phone Number',
    'services_label': 'Services',
    'reviews_label': 'Customer Reviews',
    'call_btn': 'Call Us',
    'subscribe_btn': 'Subscribe to App',
    'login_title': 'Login to Account 🔑',
    'phone_hint': 'Phone (e.g. 07701234567)',
    'password_hint': 'Password',
    'forgot_password': 'Forgot Password?',
    'login_action': 'Login',
    'register_action': 'Register New Account',
    'register_title': 'Create New Account 👤',
    'otp_title': 'Enter Verification Code 💬',
    'otp_desc': 'Test Code: 1234',
    'otp_hint': 'Enter 4-digit code',
    'set_password_title': 'Set Strong Password 🔒',
    'password_length_hint': 'At least 4 characters',
    'submit_btn': 'Submit',
    'forgot_pass_phone_desc': 'Please enter your phone number to receive a verification code',
    'news_ticker': 'News: Rates updated.', 
    'header_time': 'Saturday • 12:00 AM', 
    'rate_source_central': 'Central', 
    'rate_source_slemani': 'Slemani', 
    'rate_source_baghdad': 'Baghdad', 
    'rate_source_erbil': 'Erbil', 
    'strip_rising': 'Rising', 
    'strip_falling': 'Falling', 
    'strip_updated': 'Updated', 
    'quick_convert_title': 'Quick Convert',
    'calc_auto_rate': 'Auto Rate', 
    'calc_manual_rate': 'Manual', 
    'calc_base_currency': 'Base Currency', 
    'office_working_hours_header': 'Office Working Hours', 
    'office_live_status': 'Live Status:',
    'office_address_services_header': 'Address & Services',
    'office_staff_header': 'Office Staff Contacts',
    'office_staff_prefix': 'Staff: ',
    'حەواڵ': 'Money Transfer', 
    'کڕین و فرۆشتن': 'Buy & Sell',
    'گۆڕینەوەی خێرا': 'Quick Exchange',
    'reg_success_title': 'Registration Successful! Congratulations.', 
    'reg_success_subtitle': 'To complete your process, contact us now:', 
    'app_version_label': 'Version',
    'office_1': 'Rastgo Exchange Office', 
    'office_2': 'Central Market Company', 
  }
};

String getTxt(String key) => translations[appLanguageGlobal]?[key] ?? key;

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