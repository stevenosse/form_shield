import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('ValueRule', () {
    group('constructor', () {
      test('sets default error message when not provided', () {
        final rule = ValueRule(minValue: 5, maxValue: 10);
        expect(rule.errorMessage, 'Must be between 5 and 10');

        final minRule = ValueRule(minValue: 5);
        expect(minRule.errorMessage, 'Must be at least 5');

        final maxRule = ValueRule(maxValue: 10);
        expect(maxRule.errorMessage, 'Must be at most 10');

        final noLimitsRule = ValueRule();
        expect(noLimitsRule.errorMessage, 'Invalid value');
      });

      test('sets custom error message when provided', () {
        const customMessage = 'Custom error message';
        final rule = ValueRule(
          minValue: 5,
          maxValue: 10,
          errorMessage: customMessage,
        );

        expect(rule.errorMessage, customMessage);
      });
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = ValueRule(minValue: 5, maxValue: 10);
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error when value is less than minValue', () {
        final rule = ValueRule(minValue: 5);
        final result = rule.validate(3);

        expect(result.isValid, false);
        expect(result.errorMessage, 'Must be at least 5');
      });

      test('returns error when value is greater than maxValue', () {
        final rule = ValueRule(maxValue: 5);
        final result = rule.validate(7);

        expect(result.isValid, false);
        expect(result.errorMessage, 'Must be at most 5');
      });

      test('returns error when value is outside both bounds', () {
        final rule = ValueRule(minValue: 5, maxValue: 10);

        final tooSmallResult = rule.validate(3);
        expect(tooSmallResult.isValid, false);
        expect(tooSmallResult.errorMessage, 'Must be between 5 and 10');

        final tooLargeResult = rule.validate(13);
        expect(tooLargeResult.isValid, false);
        expect(tooLargeResult.errorMessage, 'Must be between 5 and 10');
      });

      test('returns success when value is within bounds', () {
        final rule = ValueRule(minValue: 5, maxValue: 10);

        final atMinResult = rule.validate(5);
        expect(atMinResult.isValid, true);
        expect(atMinResult.errorMessage, null);

        final atMaxResult = rule.validate(10);
        expect(atMaxResult.isValid, true);
        expect(atMaxResult.errorMessage, null);

        final inBetweenResult = rule.validate(7);
        expect(inBetweenResult.isValid, true);
        expect(inBetweenResult.errorMessage, null);
      });

      test('works with decimal values', () {
        final rule = ValueRule(minValue: 5.5, maxValue: 10.5);

        expect(rule.validate(5.4).isValid, false);
        expect(rule.validate(5.5).isValid, true);
        expect(rule.validate(7.8).isValid, true);
        expect(rule.validate(10.5).isValid, true);
        expect(rule.validate(10.6).isValid, false);
      });
    });
  });

  group('MinValueRule', () {
    test('constructor creates a ValueRule with only minValue set', () {
      final rule = MinValueRule(5);

      expect(rule.minValue, 5);
      expect(rule.maxValue, null);
      expect(rule.errorMessage, 'Must be at least 5');
    });

    test('constructor sets custom error message when provided', () {
      const customMessage = 'Custom error message';
      final rule = MinValueRule(5, errorMessage: customMessage);

      expect(rule.errorMessage, customMessage);
    });

    test('validate works correctly', () {
      final rule = MinValueRule(5);

      expect(rule.validate(null).isValid, true);
      expect(rule.validate(3).isValid, false);
      expect(rule.validate(5).isValid, true);
      expect(rule.validate(7).isValid, true);
    });
  });

  group('MaxValueRule', () {
    test('constructor creates a ValueRule with only maxValue set', () {
      final rule = MaxValueRule(10);

      expect(rule.minValue, null);
      expect(rule.maxValue, 10);
      expect(rule.errorMessage, 'Must be at most 10');
    });

    test('constructor sets custom error message when provided', () {
      const customMessage = 'Custom error message';
      final rule = MaxValueRule(10, errorMessage: customMessage);

      expect(rule.errorMessage, customMessage);
    });

    test('validate works correctly', () {
      final rule = MaxValueRule(10);

      expect(rule.validate(null).isValid, true);
      expect(rule.validate(7).isValid, true);
      expect(rule.validate(10).isValid, true);
      expect(rule.validate(13).isValid, false);
    });
  });

  group('FormInputValueRule', () {
    group('constructor', () {
      test('creates a ValueRule with only minValue set', () {
        final rule = FormInputMinValueRule(
          minValue: 5,
          convert: (value) => num.parse(value),
        );

        expect(rule.minValue, 5);
        expect(rule.maxValue, null);
        expect(rule.errorMessage, 'Value must be at least 5');
      });

      test('creates a ValueRule with only maxValue set', () {
        final rule = FormInputMaxValueRule(
          maxValue: 10,
          convert: (value) => num.parse(value),
        );

        expect(rule.minValue, null);
        expect(rule.maxValue, 10);
        expect(rule.errorMessage, 'Value must be at most 10');
      });

      test('creates a ValueRule with both minValue and maxValue set', () {
        final rule = FormInputValueRule(
          minValue: 5,
          maxValue: 10,
          convert: (value) => num.parse(value),
          errorMessage: 'Value must be between 5 and 10',
        );

        expect(rule.minValue, 5);
        expect(rule.maxValue, 10);
        expect(rule.errorMessage, 'Value must be between 5 and 10');
      });

      test('constructor sets custom error message when provided', () {
        const customMessage = 'Custom error message';
        final rule = FormInputValueRule(
          minValue: 5,
          maxValue: 10,
          convert: (value) => num.parse(value),
          errorMessage: customMessage,
        );

        expect(rule.errorMessage, customMessage);
      });
    });
  });
}
