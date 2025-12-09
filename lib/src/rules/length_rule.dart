import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a string's length is within specified bounds.
class LengthRule extends ValidationRule<String> {
  /// The minimum allowed length.
  final int? minLength;

  /// The maximum allowed length.
  final int? maxLength;

  /// Creates a length validation rule with the specified bounds and error message.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  LengthRule({
    this.minLength,
    this.maxLength,
    super.errorMessage = '',
  });

  /// Gets the appropriate localized error message.
  String _getLocalizedMessage() {
    if (minLength != null && maxLength != null) {
      return FormShieldLocalizations.lengthBetween(minLength!, maxLength!);
    } else if (minLength != null) {
      return FormShieldLocalizations.lengthMin(minLength!);
    } else if (maxLength != null) {
      return FormShieldLocalizations.lengthMax(maxLength!);
    } else {
      return FormShieldLocalizations.invalidLength;
    }
  }

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    final length = value.length;

    if (minLength != null && length < minLength!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    if (maxLength != null && length > maxLength!) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
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
  }) : super(minLength: minLength);
}

/// Validates that a string's length is at most a specified maximum.
class MaxLengthRule extends LengthRule {
  /// Creates a maximum length validation rule.
  MaxLengthRule(
    int maxLength, {
    super.errorMessage,
  }) : super(maxLength: maxLength);
}
