import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('DateRule', () {
    group('constructor', () {
      test('sets default error message when not provided', () {
        final minDate = DateTime(2023, 1, 1);
        final maxDate = DateTime(2023, 12, 31);

        final rule = DateRule(minDate: minDate, maxDate: maxDate);
        expect(rule.errorMessage,
            'Date must be between 2023-01-01 and 2023-12-31');

        final minRule = DateRule(minDate: minDate);
        expect(minRule.errorMessage, 'Date must be on or after 2023-01-01');

        final maxRule = DateRule(maxDate: maxDate);
        expect(maxRule.errorMessage, 'Date must be on or before 2023-12-31');

        final noLimitsRule = DateRule();
        expect(noLimitsRule.errorMessage, 'Invalid date');
      });

      test('sets custom error message when provided', () {
        const customMessage = 'Custom error message';
        final rule = DateRule(
          minDate: DateTime(2023, 1, 1),
          maxDate: DateTime(2023, 12, 31),
          errorMessage: customMessage,
        );

        expect(rule.errorMessage, customMessage);
      });
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = DateRule(
          minDate: DateTime(2023, 1, 1),
          maxDate: DateTime(2023, 12, 31),
        );
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error when date is before minDate', () {
        final minDate = DateTime(2023, 1, 1);
        final rule = DateRule(minDate: minDate);
        final result = rule.validate('2022-12-31');

        expect(result.isValid, false);
        expect(result.errorMessage, 'Date must be on or after 2023-01-01');
      });

      test('returns error when date is after maxDate', () {
        final maxDate = DateTime(2023, 12, 31);
        final rule = DateRule(maxDate: maxDate);
        final result = rule.validate('2024-01-01');

        expect(result.isValid, false);
        expect(result.errorMessage, 'Date must be on or before 2023-12-31');
      });

      test('returns error when date is outside range', () {
        final rule = DateRule(
          minDate: DateTime(2023, 1, 1),
          maxDate: DateTime(2023, 12, 31),
        );
        final resultBefore = rule.validate('2022-12-31');
        expect(resultBefore.isValid, false);
        expect(resultBefore.errorMessage,
            'Date must be between 2023-01-01 and 2023-12-31');

        final resultAfter = rule.validate('2024-01-01');
        expect(resultAfter.isValid, false);
        expect(resultAfter.errorMessage,
            'Date must be between 2023-01-01 and 2023-12-31');
      });

      test('returns success when date is within range', () {
        final rule = DateRule(
          minDate: DateTime(2023, 1, 1),
          maxDate: DateTime(2023, 12, 31),
        );

        final resultMin = rule.validate('2023-01-01');
        expect(resultMin.isValid, true);
        expect(resultMin.errorMessage, null);

        final resultMiddle = rule.validate('2023-06-15');
        expect(resultMiddle.isValid, true);
        expect(resultMiddle.errorMessage, null);

        final resultMax = rule.validate('2023-12-31');
        expect(resultMax.isValid, true);
        expect(resultMax.errorMessage, null);
      });

      test('returns success when no limits are set', () {
        final rule = DateRule();
        final result = rule.validate('2023-06-15');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
    });
  });
}
