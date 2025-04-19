import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

class TestValidationRule extends ValidationRule<String> {
  final bool shouldPass;

  const TestValidationRule({
    required this.shouldPass,
    required super.errorMessage,
  });

  @override
  ValidationResult validate(String? value) {
    if (shouldPass) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}

void main() {
  group('ValidationRule', () {
    const errorMessage = 'Test error message';

    test('constructor sets error message correctly', () {
      final rule = TestValidationRule(
        shouldPass: true,
        errorMessage: errorMessage,
      );

      expect(rule.errorMessage, errorMessage);
    });

    test('validate returns success result when validation passes', () {
      final rule = TestValidationRule(
        shouldPass: true,
        errorMessage: errorMessage,
      );

      final result = rule.validate('test');

      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test(
        'validate returns error result with correct message when validation fails',
        () {
      final rule = TestValidationRule(
        shouldPass: false,
        errorMessage: errorMessage,
      );

      final result = rule.validate('test');

      expect(result.isValid, false);
      expect(result.errorMessage, errorMessage);
    });

    test('async validate returns success result when validation passes',
        () async {
      final rule = TestValidationRule(
        shouldPass: true,
        errorMessage: errorMessage,
      );

      final result = await rule.validateAsync('test');

      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test(
        'async validate returns error result with correct message when validation fails',
        () async {
      final rule = TestValidationRule(
        shouldPass: false,
        errorMessage: errorMessage,
      );

      final result = await rule.validateAsync('test');

      expect(result.isValid, false);
      expect(result.errorMessage, errorMessage);
    });
  });
}
