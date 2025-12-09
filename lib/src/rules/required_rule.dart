import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a value is not null or empty.
class RequiredRule<T> extends ValidationRule<T> {
  /// Creates a required validation rule with the specified error message.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  /// Make sure to add S.delegate to your app's localizationsDelegates for i18n support.
  const RequiredRule({
    super.errorMessage = '',
  });

  @override
  ValidationResult validate(T? value) {
    // Use custom message if provided, otherwise use localized message
    final message = errorMessage.isNotEmpty
        ? errorMessage
        : FormShieldLocalizations.requiredField;

    if (value == null) {
      return ValidationResult.error(message);
    }

    if (value is String && value.trim().isEmpty) {
      return ValidationResult.error(message);
    }

    if (value is Iterable && value.isEmpty) {
      return ValidationResult.error(message);
    }

    if (value is Map && value.isEmpty) {
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
