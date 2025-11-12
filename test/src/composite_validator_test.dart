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

class MockAsyncValidationRule<T> extends AsyncValidationRule<T> {
  final bool shouldPass;
  final Duration delay;

  const MockAsyncValidationRule({
    required this.shouldPass,
    this.delay = const Duration(milliseconds: 50),
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
  group('CompositeValidator', () {
    late String? Function(String?) syncValidatorPass;
    late String? Function(String?) syncValidatorFail;
    late AsyncValidator<String> asyncValidatorPass;
    late AsyncValidator<String> asyncValidatorFail;

    setUp(() {
      syncValidatorPass = validator<String>([
        MockValidationRule<String>(
            shouldPass: true, errorMessage: 'Sync Error Pass')
      ]);

      syncValidatorFail = validator<String>([
        MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Sync Error Fail')
      ]);

      asyncValidatorPass = asyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Async Error Pass')
      ]);

      asyncValidatorFail = asyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: false, errorMessage: 'Async Error Fail')
      ]);
    });

    test('constructor creates a composite validator with provided validators',
        () {
      final cv = compositeValidator<String>(
        [syncValidatorPass],
        [asyncValidatorPass],
      );

      expect(cv.isValidating, false);
      expect(cv.isValid, false);
      expect(cv.errorMessage, null);
    });

    test('call returns sync validation errors first', () {
      final cv = compositeValidator<String>(
        [syncValidatorFail],
        [asyncValidatorPass],
      );

      expect(cv('test'), 'Sync Error Fail');
      expect(cv.errorMessage, 'Sync Error Fail');
    });

    testWidgets('call triggers async validation when sync validation passes',
        (WidgetTester tester) async {
      final cv = compositeValidator<String>(
        [syncValidatorPass],
        [asyncValidatorFail],
      );

      expect(cv('test'), null);
      expect(cv.isValidating, true);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(cv.errorMessage, 'Async Error Fail');
      expect(cv.isValidating, false);
      expect(cv.isValid, false);
    });

    test('validateAsync runs all async validations and returns combined result',
        () async {
      final cv = compositeValidator<String>(
        [syncValidatorPass],
        [asyncValidatorPass],
      );

      final result = await cv.validateAsync('test');
      expect(result, true);
      expect(cv.isValid, true);

      final compositeValidatorWithFail = compositeValidator<String>(
        [syncValidatorPass],
        [asyncValidatorPass, asyncValidatorFail],
      );

      final failResult = await compositeValidatorWithFail.validateAsync('test');
      expect(failResult, false);
      expect(compositeValidatorWithFail.isValid, false);
    });

    testWidgets(
        'errorMessage returns the first error from sync, then async validators',
        (tester) async {
      final syncValidator1 = validator<String>([
        MockValidationRule<String>(
            shouldPass: true, errorMessage: 'Sync Error 1')
      ]);

      final syncValidator2 = validator<String>([
        MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Sync Error 2')
      ]);

      final cv = compositeValidator<String>(
        [syncValidator1, syncValidator2],
        [asyncValidatorFail],
      );

      cv('test');
      expect(cv.errorMessage, 'Sync Error 2');

      // If no sync errors, should show async errors
      final compositeValidator2 = compositeValidator<String>(
        [syncValidator1],
        [asyncValidatorFail],
      );

      compositeValidator2('test');

      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(compositeValidator2.errorMessage, 'Async Error Fail');
    });

    test('dispose calls dispose on all async validators', () {
      final mockAsyncValidator1 = asyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Error 1')
      ]);

      final mockAsyncValidator2 = asyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Error 2')
      ]);

      final cv = compositeValidator<String>(
        [syncValidatorPass],
        [mockAsyncValidator1, mockAsyncValidator2],
      );

      // Start some async validation
      mockAsyncValidator1.validate('test');
      mockAsyncValidator2.validate('test');

      // This should not throw exceptions
      expect(() => cv.dispose(), returnsNormally);
    });
  });
}
