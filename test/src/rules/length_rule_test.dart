import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('LengthRule', () {
    group('constructor', () {
      test('sets default error message when not provided', () {
        final rule = LengthRule(minLength: 5, maxLength: 10);
        expect(rule.errorMessage, 'Must be between 5 and 10 characters');
        
        final minRule = LengthRule(minLength: 5);
        expect(minRule.errorMessage, 'Must be at least 5 characters');
        
        final maxRule = LengthRule(maxLength: 10);
        expect(maxRule.errorMessage, 'Must be at most 10 characters');
        
        final noLimitsRule = LengthRule();
        expect(noLimitsRule.errorMessage, 'Invalid length');
      });
      
      test('sets custom error message when provided', () {
        const customMessage = 'Custom error message';
        final rule = LengthRule(
          minLength: 5,
          maxLength: 10,
          errorMessage: customMessage,
        );
        
        expect(rule.errorMessage, customMessage);
      });
    });
    
    group('validate', () {
      test('returns success for null value', () {
        final rule = LengthRule(minLength: 5, maxLength: 10);
        final result = rule.validate(null);
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns success for empty string', () {
        final rule = LengthRule(minLength: 5, maxLength: 10);
        final result = rule.validate('');
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns error when string is shorter than minLength', () {
        final rule = LengthRule(minLength: 5);
        final result = rule.validate('abc');
        
        expect(result.isValid, false);
        expect(result.errorMessage, 'Must be at least 5 characters');
      });
      
      test('returns error when string is longer than maxLength', () {
        final rule = LengthRule(maxLength: 5);
        final result = rule.validate('abcdefg');
        
        expect(result.isValid, false);
        expect(result.errorMessage, 'Must be at most 5 characters');
      });
      
      test('returns error when string is outside both bounds', () {
        final rule = LengthRule(minLength: 5, maxLength: 10);
        
        final tooShortResult = rule.validate('abc');
        expect(tooShortResult.isValid, false);
        expect(tooShortResult.errorMessage, 'Must be between 5 and 10 characters');
        
        final tooLongResult = rule.validate('abcdefghijklm');
        expect(tooLongResult.isValid, false);
        expect(tooLongResult.errorMessage, 'Must be between 5 and 10 characters');
      });
      
      test('returns success when string is within bounds', () {
        final rule = LengthRule(minLength: 5, maxLength: 10);
        
        final atMinResult = rule.validate('abcde');
        expect(atMinResult.isValid, true);
        expect(atMinResult.errorMessage, null);
        
        final atMaxResult = rule.validate('abcdefghij');
        expect(atMaxResult.isValid, true);
        expect(atMaxResult.errorMessage, null);
        
        final inBetweenResult = rule.validate('abcdefg');
        expect(inBetweenResult.isValid, true);
        expect(inBetweenResult.errorMessage, null);
      });
    });
  });
  
  group('MinLengthRule', () {
    test('constructor creates a LengthRule with only minLength set', () {
      final rule = MinLengthRule(5);
      
      expect(rule.minLength, 5);
      expect(rule.maxLength, null);
      expect(rule.errorMessage, 'Must be at least 5 characters');
    });
    
    test('constructor sets custom error message when provided', () {
      const customMessage = 'Custom error message';
      final rule = MinLengthRule(5, errorMessage: customMessage);
      
      expect(rule.errorMessage, customMessage);
    });
    
    test('validate works correctly', () {
      final rule = MinLengthRule(5);
      
      expect(rule.validate(null).isValid, true);
      expect(rule.validate('').isValid, true);
      expect(rule.validate('abc').isValid, false);
      expect(rule.validate('abcde').isValid, true);
      expect(rule.validate('abcdefg').isValid, true);
    });
  });
  
  group('MaxLengthRule', () {
    test('constructor creates a LengthRule with only maxLength set', () {
      final rule = MaxLengthRule(10);
      
      expect(rule.minLength, null);
      expect(rule.maxLength, 10);
      expect(rule.errorMessage, 'Must be at most 10 characters');
    });
    
    test('constructor sets custom error message when provided', () {
      const customMessage = 'Custom error message';
      final rule = MaxLengthRule(10, errorMessage: customMessage);
      
      expect(rule.errorMessage, customMessage);
    });
    
    test('validate works correctly', () {
      final rule = MaxLengthRule(10);
      
      expect(rule.validate(null).isValid, true);
      expect(rule.validate('').isValid, true);
      expect(rule.validate('abcdefg').isValid, true);
      expect(rule.validate('abcdefghij').isValid, true);
      expect(rule.validate('abcdefghijklm').isValid, false);
    });
  });
}