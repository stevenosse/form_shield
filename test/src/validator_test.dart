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
    test('validator([]) returns a closure that validates provided rules', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 2');

      final v = validator<String>([rule1, rule2]);

      expect(v('test'), null);
    });

    test('validator closure applies rules and returns first error', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 2');
      final rule3 = MockValidationRule<String>(
          shouldPass: false, errorMessage: 'Error 3');

      final v = validator<String>([rule1, rule2, rule3]);

      expect(v('test'), 'Error 2');
    });

    test('top-level helper `validator([])` returns a working validator', () {
      final rule1 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 1');
      final rule2 =
          MockValidationRule<String>(shouldPass: true, errorMessage: 'Error 2');

      final v = validator<String>([rule1, rule2]);
      expect(v('ok'), null);
    });

    test('validator closure returns the current error message when invalid',
        () {
      final rule =
          MockValidationRule<String>(shouldPass: false, errorMessage: 'Error');

      final v = validator<String>([rule]);

      expect(v('test'), 'Error');
    });

    group('Validator creation', () {
      test('validator([]) creates a string validator function', () {
        final rule = MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final v = validator<String>([rule]);

        expect(v, isA<String? Function(String?)>());
        expect(v('test'), 'Error');
      });

      test('validator([]) creates a number validator function', () {
        final rule =
            MockValidationRule<num>(shouldPass: false, errorMessage: 'Error');

        final v = validator<num>([rule]);

        expect(v, isA<String? Function(num?)>());
        expect(v(42), 'Error');
      });

      test('validator([]) creates a boolean validator function', () {
        final rule =
            MockValidationRule<bool>(shouldPass: false, errorMessage: 'Error');

        final v = validator<bool>([rule]);

        expect(v, isA<String? Function(bool?)>());
        expect(v(true), 'Error');
      });

      test('validator([]) creates a date validator function (string input)',
          () {
        final rule = MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Error');

        final v = validator<String>([rule]);

        expect(v, isA<String? Function(String?)>());
        expect(v('2023-01-01'), 'Error');
      });
    });
  });
}
