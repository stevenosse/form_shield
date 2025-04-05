import 'dart:async';

import 'validation_result.dart';

/// Base interface for all validation rules.
abstract class ValidationRule<T> {
  /// The error message to display when validation fails.
  final String errorMessage;

  /// Creates a validation rule with the specified error message.
  const ValidationRule({required this.errorMessage});

  /// Validates the given value and returns a [ValidationResult].
  ValidationResult validate(T? value);

  /// Validates the given value asynchronously and returns a [Future<ValidationResult>].
  ///
  /// This method is only used for async validation rules. By default, it wraps the
  /// synchronous [validate] method in a Future.
  // Asynchronous validation (override if needed)
  Future<ValidationResult> validateAsync(T? value) async => validate(value);
}

/// Base interface for asynchronous validation rules.
abstract class AsyncValidationRule<T> extends ValidationRule<T> {
  /// Creates an asynchronous validation rule with the specified error message.
  const AsyncValidationRule({required super.errorMessage});

  @override
  ValidationResult validate(T? value) {
    // This is a fallback for sync validation contexts
    // Ideally, async rules should be validated using validateAsync
    return const ValidationResult.success();
  }

  @override
  Future<ValidationResult> validateAsync(T? value);
}
