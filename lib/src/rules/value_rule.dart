import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a numeric value is within specified bounds.
class ValueRule extends ValidationRule<num> {
  /// The minimum allowed value.
  final num? minValue;

  /// The maximum allowed value.
  final num? maxValue;

  /// Creates a value validation rule with the specified bounds and error message.
  ValueRule({
    this.minValue,
    this.maxValue,
    String? errorMessage,
  }) : super(
          errorMessage: errorMessage ?? _getDefaultErrorMessage(minValue, maxValue),
        );

  static String _getDefaultErrorMessage(num? minValue, num? maxValue) {
    if (minValue != null && maxValue != null) {
      return 'Must be between $minValue and $maxValue';
    } else if (minValue != null) {
      return 'Must be at least $minValue';
    } else if (maxValue != null) {
      return 'Must be at most $maxValue';
    } else {
      return 'Invalid value';
    }
  }

  @override
  ValidationResult validate(num? value) {
    if (value == null) {
      return const ValidationResult.success();
    }

    if (minValue != null && value < minValue!) {
      return ValidationResult.error(errorMessage);
    }

    if (maxValue != null && value > maxValue!) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}

/// Validates that a numeric value is at least a specified minimum.
class MinValueRule extends ValueRule {
  /// Creates a minimum value validation rule.
  MinValueRule(
    num minValue, {
    super.errorMessage,
  }) : super(
          minValue: minValue,
        );
}

/// Validates that a numeric value is at most a specified maximum.
class MaxValueRule extends ValueRule {
  /// Creates a maximum value validation rule.
  MaxValueRule(
    num maxValue, {
    super.errorMessage,
  }) : super(
          maxValue: maxValue,
        );
}
