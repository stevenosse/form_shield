/// Represents the result of a validation operation.
class ValidationResult {
  /// Whether the validation passed.
  final bool isValid;

  /// The error message if validation failed, null otherwise.
  final String? errorMessage;

  /// Creates a successful validation result.
  const ValidationResult.success() : this._(true, null);

  /// Creates a failed validation result with an error message.
  const ValidationResult.error(String message) : this._(false, message);

  const ValidationResult._(this.isValid, this.errorMessage);

  @override
  String toString() =>
      'ValidationResult(isValid: $isValid, errorMessage: $errorMessage)';
}
