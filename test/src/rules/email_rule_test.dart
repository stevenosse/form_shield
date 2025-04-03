import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('EmailRule', () {
    const defaultErrorMessage = 'Please enter a valid email address';
    const customErrorMessage = 'Custom error message';
    
    test('constructor sets default error message when not provided', () {
      final rule = EmailRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });
    
    test('constructor sets custom error message when provided', () {
      final rule = EmailRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });
    
    group('validate', () {
      test('returns success for null value', () {
        final rule = EmailRule();
        final result = rule.validate(null);
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns success for empty string', () {
        final rule = EmailRule();
        final result = rule.validate('');
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns error for invalid email format', () {
        final rule = EmailRule();
        final invalidEmails = [
          'plainaddress',
          '#@%^%#\$@#\$@#.com',
          '@example.com',
          'Joe Smith <email@example.com>',
          'email.example.com',
          'email@example@example.com',
          'email@example.com (Joe Smith)',
          'email@example..com',
        ];
        
        for (final email in invalidEmails) {
          final result = rule.validate(email);
          expect(result.isValid, false, reason: 'Email "$email" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });
      
      test('returns success for valid email format', () {
        final rule = EmailRule();
        final validEmails = [
          'email@example.com',
          'firstname.lastname@example.com',
          'email@subdomain.example.com',
          'firstname+lastname@example.com',
          'email@123.123.123.123',
          '1234567890@example.com',
          'email@example-one.com',
          '_______@example.com',
          'email@example.name',
          'email@example.museum',
          'email@example.co.jp',
        ];
        
        for (final email in validEmails) {
          final result = rule.validate(email);
          expect(result.isValid, true, reason: 'Email "$email" should be valid');
          expect(result.errorMessage, null);
        }
      });
      
      test('validates with custom regex pattern', () {
        // Custom pattern that only allows gmail addresses
        final rule = EmailRule(pattern: r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
        
        expect(rule.validate('test@gmail.com').isValid, true);
        expect(rule.validate('test@example.com').isValid, false);
      });
    });
  });
}