import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends GetxService {
  final _storageKey = 'locale';
  final _locale = const Locale('ar').obs;

  final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  final box = GetStorage();

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await _loadLocale();
  }

  Future<void> _saveLocale(String languageCode) async {
    await box.write(_storageKey, languageCode);
  }

  Future<void> _loadLocale() async {
    String? languageCode = box.read(_storageKey);
    if (languageCode != null) {
      _locale.value = Locale(languageCode);
    }
  }

  void changeLocale(String languageCode) async {
    Locale locale = supportedLocales.firstWhere(
      (element) => element.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );
    _locale.value = locale;
    Get.updateLocale(locale);
    await _saveLocale(languageCode);
  }
}
