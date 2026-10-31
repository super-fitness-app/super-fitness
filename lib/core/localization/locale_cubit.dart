import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';

@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  final StorageService _storageService;

  LocaleCubit(this._storageService)
    : super(const Locale(AppConstants.localeEnglish)) {
    loadSavedLocale();
  }

  Future<void> loadSavedLocale() async {
    try {
      final savedLanguageCode = await _storageService.get(
        AppConstants.localeKey,
      );
      if (savedLanguageCode == AppConstants.localeArabic) {
        emit(const Locale(AppConstants.localeArabic));
      } else if (savedLanguageCode == AppConstants.localeEnglish) {
        emit(const Locale(AppConstants.localeEnglish));
      }
    } catch (_) {
      // Retain fallback locale if reading fails
    }
  }

  Future<void> changeLocale(Locale locale) async {
    if (state == locale) return;
    try {
      await _storageService.save(AppConstants.localeKey, locale.languageCode);
      emit(locale);
    } catch (_) {
      // Retain previous state if saving fails
    }
  }
}
