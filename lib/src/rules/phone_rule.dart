import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a string is a valid phone number.
class PhoneRule extends ValidationRule<String> {
  /// Default regex pattern for phone number validation.
  static final RegExp _defaultPhoneRegex = RegExp(
      r'^(?=(?:\D*\d){6,15}$)(?:\+\d{1,3}[ .-]?)?(?:\(\d{1,4}\)|\d{1,4})(?:[ .-]?\d{1,4})+$');

  final RegExp _phoneRegex;

  /// Creates a phone validation rule with the specified error message and regex pattern.
  ///
  /// Empty or null values are treated as valid (use [RequiredRule] to enforce presence).
  /// If [errorMessage] is not provided, uses the localized message.
  PhoneRule({
    super.errorMessage = '',
    String? pattern,
  }) : _phoneRegex = pattern != null ? RegExp(pattern) : _defaultPhoneRegex;

  @override
  ValidationResult validate(String? value) {
    // Empty values are handled by RequiredRule; treat as success.
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (!_phoneRegex.hasMatch(value)) {
      final message = errorMessage.isNotEmpty
          ? errorMessage
          : FormShieldLocalizations.invalidPhone;
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
