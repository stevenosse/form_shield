import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a value is not null or empty.
class RequiredRule<T> extends ValidationRule<T> {
  /// Creates a required validation rule with the specified error message.
  const RequiredRule({
    super.errorMessage = 'This field is required',
  });

  @override
  ValidationResult validate(T? value) {
    if (value == null) {
      return ValidationResult.error(errorMessage);
    }

    if (value is String && value.trim().isEmpty) {
      return ValidationResult.error(errorMessage);
    }

    if (value is Iterable && value.isEmpty) {
      return ValidationResult.error(errorMessage);
    }

    if (value is Map && value.isEmpty) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
