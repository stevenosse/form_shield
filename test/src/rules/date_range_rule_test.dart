import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('DateRangeRule', () {
    group('constructor', () {
      test('sets default error message when not provided', () {
        final rule = DateRangeRule(getStartDate: () => DateTime(2023, 1, 1));
        expect(rule.errorMessage, 'End date must be after start date');
      });

      test('sets custom error message when provided', () {
        const customMessage = 'Custom error message';
        final rule = DateRangeRule(
          getStartDate: () => DateTime(2023, 1, 1),
          errorMessage: customMessage,
        );

        expect(rule.errorMessage, customMessage);
      });
    });

    group('validate', () {
      test('returns success when both dates are null', () {
        final rule = DateRangeRule(getStartDate: () => null);
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success when start date is null', () {
        final rule = DateRangeRule(getStartDate: () => null);
        final result = rule.validate(DateTime(2023, 1, 15));

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success when end date is null', () {
        final rule = DateRangeRule(getStartDate: () => DateTime(2023, 1, 1));
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error when end date is before start date', () {
        final startDate = DateTime(2023, 1, 15);
        final rule = DateRangeRule(getStartDate: () => startDate);
        final result = rule.validate(DateTime(2023, 1, 1));

        expect(result.isValid, false);
        expect(result.errorMessage, 'End date must be after start date');
      });

      test('returns success when end date is same as start date', () {
        final startDate = DateTime(2023, 1, 15);
        final rule = DateRangeRule(getStartDate: () => startDate);
        final result = rule.validate(DateTime(2023, 1, 15));

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success when end date is after start date', () {
        final startDate = DateTime(2023, 1, 1);
        final rule = DateRangeRule(getStartDate: () => startDate);
        final result = rule.validate(DateTime(2023, 1, 15));

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
    });
  });
}
