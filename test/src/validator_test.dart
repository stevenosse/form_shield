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

      expect(validator('test'), null);
    });

    test('addRule returns a new validator with the additional rule', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 2');

      final validator1 = Validator<String>([rule1]);
      final validator2 = validator1.addRule(rule2);

      expect(validator1('test'), null);
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

    test('top-level helper `validator([])` returns a working validator', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 2');

      final v = validator<String>([rule1, rule2]);
      expect(v('ok'), null);
    });

    test('errorMessage returns the current error message', () {
      final rule =
          MockValidationRule<String>(shouldPass: false, errorMessage: 'Error');

      final validator = Validator<String>([rule]);
      validator('test');

      expect(validator.errorMessage, 'Error');
    });

    group('Validator creation', () {
      test('validator([]) creates a string validator', () {
        final rule = MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final v = validator<String>([rule]);

        expect(v, isA<Validator<String>>());
        expect(v('test'), 'Error');
      });

      test('validator([]) creates a number validator', () {
        final rule =
            MockValidationRule<num>(shouldPass: false, errorMessage: 'Error');

        final v = validator<num>([rule]);

        expect(v, isA<Validator<num>>());
        expect(v(42), 'Error');
      });

      test('validator([]) creates a boolean validator', () {
        final rule =
            MockValidationRule<bool>(shouldPass: false, errorMessage: 'Error');

        final v = validator<bool>([rule]);

        expect(v, isA<Validator<bool>>());
        expect(v(true), 'Error');
      });

      test('validator([]) creates a date validator (string input)', () {
        final rule = MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final v = validator<String>([rule]);

        expect(v, isA<Validator<String>>());
        expect(v('2023-01-01'), 'Error');
      });
    });
  });
}
