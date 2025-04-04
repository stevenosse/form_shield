import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('URLRule', () {
    const defaultErrorMessage = 'Please enter a valid URL';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = URLRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = URLRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = URLRule();
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for empty string', () {
        final rule = URLRule();
        final result = rule.validate('');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error for invalid URL format', () {
        final rule = URLRule();
        final invalidURLs = [
          'not a url',
          'http://',
          'http://.',
          'http://.com',
          'http://example.',
          'example.com/path with spaces',
        ];

        for (final url in invalidURLs) {
          final result = rule.validate(url);
          expect(result.isValid, false, reason: 'URL "$url" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });

      test('returns success for valid URLs with protocol', () {
        final rule = URLRule();
        final validURLs = [
          'http://example.com',
          'https://example.com',
          'https://www.example.com',
          'https://example.com/path',
          'https://example.com/path?query=value',
          'https://example.com:8080',
          'https://user:password@example.com',
          'ftp://example.com',
        ];

        for (final url in validURLs) {
          final result = rule.validate(url);
          expect(result.isValid, true, reason: 'URL "$url" should be valid');
          expect(result.errorMessage, null);
        }
      });

      test('validates URLs without protocol when requireProtocol is false', () {
        final rule = URLRule(requireProtocol: false);
        final validURLs = [
          'example.com',
          'www.example.com',
          'example.com/path',
          'example.com:8080',
        ];

        for (final url in validURLs) {
          final result = rule.validate(url);
          expect(result.isValid, true, reason: 'URL "$url" should be valid');
          expect(result.errorMessage, null);
        }
      });

      test('rejects URLs without protocol when requireProtocol is true', () {
        final rule = URLRule(requireProtocol: true);
        final invalidURLs = [
          'example.com',
          'www.example.com',
        ];

        for (final url in invalidURLs) {
          final result = rule.validate(url);
          expect(result.isValid, false, reason: 'URL "$url" should be invalid');
          expect(result.errorMessage, defaultErrorMessage);
        }
      });

      test('validates URLs with allowed protocols', () {
        final rule = URLRule(allowedProtocols: ['https', 'ftp']);

        // Valid URLs with allowed protocols
        expect(rule.validate('https://example.com').isValid, true);
        expect(rule.validate('ftp://example.com').isValid, true);

        // Invalid URLs with disallowed protocols
        final result = rule.validate('http://example.com');
        expect(result.isValid, false);
        expect(result.errorMessage,
            'URL must use one of the following protocols: https, ftp');
      });
    });
  });
}
