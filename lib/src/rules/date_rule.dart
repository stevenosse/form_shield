import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a date is within specified bounds.
class DateRule extends ValidationRule<DateTime> {
  /// The minimum allowed date.
  final DateTime? minDate;

  /// The maximum allowed date.
  final DateTime? maxDate;

  /// Creates a date validation rule with the specified bounds and error message.
  DateRule({
    this.minDate,
    this.maxDate,
    String? errorMessage,
  }) : super(
          errorMessage:
              errorMessage ?? _getDefaultErrorMessage(minDate, maxDate),
        );

  static String _getDefaultErrorMessage(DateTime? minDate, DateTime? maxDate) {
    if (minDate != null && maxDate != null) {
      return 'Date must be between ${_formatDate(minDate)} and ${_formatDate(maxDate)}';
    } else if (minDate != null) {
      return 'Date must be on or after ${_formatDate(minDate)}';
    } else if (maxDate != null) {
      return 'Date must be on or before ${_formatDate(maxDate)}';
    } else {
      return 'Invalid date';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  ValidationResult validate(DateTime? value) {
    if (value == null) {
      return const ValidationResult.success();
    }

    if (minDate != null && value.isBefore(minDate!)) {
      return ValidationResult.error(errorMessage);
    }

    if (maxDate != null && value.isAfter(maxDate!)) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
