import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a numeric value is within specified bounds.
class ValueRule extends ValidationRule<num> {
  /// The minimum allowed value.
  final num? minValue;

  /// The maximum allowed value.
  final num? maxValue;

  /// Creates a value validation rule with the specified bounds and error message.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  ValueRule({
    this.minValue,
    this.maxValue,
    super.errorMessage = '',
  });

  /// Gets the appropriate localized error message.
  String _getLocalizedMessage() {
    if (minValue != null && maxValue != null) {
      return FormShieldLocalizations.valueBetween(
          minValue.toString(), maxValue.toString());
    } else if (minValue != null) {
      return FormShieldLocalizations.valueMin(minValue.toString());
    } else if (maxValue != null) {
      return FormShieldLocalizations.valueMax(maxValue.toString());
    } else {
      return FormShieldLocalizations.invalidValue;
    }
  }

  @override
  ValidationResult validate(num? value) {
    if (value == null) {
      return const ValidationResult.success();
    }

    if (minValue != null && value < minValue!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    if (maxValue != null && value > maxValue!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
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
  }) : super(minValue: minValue);
}

/// Validates that a numeric value is at most a specified maximum.
class MaxValueRule extends ValueRule {
  /// Creates a maximum value validation rule.
  MaxValueRule(
    num maxValue, {
    super.errorMessage,
  }) : super(maxValue: maxValue);
}

/// Validates that a numeric value is at least a specified minimum.
/// Works with form inputs.
class FormInputValueRule extends ValidationRule<String> {
  final num? minValue;
  final num? maxValue;
  final num Function(String) convert;

  /// Creates a form input value validation rule.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  FormInputValueRule({
    super.errorMessage = '',
    this.minValue,
    this.maxValue,
    required this.convert,
  });

  /// Gets the appropriate localized error message.
  String _getLocalizedMessage() {
    if (minValue != null && maxValue != null) {
      return FormShieldLocalizations.valueBetween(
          minValue.toString(), maxValue.toString());
    } else if (minValue != null) {
      return FormShieldLocalizations.valueMin(minValue.toString());
    } else if (maxValue != null) {
      return FormShieldLocalizations.valueMax(maxValue.toString());
    } else {
      return FormShieldLocalizations.invalidValue;
    }
  }

  @override
  ValidationResult validate(String? value) {
    if (value == null) {
      return const ValidationResult.success();
    }

    final num parsedValue;
    try {
      parsedValue = convert(value);
    } catch (_) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    if (minValue != null && parsedValue < minValue!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    if (maxValue != null && parsedValue > maxValue!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}

/// Validates that a numeric value is at least a specified minimum.
/// Works with form inputs.
class FormInputMinValueRule extends FormInputValueRule {
  /// Creates a minimum value validation rule.
  FormInputMinValueRule({
    super.errorMessage,
    required super.minValue,
    required super.convert,
  });
}

/// Validates that a numeric value is at most a specified maximum.
/// Works with form inputs.
class FormInputMaxValueRule extends FormInputValueRule {
  /// Creates a maximum value validation rule.
  FormInputMaxValueRule({
    super.errorMessage,
    required super.maxValue,
    required super.convert,
  });
}
