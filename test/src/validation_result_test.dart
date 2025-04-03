import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('ValidationResult', () {
    test('success creates a valid result with null error message', () {
      final result = ValidationResult.success();

      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test('error creates an invalid result with the specified error message',
        () {
      const errorMessage = 'Invalid input';
      final result = ValidationResult.error(errorMessage);

      expect(result.isValid, false);
      expect(result.errorMessage, errorMessage);
    });

    test('toString returns a formatted string representation', () {
      final successResult = ValidationResult.success();
      final errorResult = ValidationResult.error('Error message');

      expect(successResult.toString(),
          'ValidationResult(isValid: true, errorMessage: null)');
      expect(errorResult.toString(),
          'ValidationResult(isValid: false, errorMessage: Error message)');
    });
  });
}
