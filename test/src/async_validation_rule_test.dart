import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

class TestAsyncValidationRule extends AsyncValidationRule<String> {
  final bool shouldPass;
  final bool shouldThrowError;
  final Duration delay;

  const TestAsyncValidationRule({
    required this.shouldPass,
    this.shouldThrowError = false,
    this.delay = const Duration(milliseconds: 100),
    required super.errorMessage,
  });

  @override
  Future<ValidationResult> validateAsync(String? value) async {
    await Future.delayed(delay);

    if (shouldThrowError) {
      throw Exception('Test validation error');
    }

    if (shouldPass) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}

void main() {
  group('AsyncValidationRule', () {
    const errorMessage = 'Test error message';

    test('constructor sets error message correctly', () {
      final rule = TestAsyncValidationRule(
        shouldPass: true,
        errorMessage: errorMessage,
      );

      expect(rule.errorMessage, errorMessage);
    });

    test('validate returns success by default for sync validation', () {
      final rule = TestAsyncValidationRule(
        shouldPass: false, // Even with shouldPass=false
        errorMessage: errorMessage,
      );

      final result = rule.validate('test');

      // Sync validation should always pass for AsyncValidationRule
      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test('validateAsync returns success result when validation passes',
        () async {
      final rule = TestAsyncValidationRule(
        shouldPass: true,
        errorMessage: errorMessage,
      );

      final result = await rule.validateAsync('test');

      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test(
        'validateAsync returns error result with correct message when validation fails',
        () async {
      final rule = TestAsyncValidationRule(
        shouldPass: false,
        errorMessage: errorMessage,
      );

      final result = await rule.validateAsync('test');

      expect(result.isValid, false);
      expect(result.errorMessage, errorMessage);
    });

    test('validateAsync propagates exceptions', () async {
      final rule = TestAsyncValidationRule(
        shouldPass: true,
        shouldThrowError: true,
        errorMessage: errorMessage,
      );

      expect(() => rule.validateAsync('test'), throwsException);
    });
  });
}
