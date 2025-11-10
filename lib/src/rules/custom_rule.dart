import '../validation_rule.dart';
import '../validation_result.dart';

/// A validation rule that uses a custom function to validate values.
@Deprecated('Extend ValidationRule instead')
class CustomRule<T> extends ValidationRule<T> {
  /// The function that performs the validation.
  final bool Function(T? value) _validator;

  /// Creates a custom validation rule with the specified validator function and error message.
  const CustomRule({
    required bool Function(T? value) validator,
    required super.errorMessage,
  }) : _validator = validator;

  @override
  ValidationResult validate(T? value) {
    if (_validator(value)) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}

/// A validation rule that uses a custom function to validate values and return a dynamic error message.
@Deprecated('Extend ValidationRule instead')
class DynamicCustomRule<T> extends ValidationRule<T> {
  /// The function that performs the validation and returns an error message if validation fails.
  final String? Function(T? value) _validator;

  /// Creates a dynamic custom validation rule with the specified validator function.
  const DynamicCustomRule({
    required String? Function(T? value) validator,
  })  : _validator = validator,
        super(errorMessage: '');

  @override
  ValidationResult validate(T? value) {
    final errorMessage = _validator(value);
    if (errorMessage == null) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}
