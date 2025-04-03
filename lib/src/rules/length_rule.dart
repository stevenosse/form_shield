import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a string's length is within specified bounds.
class LengthRule extends ValidationRule<String> {
  /// The minimum allowed length.
  final int? minLength;

  /// The maximum allowed length.
  final int? maxLength;

  /// Creates a length validation rule with the specified bounds and error message.
  LengthRule({
    this.minLength,
    this.maxLength,
    String? errorMessage,
  }) : super(
          errorMessage:
              errorMessage ?? _getDefaultErrorMessage(minLength, maxLength),
        );

  static String _getDefaultErrorMessage(int? minLength, int? maxLength) {
    if (minLength != null && maxLength != null) {
      return 'Must be between $minLength and $maxLength characters';
    } else if (minLength != null) {
      return 'Must be at least $minLength characters';
    } else if (maxLength != null) {
      return 'Must be at most $maxLength characters';
    } else {
      return 'Invalid length';
    }
  }

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    final length = value.length;

    if (minLength != null && length < minLength!) {
      return ValidationResult.error(errorMessage);
    }

    if (maxLength != null && length > maxLength!) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}

/// Validates that a string's length is at least a specified minimum.
class MinLengthRule extends LengthRule {
  /// Creates a minimum length validation rule.
  MinLengthRule(
    int minLength, {
    super.errorMessage,
  }) : super(
          minLength: minLength,
        );
}

/// Validates that a string's length is at most a specified maximum.
class MaxLengthRule extends LengthRule {
  /// Creates a maximum length validation rule.
  MaxLengthRule(
    int maxLength, {
    super.errorMessage,
  }) : super(
          maxLength: maxLength,
        );
}
