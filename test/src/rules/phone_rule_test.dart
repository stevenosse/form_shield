import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('PhoneRule', () {
    const defaultErrorMessage = 'Please enter a valid phone number';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = PhoneRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = PhoneRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    group('validate', () {
      test('returns error for null value', () {
        final rule = PhoneRule();
        final result = rule.validate(null);

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for empty string', () {
        final rule = PhoneRule();
        final result = rule.validate('');

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for invalid phone numbers', () {
        final rule = PhoneRule();
        final invalidPhones = [
          'abc',
          '12',
          '1234',
          'abc123456789',
          '+1234abcdefg',
        ];

        for (final phone in invalidPhones) {
          final result = rule.validate(phone);
          expect(result.isValid, false, reason: 'Phone "$phone" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });

      test('returns success for valid phone numbers', () {
        final rule = PhoneRule();
        final validPhones = [
          '1234567890',
          '+1234567890',
          '+12345678901',
          '123-456-7890',
          '123 456 7890',
          '+1 123 456 7890',
        ];

        for (final phone in validPhones) {
          final result = rule.validate(phone);
          expect(result.isValid, true, reason: 'Phone "$phone" should be valid');
          expect(result.errorMessage, null);
        }
      });

      test('validates with custom regex pattern', () {
        // Custom pattern that only allows US format (XXX) XXX-XXXX
        final rule = PhoneRule(pattern: r'^\(\d{3}\) \d{3}-\d{4}$');

        expect(rule.validate('(123) 456-7890').isValid, true);
        expect(rule.validate('123-456-7890').isValid, false);
        expect(rule.validate('1234567890').isValid, false);
      });

      test('accepts valid US/Canadian phone numbers', () {
        final rule = PhoneRule();
        final validPhones = [
          '4164343333',
          '(416) 434-3333',
          '(416) 434-33-33',
          '416-434-3333',
          '416.434.3333',
          '416 434 3333',
          '+1 416 434 3333',
          '+1 (416) 434-3333',
        ];

        for (final phone in validPhones) {
          final result = rule.validate(phone);
          expect(result.isValid, true, reason: 'Phone "$phone" should be valid');
        }
      });

      test('rejects invalid US/Canadian phone numbers', () {
        final rule = PhoneRule();
        final invalidPhones = [
          '123', // too short
          '416', // too short
          '416-43', // incomplete
          '(416 434-3333', // unbalanced parentheses
          '416) 434-3333', // unbalanced parentheses
          '++1 416 434 3333', // malformed country code
          '1 (416) 434-3333', // missing + for country code
          'abc-416-434', // letters present
        ];

        for (final phone in invalidPhones) {
          final result = rule.validate(phone);
          expect(result.isValid, false, reason: 'Phone "$phone" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });
    });
  });
}
