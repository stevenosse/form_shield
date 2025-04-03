import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('RequiredRule', () {
    const defaultErrorMessage = 'This field is required';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = RequiredRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = RequiredRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    group('validate', () {
      test('returns error for null value', () {
        final rule = RequiredRule();
        final result = rule.validate(null);

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for empty string', () {
        final rule = RequiredRule();
        final result = rule.validate('');

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for whitespace string', () {
        final rule = RequiredRule();
        final result = rule.validate('   ');

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for empty list', () {
        final rule = RequiredRule<List<String>>();
        final result = rule.validate([]);

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for empty map', () {
        final rule = RequiredRule<Map<String, dynamic>>();
        final result = rule.validate({});

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns success for non-empty string', () {
        final rule = RequiredRule();
        final result = rule.validate('test');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for non-empty list', () {
        final rule = RequiredRule<List<String>>();
        final result = rule.validate(['test']);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for non-empty map', () {
        final rule = RequiredRule<Map<String, dynamic>>();
        final result = rule.validate({'key': 'value'});

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
    });
  });
}
