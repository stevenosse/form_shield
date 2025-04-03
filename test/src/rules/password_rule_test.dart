import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('PasswordOptions', () {
    test('constructor sets default values correctly', () {
      const options = PasswordOptions();

      expect(options.minLength, 8);
      expect(options.requireUppercase, true);
      expect(options.requireLowercase, true);
      expect(options.requireDigit, true);
      expect(options.requireSpecialChar, true);
    });

    test('constructor sets custom values correctly', () {
      const options = PasswordOptions(
        minLength: 10,
        requireUppercase: false,
        requireLowercase: false,
        requireDigit: false,
        requireSpecialChar: false,
      );

      expect(options.minLength, 10);
      expect(options.requireUppercase, false);
      expect(options.requireLowercase, false);
      expect(options.requireDigit, false);
      expect(options.requireSpecialChar, false);
    });
  });

  group('PasswordRule', () {
    const defaultErrorMessage = 'Password does not meet requirements';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = PasswordRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = PasswordRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    test('constructor sets default options when not provided', () {
      final rule = PasswordRule();
      expect(rule.options.minLength, 8);
      expect(rule.options.requireUppercase, true);
      expect(rule.options.requireLowercase, true);
      expect(rule.options.requireDigit, true);
      expect(rule.options.requireSpecialChar, true);
    });

    test('constructor sets custom options when provided', () {
      const options = PasswordOptions(
        minLength: 10,
        requireUppercase: false,
        requireLowercase: true,
        requireDigit: false,
        requireSpecialChar: true,
      );

      final rule = PasswordRule(options: options);

      expect(rule.options.minLength, 10);
      expect(rule.options.requireUppercase, false);
      expect(rule.options.requireLowercase, true);
      expect(rule.options.requireDigit, false);
      expect(rule.options.requireSpecialChar, true);
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = PasswordRule();
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for empty string', () {
        final rule = PasswordRule();
        final result = rule.validate('');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error when password is too short', () {
        final rule = PasswordRule(options: const PasswordOptions(minLength: 8));
        final result = rule.validate('Abc1!');

        expect(result.isValid, false);
        expect(result.errorMessage, contains('at least 8 characters'));
      });

      test('returns error when password has no uppercase letter', () {
        final rule = PasswordRule(
            options: const PasswordOptions(
          minLength: 5,
          requireUppercase: true,
        ));
        final result = rule.validate('abcde1!');

        expect(result.isValid, false);
        expect(result.errorMessage, contains('uppercase letter'));
      });

      test('returns error when password has no lowercase letter', () {
        final rule = PasswordRule(
            options: const PasswordOptions(
          minLength: 5,
          requireLowercase: true,
          requireUppercase: false,
          requireDigit: false,
          requireSpecialChar: false,
        ));
        final result = rule.validate('ABCDE');

        expect(result.isValid, false);
        expect(result.errorMessage, contains('lowercase letter'));
      });

      test('returns error when password has no digit', () {
        final rule = PasswordRule(
            options: const PasswordOptions(
          minLength: 5,
          requireDigit: true,
          requireUppercase: false,
          requireLowercase: false,
          requireSpecialChar: false,
        ));
        final result = rule.validate('abcde');

        expect(result.isValid, false);
        expect(result.errorMessage, contains('digit'));
      });

      test('returns error when password has no special character', () {
        final rule = PasswordRule(
            options: const PasswordOptions(
          minLength: 5,
          requireSpecialChar: true,
          requireUppercase: false,
          requireLowercase: false,
          requireDigit: false,
        ));
        final result = rule.validate('abcde');

        expect(result.isValid, false);
        expect(result.errorMessage, contains('special character'));
      });

      test('returns success when password meets all requirements', () {
        final rule = PasswordRule();
        final result = rule.validate('Abcdef1!');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success when password meets custom requirements', () {
        final rule = PasswordRule(
            options: const PasswordOptions(
          minLength: 5,
          requireUppercase: false,
          requireLowercase: true,
          requireDigit: true,
          requireSpecialChar: false,
        ));
        final result = rule.validate('abc123');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
    });
  });
}
