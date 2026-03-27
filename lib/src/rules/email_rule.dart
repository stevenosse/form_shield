import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a string is a valid email address.
class EmailRule extends ValidationRule<String> {
  /// Regular expression for validating email addresses.
  ///
  /// The default pattern follows the HTML5 specification for email validation.
  static final RegExp _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)+$');

  final RegExp _resolvedRegex;

  /// Creates an email validation rule with the specified error message and regex pattern.
  ///
  /// If [pattern] is provided, it overrides the default HTML5 email regex.
  /// If [errorMessage] is not provided, uses the localized message.
  EmailRule({
    super.errorMessage = '',
    String? pattern,
  }) : _resolvedRegex = pattern != null ? RegExp(pattern) : _emailRegex;

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (!_resolvedRegex.hasMatch(value)) {
      final message = errorMessage.isNotEmpty
          ? errorMessage
          : FormShieldLocalizations.invalidEmail;
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
