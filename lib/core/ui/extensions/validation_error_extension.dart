import 'package:flutter/widgets.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

extension ValidationErrorLocalization on ValidationError {
  String toLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ValidationError.empty => l10n.emptyValidationError,
      ValidationError.invalidEmail => l10n.invalidEmailError,
      ValidationError.invalidPhone => l10n.invalidPhoneError,
      ValidationError.invalidNationalId => l10n.nationalIdError,
      ValidationError.weakPassword => l10n.weakPasswordError,
      ValidationError.passwordTooShort => l10n.passwordMustBeAtLeast8Characters,
      ValidationError.passwordMissingUppercase =>
        l10n.passwordMustContainUppercase,
      ValidationError.passwordMissingLowercase =>
        l10n.passwordMustContainLowercase,
      ValidationError.passwordMissingNumber => l10n.passwordMustContainNumber,
      ValidationError.passwordMissingSpecialChar =>
        l10n.passwordMustContainSpecialCharacter,
      ValidationError.passwordMismatch => l10n.passwordMismatchError,
      ValidationError.fileRequired => l10n.fileRequiredError,
      ValidationError.dropdownRequired => l10n.dropdownRequiredError,
      ValidationError.invalidLoginPassword => l10n.invalidLoginPasswordError,
    };
  }
}
