// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سوبر فيتنس';

  @override
  String get emptyValidationError => 'هذا الحقل مطلوب';

  @override
  String get invalidEmailError => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidPhoneError => 'يرجى إدخال رقم هاتف مصري صحيح';

  @override
  String get invalidPasswordError =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get invalidConfirmPasswordError => 'كلمات المرور غير متطابقة';

  @override
  String get authLoginFailed => 'فشل تسجيل الدخول. يرجى التحقق من بياناتك.';

  @override
  String get authOtpExpired => 'انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد.';

  @override
  String get authInvalidOtp => 'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.';

  @override
  String get authUnauthenticated => 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.';

  @override
  String get authCancelled => 'تم إلغاء عملية تسجيل الدخول.';

  @override
  String get unknownErrorMessage =>
      'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get noInternetMessage =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';

  @override
  String get timeoutMessage => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get formatErrorMessage =>
      'خطأ في تنسيق البيانات. يرجى المحاولة لاحقاً.';

  @override
  String get badCertificateMessage =>
      'خطأ في الاتصال الآمن. يرجى المحاولة لاحقاً.';

  @override
  String get connectionErrorMessage =>
      'خطأ في الاتصال بالشبكة. يرجى المحاولة لاحقاً.';

  @override
  String get code400Message => 'طلب غير صحيح. يرجى التأكد من صحة البيانات.';

  @override
  String get code401Message => 'غير مصرح بالوصول. يرجى تسجيل الدخول مجدداً.';

  @override
  String get code403Message => 'تم رفض الوصول. ليس لديك صلاحية.';

  @override
  String get code404Message => 'المورد المطلوب غير موجود.';

  @override
  String get code409Message => 'حدث تعارض. المورد موجود مسبقاً.';

  @override
  String get code422Message =>
      'خطأ في التحقق من البيانات. يرجى مراجعة المدخلات.';

  @override
  String get code429Message => 'طلبات كثيرة جداً. يرجى الانتظار قليلاً.';

  @override
  String get code500sMessage => 'خطأ في الخادم. يرجى المحاولة بعد لحظات.';

  @override
  String get loginTitle => 'مرحباً بعودتك!';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingBack => 'السابق';

  @override
  String get onboardingDoIt => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'ثمن التميز\nهو الانضباط';

  @override
  String get onboardingSubtitle1 =>
      'النجاح يبدأ بالالتزام اليومي. حافظ على استمرارك وتجاوز حدودك لتصل إلى أعلى مستويات اللياقة والتميز.';

  @override
  String get onboardingTitle2 =>
      'اللياقة البدنية لم تكن أبداً\nبهذا القدر من المتعة';

  @override
  String get onboardingSubtitle2 =>
      'حوّل تمارينك إلى رحلة ممتعة مع تحديات حماسية وخطط تدريب تجعل كل خطوة مليئة بالطاقة والشغف.';

  @override
  String get onboardingTitle3 => 'لا مزيد من الأعذار\nابدأ الآن';

  @override
  String get onboardingSubtitle3 =>
      'توقف عن انتظار اللحظة المثالية. ابدأ الآن وتخلص من التردد لتصنع التغيير الحقيقي وتبني قوتك.';

  @override
  String get explore => 'استكشف';

  @override
  String get smartCoach => 'المدرب الذكي';

  @override
  String get workouts => 'التمارين';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get heyThere => 'مرحباً';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب بعد؟';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get register => 'تسجيل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get or => 'أو';

  @override
  String get forgetPassword => 'نسيت كلمة المرور';

  @override
  String get registeredSuccessfully => 'تم التسجيل بنجاح';

  @override
  String get missingRegistrationData =>
      'يرجى إكمال جميع بيانات التسجيل المطلوبة';

  @override
  String get googleAccountIdMissing =>
      'معرف حساب Google مفقود. يرجى المحاولة مرة أخرى.';

  @override
  String get googleAccountConnected => 'تم ربط حساب Google. أكمل ملفك الشخصي.';

  @override
  String get facebookAccountIdMissing =>
      'معرف حساب Facebook مفقود. يرجى المحاولة مرة أخرى.';

  @override
  String get facebookAccountConnected =>
      'تم ربط حساب Facebook. أكمل ملفك الشخصي.';

  @override
  String get accountNotFoundRegisterFirst =>
      'الحساب غير موجود. يرجى إنشاء حساب أولاً.';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك!';

  @override
  String get weNeedToKnowYourGender => 'نحتاج إلى معرفة جنسك';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get howOldAreYou => 'كم عمرك؟';

  @override
  String get personalizedPlanSubtitle => 'هذا يساعدنا في إنشاء خطتك المخصصة';

  @override
  String get year => 'سنة';

  @override
  String get whatIsYourWeight => 'ما هو وزنك؟';

  @override
  String get kg => 'كجم';

  @override
  String get whatIsYourHeight => 'ما هو طولك؟';

  @override
  String get cm => 'سم';

  @override
  String get whatIsYourGoal => 'ما هو هدفك؟';

  @override
  String get gainWeight => 'زيادة الوزن';

  @override
  String get loseWeight => 'خسارة الوزن';

  @override
  String get getFitter => 'تحسين اللياقة';

  @override
  String get gainMoreFlexible => 'زيادة المرونة';

  @override
  String get learnTheBasic => 'تعلم الأساسيات';

  @override
  String get activityLevelTitle => 'ما هو مستوى نشاطك\nالبدني المعتاد؟';

  @override
  String get rookie => 'مبتدئ جداً';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advance => 'متقدم';

  @override
  String get trueBeast => 'محترف رياضي';

  @override
  String get hiAhmed => 'مرحباً أحمد ،';

  @override
  String get letsStartYourDay => 'لنبدأ يومك';

  @override
  String get category => 'الفئات';

  @override
  String get gym => 'جيم';

  @override
  String get fitness => 'لياقة بدنية';

  @override
  String get yoga => 'يوغا';

  @override
  String get aerobics => 'تمارين هوائية';

  @override
  String get trainer => 'مدرب';

  @override
  String get recommendationToday => 'توصيات اليوم';

  @override
  String get jogging => 'ركض';

  @override
  String get pushUp => 'تمرين الضغط';

  @override
  String get squat => 'سكوات';

  @override
  String get upcomingWorkouts => 'التمارين القادمة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get fullBody => 'كامل الجسم';

  @override
  String get chest => 'الصدر';

  @override
  String get arm => 'الذراع';

  @override
  String get shoulder => 'الكتف';

  @override
  String get back => 'الظهر';

  @override
  String get legs => 'الأرجل';

  @override
  String get arms => 'الذراعين';

  @override
  String get recommendationForYou => 'موصى به لك';

  @override
  String get breakfast => 'فطور';

  @override
  String get lunch => 'غداء';

  @override
  String get dinner => 'عشاء';

  @override
  String get popularTraining => 'التدريبات الشائعة';

  @override
  String get exercisesThatStrengthenYourChest => 'تمارين لتقوية عضلات الصدر';

  @override
  String get exercisesThatStrengthenYourBack => 'تمارين لتقوية عضلات الظهر';

  @override
  String tasksCount(int count) {
    return '$count تمرين';
  }
}
