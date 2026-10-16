import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';

@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  final StorageService _storageService;

  LocaleCubit(this._storageService) : super(const Locale('en')) {
    loadSavedLocale();
  }

  Future<void> loadSavedLocale() async {
    final savedLanguageCode = await _storageService.get(AppConstants.localeKey);
    if (savedLanguageCode == 'ar') {
      emit(const Locale('ar'));
    } else if (savedLanguageCode == 'en') {
      emit(const Locale('en'));
    }
  }

  Future<void> changeLocale(Locale locale) async {
    if (state == locale) return;
    await _storageService.save(AppConstants.localeKey, locale.languageCode);
    emit(locale);
  }
}
