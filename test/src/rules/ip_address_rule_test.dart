import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('IPAddressRule', () {
    const defaultErrorMessage = 'Please enter a valid IP address';
    const customErrorMessage = 'Custom error message';

    test('constructor sets default error message when not provided', () {
      final rule = IPAddressRule();
      expect(rule.errorMessage, defaultErrorMessage);
    });

    test('constructor sets custom error message when provided', () {
      final rule = IPAddressRule(errorMessage: customErrorMessage);
      expect(rule.errorMessage, customErrorMessage);
    });

    test(
        'constructor throws assertion error when both IP versions are disallowed',
        () {
      expect(
        () => IPAddressRule(allowIPv4: false, allowIPv6: false),
        throwsA(isA<AssertionError>()),
      );
    });

    group('validate', () {
      test('returns success for null value', () {
        final rule = IPAddressRule();
        final result = rule.validate(null);

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns success for empty string', () {
        final rule = IPAddressRule();
        final result = rule.validate('');

        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('returns error for invalid IP format', () {
        final rule = IPAddressRule();
        final invalidIPs = [
          'not an ip',
          '256.256.256.256',
          '192.168.1',
          '192.168.1.1.1',
          '::fg',
          '2001:0db8:85a3:0000:0000:8a2e:0370:7334:3030',
        ];

        for (final ip in invalidIPs) {
          final result = rule.validate(ip);
          expect(result.isValid, false, reason: 'IP "$ip" should be invalid');
          expect(
              result.errorMessage, 'Please enter a valid IPv4 or IPv6 address');
        }
      });

      test('validates IPv4 addresses when allowed', () {
        final rule = IPAddressRule(allowIPv4: true, allowIPv6: false);
        final validIPv4s = [
          '192.168.1.1',
          '10.0.0.1',
          '172.16.0.1',
          '127.0.0.1',
          '0.0.0.0',
          '255.255.255.255',
        ];

        for (final ip in validIPv4s) {
          final result = rule.validate(ip);
          expect(result.isValid, true, reason: 'IPv4 "$ip" should be valid');
          expect(result.errorMessage, null);
        }

        // IPv6 should be rejected
        final result = rule.validate('2001:0db8:85a3:0000:0000:8a2e:0370:7334');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Please enter a valid IPv4 address');
      });

      test('validates IPv6 addresses when allowed', () {
        final rule = IPAddressRule(allowIPv4: false, allowIPv6: true);
        final validIPv6s = [
          '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
          '2001:db8:85a3:0:0:8a2e:370:7334',
          '2001:db8:85a3::8a2e:370:7334',
          '::1',
          '::',
          'fe80::1ff:fe23:4567:890a',
        ];

        for (final ip in validIPv6s) {
          final result = rule.validate(ip);
          expect(result.isValid, true, reason: 'IPv6 "$ip" should be valid');
          expect(result.errorMessage, null);
        }

        // IPv4 should be rejected
        final result = rule.validate('192.168.1.1');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Please enter a valid IPv6 address');
      });

      test('validates both IPv4 and IPv6 addresses when both are allowed', () {
        final rule = IPAddressRule(allowIPv4: true, allowIPv6: true);

        // Valid IPv4
        expect(rule.validate('192.168.1.1').isValid, true);

        // Valid IPv6
        expect(rule.validate('2001:db8:85a3::8a2e:370:7334').isValid, true);
      });
    });
  });
}
