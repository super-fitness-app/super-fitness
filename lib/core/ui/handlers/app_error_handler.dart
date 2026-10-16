import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/app_error.dart';

abstract final class AppErrorHandler {
  static String getLocalizedMessage(BuildContext context, AppError error) {
    final l10n = AppLocalizations.of(context)!;

    return switch (error) {
      AppError.general => l10n.generalErrorMessage,
      AppError.timeout => l10n.connectionErrorMessage,
      AppError.noConnection => l10n.noConnectionErrorMessage,
      AppError.security => l10n.securityErrorMessage,
      AppError.cancelled => l10n.cancelErrorMessage,
      AppError.badRequest => l10n.code400Message,
      AppError.unauthorized || AppError.forceLogin => l10n.code401Message,
      AppError.forbidden => l10n.code403Message,
      AppError.notFound => l10n.code404Message,
      AppError.conflict => l10n.code409Message,
      AppError.validation => l10n.code422Message,
      AppError.tooManyRequests => l10n.code429Message,
      AppError.server => l10n.code500sMessage,
      AppError.badResponse || AppError.unknown => l10n.generalErrorMessage,
    };
  }
}
