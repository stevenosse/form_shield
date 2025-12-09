import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a string is a valid phone number.
class PhoneRule extends ValidationRule<String> {
  final RegExp _phoneRegex;

  /// Creates a phone validation rule with the specified error message and regex pattern.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  PhoneRule({
    super.errorMessage = '',
    String pattern =
        r'^(?=(?:\D*\d){6,15}$)(?:\+\d{1,3}[ .-]?)?(?:\(\d{1,4}\)|\d{1,4})(?:[ .-]?\d{1,4})+$',
  }) : _phoneRegex = RegExp(pattern);

  @override
  ValidationResult validate(String? value) {
    final message = errorMessage.isNotEmpty
        ? errorMessage
        : FormShieldLocalizations.invalidPhone;

    if (value == null || value.isEmpty) {
      return ValidationResult.error(message);
    }

    if (!_phoneRegex.hasMatch(value)) {
      return ValidationResult.error(message);
    }

    return ValidationResult.success();
  }
}
