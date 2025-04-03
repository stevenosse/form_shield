import 'validation_result.dart';

/// Base interface for all validation rules.
abstract class ValidationRule<T> {
  /// The error message to display when validation fails.
  final String errorMessage;

  /// Creates a validation rule with the specified error message.
  const ValidationRule({required this.errorMessage});

  /// Validates the given value and returns a [ValidationResult].
  ValidationResult validate(T? value);
}
