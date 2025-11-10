import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a date range between two text fields is valid.
///
/// This rule operates on `String?` values and parses both start and end
/// dates using `DateTime.tryParse`. If either date is empty or fails to
/// parse, the rule returns success (use `DateRule` to enforce validity).
class DateRangeRule extends ValidationRule<String> {
  /// The field containing the start date text to compare against.
  final String? Function() getStartDate;

  /// Creates a date range validation rule that ensures the end date (value)
  /// is after the start date.
  DateRangeRule({
    required this.getStartDate,
    super.errorMessage = 'End date must be after start date',
  });

  @override
  ValidationResult validate(String? value) {
    final startText = getStartDate();
    final endText = value;

    // If either date is empty, we don't validate the range here
    if (startText == null ||
        startText.trim().isEmpty ||
        endText == null ||
        endText.trim().isEmpty) {
      return const ValidationResult.success();
    }

    final startDate = DateTime.tryParse(startText.trim());
    final endDate = DateTime.tryParse(endText.trim());

    // If parsing fails for either, let DateRule handle validity
    if (startDate == null || endDate == null) {
      return const ValidationResult.success();
    }

    // Check if end date is on or after start date
    if (endDate.isBefore(startDate)) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
