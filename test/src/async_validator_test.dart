import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

class MockAsyncValidationRule<T> extends AsyncValidationRule<T> {
  final bool shouldPass;
  final Duration delay;

  const MockAsyncValidationRule({
    required this.shouldPass,
    this.delay = const Duration(milliseconds: 100),
    required super.errorMessage,
  });

  @override
  Future<ValidationResult> validateAsync(T? value) async {
    await Future.delayed(delay);
    if (shouldPass) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}

void main() {
  group('AsyncValidator', () {
    test(
        'constructor creates a validator with the provided rules and debounce duration',
        () {
      final rule = MockAsyncValidationRule<String>(
          shouldPass: true, errorMessage: 'Error');

      final validator = AsyncValidator<String>(
        [rule],
        debounceDuration: const Duration(milliseconds: 200),
      );

      expect(validator.errorMessage, null);
      expect(validator.isValidating, false);
      expect(validator.isValid, false);
    });

    test('addRule returns a new validator with the additional rule', () {
      final rule1 = MockAsyncValidationRule<String>(
          shouldPass: true, errorMessage: 'Error 1');
      final rule2 = MockAsyncValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 2');

      final validator1 = AsyncValidator<String>([rule1]);
      final validator2 = validator1.addRule(rule2);

      // Validators should be different instances
      expect(validator1 != validator2, true);
    });

    test('validate triggers async validation only for new values', () async {
      final rule = MockAsyncValidationRule<String>(
          shouldPass: false, errorMessage: 'Error', delay: Duration.zero);

      final validator =
          AsyncValidator<String>([rule], debounceDuration: Duration.zero);

      // First validation
      validator.validate('test');

      // Wait for async validation
      await Future.delayed(const Duration(milliseconds: 50));
      expect(validator.isValid, false);
      expect(validator.errorMessage, 'Error');

      // Reset for next test
      validator.reset();
      expect(validator.errorMessage, null);

      // Same value shouldn't trigger validation again
      validator.validate('test');
      expect(validator.isValidating, false);

      // New value should trigger validation
      validator.validate('different');
      expect(validator.isValidating, true);
    });

    test('validateAsync returns result of async validation', () async {
      final rule = MockAsyncValidationRule<String>(
          shouldPass: true, errorMessage: 'Error');

      final validator = AsyncValidator<String>([rule]);

      final result = await validator.validateAsync('test');
      expect(result, true);
      expect(validator.isValid, true);

      final validator2 = AsyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: false, errorMessage: 'Failed')
      ]);

      final result2 = await validator2.validateAsync('test');
      expect(result2, false);
      expect(validator2.isValid, false);
      expect(validator2.errorMessage, 'Failed');
    });

    test('dispose cancels debounce timer', () {
      final rule = MockAsyncValidationRule<String>(
          shouldPass: true, errorMessage: 'Error');

      final validator = AsyncValidator<String>([rule]);

      // Start a validation that would be debounced
      validator.validate('test');

      // Dispose should cancel timer
      validator.dispose();

      // No exception should be thrown
      expect(() => validator.dispose(), returnsNormally);
    });

    group('AsyncValidator creation', () {
      test('constructor creates a string async validator', () {
        final rule = MockAsyncValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final validator = AsyncValidator<String>([rule]);

        expect(validator, isA<AsyncValidator<String>>());
      });

      test('constructor creates a number async validator', () {
        final rule = MockAsyncValidationRule<num>(
            shouldPass: false, errorMessage: 'Error');

        final validator = AsyncValidator<num>([rule]);

        expect(validator, isA<AsyncValidator<num>>());
      });

      test('constructor creates a boolean async validator', () {
        final rule = MockAsyncValidationRule<bool>(
            shouldPass: false, errorMessage: 'Error');

        final validator = AsyncValidator<bool>([rule]);

        expect(validator, isA<AsyncValidator<bool>>());
      });

      test('constructor creates a date async validator (string input)', () {
        final rule = MockAsyncValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final validator = AsyncValidator<String>([rule]);

        expect(validator, isA<AsyncValidator<String>>());
      });
    });
  });
}
