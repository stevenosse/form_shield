import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

class MockValidationRule<T> extends ValidationRule<T> {
  final bool shouldPass;

  const MockValidationRule({
    required this.shouldPass,
    required super.errorMessage,
  });

  @override
  ValidationResult validate(T? value) {
    if (shouldPass) {
      return const ValidationResult.success();
    } else {
      return ValidationResult.error(errorMessage);
    }
  }
}

void main() {
  group('Validator', () {
    test('constructor creates a validator with the provided rules', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 2');

      final validator = Validator<String>([rule1, rule2]);

      // Validator is working correctly if it validates without errors
      expect(validator('test'), null);
    });

    test('addRule returns a new validator with the additional rule', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 2');

      final validator1 = Validator<String>([rule1]);
      final validator2 = validator1.addRule(rule2);

      // Original validator should still pass
      expect(validator1('test'), null);
      // New validator should fail with the second rule's error message
      expect(validator2('test'), 'Error 2');
    });

    test('call returns null when all rules pass', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 2');

      final validator = Validator<String>([rule1, rule2]);

      expect(validator('test'), null);
    });

    test('call returns the first error message when a rule fails', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 2');
      final rule3 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 3');

      final validator = Validator<String>([rule1, rule2, rule3]);

      expect(validator('test'), 'Error 2');
    });

    group('ValidatorExtensions', () {
      test('forString creates a string validator', () {
        final rule = MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final validator = ValidatorExtensions.forString([rule]);

        expect(validator, isA<Validator<String>>());
        expect(validator('test'), 'Error');
      });

      test('forNumber creates a number validator', () {
        final rule =
            MockValidationRule<num>(shouldPass: false, errorMessage: 'Error');

        final validator = ValidatorExtensions.forNumber([rule]);

        expect(validator, isA<Validator<num>>());
        expect(validator(42), 'Error');
      });

      test('forBoolean creates a boolean validator', () {
        final rule =
            MockValidationRule<bool>(shouldPass: false, errorMessage: 'Error');

        final validator = ValidatorExtensions.forBoolean([rule]);

        expect(validator, isA<Validator<bool>>());
        expect(validator(true), 'Error');
      });

      test('forDate creates a date validator', () {
        final rule = MockValidationRule<DateTime>(
            shouldPass: false, errorMessage: 'Error');

        final validator = ValidatorExtensions.forDate([rule]);

        expect(validator, isA<Validator<DateTime>>());
        expect(validator(DateTime.now()), 'Error');
      });
    });
  });
}
