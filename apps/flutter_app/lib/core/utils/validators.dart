import 'package:flutter/material.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';

class Validators {
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return regex.hasMatch(email);
  }
  
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return phone.length >= 9;
  }
  
  static bool isValidPin(String? pin) {
    if (pin == null || pin.isEmpty) return false;
    return pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin);
  }
  
  static String? email(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errorEmailRequired;
    }
    if (!isValidEmail(value)) {
      return l10n.errorEmailInvalid;
    }
    return null;
  }
  
  static String? password(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.errorPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.errorPasswordTooShort;
    }
    return null;
  }
  
  static String? required(BuildContext context, String? value, {String? fieldName}) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errorRequired;
    }
    return null;
  }
}
