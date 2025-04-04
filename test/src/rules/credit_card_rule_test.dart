import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('CreditCardRule', () {
    const defaultErrorMessage = 'Please enter a valid credit card number';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = CreditCardRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = CreditCardRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = CreditCardRule();
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for empty string', () {
        final rule = CreditCardRule();
        final result = rule.validate('');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error for non-numeric input', () {
        final rule = CreditCardRule();
        final result = rule.validate('abcd1234efgh5678');

        expect(result.isValid, false);
        expect(result.errorMessage, defaultErrorMessage);
      });

      test('returns error for invalid length', () {
        final rule = CreditCardRule();

        // Too short
        final shortResult = rule.validate('1234567890123');
        expect(shortResult.isValid, false);
        expect(shortResult.errorMessage, defaultErrorMessage);

        // Too long
        final longResult = rule.validate('12345678901234567890');
        expect(longResult.isValid, false);
        expect(longResult.errorMessage, defaultErrorMessage);
      });

      test('validates with Luhn algorithm', () {
        final rule = CreditCardRule();

        // Valid credit card numbers that pass Luhn check
        final validCards = [
          '4111111111111111', // Visa
          '5500000000000004', // MasterCard
          '340000000000009', // American Express
          '6011000000000004', // Discover
          '3088000000000009', // JCB
        ];

        for (final card in validCards) {
          final result = rule.validate(card);
          expect(result.isValid, true, reason: 'Card "$card" should be valid');
          expect(result.errorMessage, null);
        }

        // Invalid numbers that fail Luhn check
        final invalidCards = [
          '4111111111111112', // Last digit changed
          '5500000000000005', // Last digit changed
          '340000000000001', // Last digit changed
        ];

        for (final card in invalidCards) {
          final result = rule.validate(card);
          expect(result.isValid, false,
              reason: 'Card "$card" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });

      test('handles spaces when allowed', () {
        final rule = CreditCardRule(allowSpaces: true);

        // Valid with spaces
        final resultWithSpaces = rule.validate('4111 1111 1111 1111');
        expect(resultWithSpaces.isValid, true);

        // Valid without spaces
        final resultWithoutSpaces = rule.validate('4111111111111111');
        expect(resultWithoutSpaces.isValid, true);
      });

      test('rejects spaces when not allowed', () {
        final rule = CreditCardRule(allowSpaces: false);

        // Invalid with spaces
        final resultWithSpaces = rule.validate('4111 1111 1111 1111');
        expect(resultWithSpaces.isValid, false);

        // Valid without spaces
        final resultWithoutSpaces = rule.validate('4111111111111111');
        expect(resultWithoutSpaces.isValid, true);
      });

      test('handles hyphens when allowed', () {
        final rule = CreditCardRule(allowHyphens: true);

        // Valid with hyphens
        final resultWithHyphens = rule.validate('4111-1111-1111-1111');
        expect(resultWithHyphens.isValid, true);

        // Valid without hyphens
        final resultWithoutHyphens = rule.validate('4111111111111111');
        expect(resultWithoutHyphens.isValid, true);
      });

      test('rejects hyphens when not allowed', () {
        final rule = CreditCardRule(allowHyphens: false);

        // Invalid with hyphens
        final resultWithHyphens = rule.validate('4111-1111-1111-1111');
        expect(resultWithHyphens.isValid, false);

        // Valid without hyphens
        final resultWithoutHyphens = rule.validate('4111111111111111');
        expect(resultWithoutHyphens.isValid, true);
      });
    });
  });
}
