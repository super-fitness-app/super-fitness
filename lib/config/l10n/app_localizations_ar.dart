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
  String get loading => 'جارِ التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get continueButton => 'متابعة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get loginTitle => 'مرحباً بعودتك!';

  @override
  String get loginSubtitle => 'أدخل بياناتك للمتابعة في رحلتك الرياضية';

  @override
  String get registerTitle => 'إنشاء حساب جديد';

  @override
  String get registerSubtitle => 'انضم إلى سوبر فيتنس وحقق أهدافك';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDescription =>
      'أدخل بريدك الإلكتروني لاستلام رمز إعادة التعيين';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get firstNameHint => 'أدخل اسمك الأول';

  @override
  String get lastNameLabel => 'الاسم الأخير';

  @override
  String get lastNameHint => 'أدخل اسم العائلة';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => 'أدخل رقم الهاتف';

  @override
  String get weightLabel => 'الوزن (كجم)';

  @override
  String get weightHint => 'أدخل وزنك';

  @override
  String get heightLabel => 'الطول (سم)';

  @override
  String get heightHint => 'أدخل طولك';

  @override
  String get ageLabel => 'العمر';

  @override
  String get ageHint => 'أدخل عمرك';

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
  String get homeTab => 'الرئيسية';

  @override
  String get workoutsTab => 'التمارين';

  @override
  String get metricsTab => 'المؤشرات';

  @override
  String get profileTab => 'الملف الشخصي';

  @override
  String get dailyGoals => 'الأهداف اليومية';

  @override
  String get caloriesBurned => 'السعرات المحروقة';

  @override
  String get minutesTrained => 'دقائق التدريب';

  @override
  String get workoutsCompleted => 'التمارين المكتملة';

  @override
  String get exploreWorkouts => 'استكشاف التمارين';

  @override
  String get startWorkout => 'ابدأ التمرين';

  @override
  String get splashTitle => 'سوبر فيتنس';
}
