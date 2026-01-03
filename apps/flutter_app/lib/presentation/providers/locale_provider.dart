import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale state notifier for managing app language
class LocaleNotifier extends StateNotifier<Locale> {
  static const _localeKey = 'app_locale';
  
  LocaleNotifier() : super(const Locale('ar')) {
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
  
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'ar' 
        ? const Locale('en') 
        : const Locale('ar');
    await setLocale(newLocale);
  }
  
  bool get isArabic => state.languageCode == 'ar';
  bool get isRtl => state.languageCode == 'ar';
}

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Convenience provider for checking if current locale is RTL
final isRtlProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ar';
});

/// Convenience provider for checking if current locale is Arabic
final isArabicProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ar';
});
