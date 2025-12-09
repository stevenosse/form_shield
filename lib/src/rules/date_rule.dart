import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Validates that a date string is within specified bounds.
///
/// This rule now operates on `String?` inputs to work directly with
/// text form fields. Non-empty values are parsed using `DateTime.tryParse`
/// (expects ISO-8601 like `YYYY-MM-DD`). If parsing fails, the rule
/// returns an error using the configured message.
class DateRule extends ValidationRule<String> {
  /// The minimum allowed date.
  final DateTime? minDate;

  /// The maximum allowed date.
  final DateTime? maxDate;

  /// Creates a date validation rule with the specified bounds and error message.
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  DateRule({
    this.minDate,
    this.maxDate,
    super.errorMessage = '',
  });

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Gets the appropriate localized error message.
  String _getLocalizedMessage({bool isInvalidFormat = false}) {
    if (isInvalidFormat) {
      return FormShieldLocalizations.invalidDate;
    }
    if (minDate != null && maxDate != null) {
      return FormShieldLocalizations.dateBetween(
          _formatDate(minDate!), _formatDate(maxDate!));
    } else if (minDate != null) {
      return FormShieldLocalizations.dateOnOrAfter(_formatDate(minDate!));
    } else if (maxDate != null) {
      return FormShieldLocalizations.dateOnOrBefore(_formatDate(maxDate!));
    } else {
      return FormShieldLocalizations.invalidDate;
    }
  }

  @override
  ValidationResult validate(String? value) {
    // Empty values are handled by RequiredRule; treat as success.
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.success();
    }

    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) {
      // Invalid date format
      final message = errorMessage.isNotEmpty
          ? errorMessage
          : _getLocalizedMessage(isInvalidFormat: true);
      return ValidationResult.error(message);
    }

    if (minDate != null && parsed.isBefore(minDate!)) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    if (maxDate != null && parsed.isAfter(maxDate!)) {
      final message =
          errorMessage.isNotEmpty ? errorMessage : _getLocalizedMessage();
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
