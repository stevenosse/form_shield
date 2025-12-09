import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a string is a valid email address.
class EmailRule extends ValidationRule<String> {
  /// Regular expression for validating email addresses.
  final RegExp _emailRegex;

  /// Creates an email validation rule with the specified error message and regex pattern.
  ///
  /// The default regex pattern follows the HTML5 specification for email validation.
  /// If [errorMessage] is not provided, uses the localized message.
  EmailRule({
    super.errorMessage = '',
    String pattern =
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)+$',
  }) : _emailRegex = RegExp(pattern);

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (!_emailRegex.hasMatch(value)) {
      final message = errorMessage.isNotEmpty
          ? errorMessage
          : FormShieldLocalizations.invalidEmail;
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
