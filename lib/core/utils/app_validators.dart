import 'dart:io';

enum ValidationError {
  empty,
  invalidEmail,
  invalidPhone,
  invalidNationalId,
  weakPassword,
  passwordTooShort,
  passwordMissingUppercase,
  passwordMissingLowercase,
  passwordMissingNumber,
  passwordMissingSpecialChar,
  passwordMismatch,
  fileRequired,
  dropdownRequired,
}

abstract final class AppValidators {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^01[0125][0-9]{8}$';
  static const String nationalIdPattern = r'^\d{14}$';
  static const String usernamePattern = r'^[a-zA-Z0-9._]{3,}$';
  static const String namePattern = r'^[a-zA-Z\s]{3,}$';

  static const String passwordUppercasePattern = r'[A-Z]';
  static const String passwordLowercasePattern = r'[a-z]';
  static const String passwordNumberPattern = r'[0-9]';
  static const String passwordSpecialCharPattern = r'[#?!@$%^&*-]';

  static final RegExp emailRegex = RegExp(emailPattern);
  static final RegExp phoneRegex = RegExp(phonePattern);
  static final RegExp nationalIdRegex = RegExp(nationalIdPattern);
  static final RegExp usernameRegex = RegExp(usernamePattern);
  static final RegExp nameRegex = RegExp(namePattern);

  static final RegExp passwordUppercaseRegex = RegExp(passwordUppercasePattern);
  static final RegExp passwordLowercaseRegex = RegExp(passwordLowercasePattern);
  static final RegExp passwordNumberRegex = RegExp(passwordNumberPattern);
  static final RegExp passwordSpecialCharRegex = RegExp(
    passwordSpecialCharPattern,
  );

  static final Map<String, RegExp> _compiledRegexCache = {
    emailPattern: emailRegex,
    phonePattern: phoneRegex,
    nationalIdPattern: nationalIdRegex,
    usernamePattern: usernameRegex,
    namePattern: nameRegex,
    passwordUppercasePattern: passwordUppercaseRegex,
    passwordLowercasePattern: passwordLowercaseRegex,
    passwordNumberPattern: passwordNumberRegex,
    passwordSpecialCharPattern: passwordSpecialCharRegex,
  };

  static bool validate(String pattern, String input) {
    final regex = _compiledRegexCache.putIfAbsent(
      pattern,
      () => RegExp(pattern),
    );
    return regex.hasMatch(input);
  }

  static bool validateRegex(RegExp regExp, String input) {
    return regExp.hasMatch(input);
  }

  static ValidationError? validateRequired(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    return null;
  }

  static ValidationError? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!emailRegex.hasMatch(val.trim())) return ValidationError.invalidEmail;
    return null;
  }

  static ValidationError? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!phoneRegex.hasMatch(val.trim())) return ValidationError.invalidPhone;
    return null;
  }

  static ValidationError? validateNationalId(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!nationalIdRegex.hasMatch(val.trim())) {
      return ValidationError.invalidNationalId;
    }
    return null;
  }

  static ValidationError? validatePassword(String? val) {
    if (val == null || val.isEmpty) return ValidationError.empty;
    if (val.length < 8 ||
        !passwordUppercaseRegex.hasMatch(val) ||
        !passwordLowercaseRegex.hasMatch(val) ||
        !passwordNumberRegex.hasMatch(val) ||
        !passwordSpecialCharRegex.hasMatch(val)) {
      return ValidationError.weakPassword;
    }
    return null;
  }

  static ValidationError? validatePasswordDetailed(String? val) {
    if (val == null || val.isEmpty) return ValidationError.empty;
    if (val.length < 8) return ValidationError.passwordTooShort;
    if (!passwordUppercaseRegex.hasMatch(val)) {
      return ValidationError.passwordMissingUppercase;
    }
    if (!passwordLowercaseRegex.hasMatch(val)) {
      return ValidationError.passwordMissingLowercase;
    }
    if (!passwordNumberRegex.hasMatch(val)) {
      return ValidationError.passwordMissingNumber;
    }
    if (!passwordSpecialCharRegex.hasMatch(val)) {
      return ValidationError.passwordMissingSpecialChar;
    }
    return null;
  }

  static ValidationError? validateConfirmPassword(
    String? val,
    String passwordToMatch,
  ) {
    if (val == null || val.isEmpty) return ValidationError.empty;
    if (val != passwordToMatch) return ValidationError.passwordMismatch;
    return null;
  }

  static ValidationError? validateFile(
    File? file, [
    ValidationError error = ValidationError.fileRequired,
  ]) {
    if (file == null) return error;
    return null;
  }

  static ValidationError? validateDropdown<T>(T? value) {
    if (value == null) return ValidationError.dropdownRequired;
    return null;
  }
}
