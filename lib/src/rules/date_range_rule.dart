import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a date range between two fields is valid.
class DateRangeRule extends ValidationRule<DateTime> {
  /// The field containing the start date to compare against.
  final DateTime? Function() getStartDate;

  /// Creates a date range validation rule that ensures the end date (value)
  /// is after the start date.
  DateRangeRule({
    required this.getStartDate,
    super.errorMessage = 'End date must be after start date',
  });

  @override
  ValidationResult validate(DateTime? value) {
    // If either date is null, we can't validate the range
    final startDate = getStartDate();
    if (startDate == null || value == null) {
      return const ValidationResult.success();
    }

    // Check if end date is on or after start date
    if (value.isBefore(startDate)) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
