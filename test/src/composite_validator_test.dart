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
    late Validator<String> syncValidatorPass;
    late Validator<String> syncValidatorFail;
    late AsyncValidator<String> asyncValidatorPass;
    late AsyncValidator<String> asyncValidatorFail;

    setUp(() {
      syncValidatorPass = Validator<String>([
        MockValidationRule<String>(
            shouldPass: true, errorMessage: 'Sync Error Pass')
      ]);

      syncValidatorFail = Validator<String>([
        MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Sync Error Fail')
      ]);

      asyncValidatorPass = AsyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Async Error Pass')
      ]);

      asyncValidatorFail = AsyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: false, errorMessage: 'Async Error Fail')
      ]);
    });

    test('constructor creates a composite validator with provided validators',
        () {
      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidatorPass],
        asyncValidators: [asyncValidatorPass],
      );

      expect(compositeValidator.isValidating, false);
      expect(compositeValidator.isValid, false);
      expect(compositeValidator.errorMessage, null);
    });

    test('call returns sync validation errors first', () {
      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidatorFail],
        asyncValidators: [asyncValidatorPass],
      );

      expect(compositeValidator('test'), 'Sync Error Fail');
      expect(compositeValidator.errorMessage, 'Sync Error Fail');
    });

    testWidgets('call triggers async validation when sync validation passes',
        (WidgetTester tester) async {
      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidatorPass],
        asyncValidators: [asyncValidatorFail],
      );

      expect(compositeValidator('test'), null);
      expect(compositeValidator.isValidating, true);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(compositeValidator.errorMessage, 'Async Error Fail');
      expect(compositeValidator.isValidating, false);
      expect(compositeValidator.isValid, false);
    });

    test('validateAsync runs all async validations and returns combined result',
        () async {
      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidatorPass],
        asyncValidators: [asyncValidatorPass],
      );

      final result = await compositeValidator.validateAsync('test');
      expect(result, true);
      expect(compositeValidator.isValid, true);

      final compositeValidatorWithFail = CompositeValidator<String>(
        syncValidators: [syncValidatorPass],
        asyncValidators: [asyncValidatorPass, asyncValidatorFail],
      );

      final failResult = await compositeValidatorWithFail.validateAsync('test');
      expect(failResult, false);
      expect(compositeValidatorWithFail.isValid, false);
    });

    testWidgets(
        'errorMessage returns the first error from sync, then async validators',
        (tester) async {
      final syncValidator1 = Validator<String>([
        MockValidationRule<String>(
            shouldPass: true, errorMessage: 'Sync Error 1')
      ]);

      final syncValidator2 = Validator<String>([
        MockValidationRule<String>(
            shouldPass: false, errorMessage: 'Sync Error 2')
      ]);

      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidator1, syncValidator2],
        asyncValidators: [asyncValidatorFail],
      );

      compositeValidator('test');
      expect(compositeValidator.errorMessage, 'Sync Error 2');

      // If no sync errors, should show async errors
      final compositeValidator2 = CompositeValidator<String>(
        syncValidators: [syncValidator1],
        asyncValidators: [asyncValidatorFail],
      );

      compositeValidator2('test');

      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(compositeValidator2.errorMessage, 'Async Error Fail');
    });

    test('dispose calls dispose on all async validators', () {
      final mockAsyncValidator1 = AsyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Error 1')
      ]);

      final mockAsyncValidator2 = AsyncValidator<String>([
        MockAsyncValidationRule<String>(
            shouldPass: true, errorMessage: 'Error 2')
      ]);

      final compositeValidator = CompositeValidator<String>(
        syncValidators: [syncValidatorPass],
        asyncValidators: [mockAsyncValidator1, mockAsyncValidator2],
      );

      // Start some async validation
      mockAsyncValidator1.validate('test');
      mockAsyncValidator2.validate('test');

      // This should not throw exceptions
      expect(() => compositeValidator.dispose(), returnsNormally);
    });
  });
}
