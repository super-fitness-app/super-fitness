import 'package:flutter/widgets.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/core/ui/handlers/app_error_handler.dart';

extension AppFailureLocalization on AppFailure {
  String toLocalizedMessage(BuildContext context) {
    return switch (this) {
      ServerMessageFailure(:final message) => message,
      NetworkFailure(:final error) =>
        AppErrorHandler.getLocalizedMessage(context, error),
      CancelledFailure(:final message) =>
        message ?? AppStrings.signInCancelled,
    };
  }
}
