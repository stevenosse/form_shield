import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('AsyncValidationState', () {
    late AsyncValidationState state;

    setUp(() {
      state = AsyncValidationState();
    });

    test('initial state is not validating and has no validation result', () {
      expect(state.isValidating, false);
      expect(state.isValid, false);
      expect(state.errorMessage, null);
    });

    test('validating() sets isValidating to true', () {
      state.validating();
      expect(state.isValidating, true);
      expect(state.isValid, false);
      expect(state.errorMessage, null);
    });

    test('valid() sets isValidating to false and isValid to true', () {
      state.valid();
      expect(state.isValidating, false);
      expect(state.isValid, true);
      expect(state.errorMessage, null);
    });

    test('invalid() sets isValidating to false, isValid to false, and sets error message', () {
      const errorMessage = 'Test error message';
      state.invalid(errorMessage);
      expect(state.isValidating, false);
      expect(state.isValid, false);
      expect(state.errorMessage, errorMessage);
    });

    test('reset() returns to initial state', () {
      // First change the state
      state.invalid('Error');
      expect(state.isValid, false);
      expect(state.errorMessage, 'Error');
      
      // Then reset
      state.reset();
      expect(state.isValidating, false);
      expect(state.isValid, false);
      expect(state.errorMessage, null);
    });

    test('state transitions work correctly in sequence', () {
      // Initial -> Validating -> Valid
      expect(state.isValidating, false);
      state.validating();
      expect(state.isValidating, true);
      state.valid();
      expect(state.isValidating, false);
      expect(state.isValid, true);
      
      // Valid -> Validating -> Invalid
      state.validating();
      expect(state.isValidating, true);
      state.invalid('Error');
      expect(state.isValidating, false);
      expect(state.isValid, false);
      expect(state.errorMessage, 'Error');
    });
  });

  group('AsyncValidationStateData', () {
    test('initial factory creates correct state', () {
      final state = AsyncValidationStateData.initial();
      expect(state.isValidating, false);
      expect(state.isValid, null);
      expect(state.errorMessage, null);
    });

    test('validating factory creates correct state', () {
      final state = AsyncValidationStateData.validating();
      expect(state.isValidating, true);
      expect(state.isValid, null);
      expect(state.errorMessage, null);
    });

    test('valid factory creates correct state', () {
      final state = AsyncValidationStateData.valid();
      expect(state.isValidating, false);
      expect(state.isValid, true);
      expect(state.errorMessage, null);
    });

    test('invalid factory creates correct state', () {
      const errorMessage = 'Test error';
      final state = AsyncValidationStateData.invalid(errorMessage);
      expect(state.isValidating, false);
      expect(state.isValid, false);
      expect(state.errorMessage, errorMessage);
    });

    test('toString returns correct representation', () {
      final state = AsyncValidationStateData.invalid('Error');
      expect(state.toString(), contains('isValidating: false'));
      expect(state.toString(), contains('isValid: false'));
      expect(state.toString(), contains('errorMessage: Error'));
    });
  });
}