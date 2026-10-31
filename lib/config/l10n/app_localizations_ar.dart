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
  String get nationalIdError => 'يرجى إدخال رقم قومي صحيح';

  @override
  String get weakPasswordError => 'كلمة المرور ضعيفة جداً';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get passwordMustContainUppercase =>
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';

  @override
  String get passwordMustContainLowercase =>
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';

  @override
  String get passwordMustContainNumber =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get passwordMustContainSpecialCharacter =>
      'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';

  @override
  String get passwordMismatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get fileRequiredError => 'يرجى تحميل الملف المطلوب';

  @override
  String get dropdownRequiredError => 'يرجى اختيار قيمة';

  @override
  String get generalValidationError => 'مدخلات غير صحيحة';

  @override
  String get invalidLoginPasswordError =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل مع حرف كبير ورقم';

  @override
  String get generalErrorMessage =>
      'حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get connectionErrorMessage =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get noConnectionErrorMessage =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';

  @override
  String get securityErrorMessage => 'تعذر إنشاء اتصال آمن.';

  @override
  String get cancelErrorMessage => 'تم إلغاء الطلب.';

  @override
  String get code400Message =>
      'طلب غير صالح. يرجى التحقق من بياناتك والمحاولة مجدداً.';

  @override
  String get code401Message =>
      'انتهت الجلسة أو بيانات الاعتماد غير صحيحة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get code403Message => 'ليس لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get code404Message => 'العنصر المطلوب غير موجود.';

  @override
  String get code409Message => 'الحساب أو المورد مسجل مسبقاً.';

  @override
  String get code422Message =>
      'خطأ في التحقق من البيانات. يرجى مراجعة المدخلات.';

  @override
  String get code429Message =>
      'محاولات كثيرة جداً. يرجى الانتظار قليلاً والمحاولة مجدداً.';

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
  String get register => 'إنشاء حساب';
}
