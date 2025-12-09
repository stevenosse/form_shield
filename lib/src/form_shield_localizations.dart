import 'generated/l10n.dart';

/// Helper class to safely access localization strings.
///
/// This class provides safe access to localized strings with fallback to English
/// when the S delegate has not been initialized (e.g., in tests or when client apps
/// don't add the delegate).
class FormShieldLocalizations {
  FormShieldLocalizations._();

  /// Returns true if the localization delegate has been initialized.
  static bool get isInitialized {
    try {
      FormShieldI18n.current;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Gets the S instance if available, or null if not initialized.
  static FormShieldI18n? get _s {
    try {
      return FormShieldI18n.current;
    } catch (_) {
      return null;
    }
  }

  // Simple strings with English fallbacks
  static String get requiredField =>
      _s?.requiredField ?? 'This field is required';
  static String get invalidEmail =>
      _s?.invalidEmail ?? 'Please enter a valid email address';
  static String get invalidPhone =>
      _s?.invalidPhone ?? 'Please enter a valid phone number';
  static String get invalidUrl => _s?.invalidUrl ?? 'Please enter a valid URL';
  static String get invalidCreditCard =>
      _s?.invalidCreditCard ?? 'Please enter a valid credit card number';
  static String get invalidIpAddress =>
      _s?.invalidIpAddress ?? 'Please enter a valid IP address';
  static String get invalidIpv4Address =>
      _s?.invalidIpv4Address ?? 'Please enter a valid IPv4 address';
  static String get invalidIpv6Address =>
      _s?.invalidIpv6Address ?? 'Please enter a valid IPv6 address';
  static String get invalidIpv4OrIpv6Address =>
      _s?.invalidIpv4OrIpv6Address ??
      'Please enter a valid IPv4 or IPv6 address';
  static String get passwordsDoNotMatch =>
      _s?.passwordsDoNotMatch ?? 'Passwords do not match';
  static String get passwordRequirements =>
      _s?.passwordRequirements ?? 'Password does not meet requirements';
  static String get passwordUppercase =>
      _s?.passwordUppercase ??
      'Password must contain at least one uppercase letter';
  static String get passwordLowercase =>
      _s?.passwordLowercase ??
      'Password must contain at least one lowercase letter';
  static String get passwordDigit =>
      _s?.passwordDigit ?? 'Password must contain at least one digit';
  static String get passwordSpecialChar =>
      _s?.passwordSpecialChar ??
      'Password must contain at least one special character';
  static String get invalidLength => _s?.invalidLength ?? 'Invalid length';
  static String get invalidValue => _s?.invalidValue ?? 'Invalid value';
  static String get invalidDate => _s?.invalidDate ?? 'Invalid date';
  static String get endDateAfterStart =>
      _s?.endDateAfterStart ?? 'End date must be after start date';

  // Parameterized strings with English fallbacks
  static String passwordMinLength(int length) =>
      _s?.passwordMinLength(length) ??
      'Password must be at least $length characters long';
  static String lengthBetween(int min, int max) =>
      _s?.lengthBetween(min, max) ?? 'Must be between $min and $max characters';
  static String lengthMin(int min) =>
      _s?.lengthMin(min) ?? 'Must be at least $min characters';
  static String lengthMax(int max) =>
      _s?.lengthMax(max) ?? 'Must be at most $max characters';
  static String valueBetween(String min, String max) =>
      _s?.valueBetween(min, max) ?? 'Must be between $min and $max';
  static String valueMin(String min) =>
      _s?.valueMin(min) ?? 'Must be at least $min';
  static String valueMax(String max) =>
      _s?.valueMax(max) ?? 'Must be at most $max';
  static String dateBetween(String min, String max) =>
      _s?.dateBetween(min, max) ?? 'Date must be between $min and $max';
  static String dateOnOrAfter(String date) =>
      _s?.dateOnOrAfter(date) ?? 'Date must be on or after $date';
  static String dateOnOrBefore(String date) =>
      _s?.dateOnOrBefore(date) ?? 'Date must be on or before $date';
  static String urlProtocolRequired(String protocols) =>
      _s?.urlProtocolRequired(protocols) ??
      'URL must use one of the following protocols: $protocols';
}
