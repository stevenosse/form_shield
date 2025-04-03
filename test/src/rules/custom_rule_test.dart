import 'package:flutter_test/flutter_test.dart';
import 'package:form_shield/form_shield.dart';

void main() {
  group('CustomRule', () {
    const errorMessage = 'Custom error message';
    
    test('constructor sets error message correctly', () {
      final rule = CustomRule<String>(
        validator: (value) => value?.isNotEmpty ?? false,
        errorMessage: errorMessage,
      );
      
      expect(rule.errorMessage, errorMessage);
    });
    
    group('validate', () {
      test('returns success when validator returns true', () {
        final rule = CustomRule<String>(
          validator: (value) => value?.isNotEmpty ?? false,
          errorMessage: errorMessage,
        );
        
        final result = rule.validate('test');
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns error when validator returns false', () {
        final rule = CustomRule<String>(
          validator: (value) => value?.isNotEmpty ?? false,
          errorMessage: errorMessage,
        );
        
        final result = rule.validate('');
        
        expect(result.isValid, false);
        expect(result.errorMessage, errorMessage);
      });
      
      test('works with different types', () {
        final numberRule = CustomRule<int>(
          validator: (value) => value != null && value > 0,
          errorMessage: errorMessage,
        );
        
        expect(numberRule.validate(5).isValid, true);
        expect(numberRule.validate(0).isValid, false);
        expect(numberRule.validate(null).isValid, false);
        
        final listRule = CustomRule<List<String>>(
          validator: (value) => value != null && value.isNotEmpty,
          errorMessage: errorMessage,
        );
        
        expect(listRule.validate(['item']).isValid, true);
        expect(listRule.validate([]).isValid, false);
      });
    });
  });
  
  group('DynamicCustomRule', () {
    test('constructor sets empty error message', () {
      final rule = DynamicCustomRule<String>(
        validator: (value) => value?.isEmpty ?? true ? 'Error' : null,
      );
      
      expect(rule.errorMessage, '');
    });
    
    group('validate', () {
      test('returns success when validator returns null', () {
        final rule = DynamicCustomRule<String>(
          validator: (value) => value?.isEmpty ?? true ? 'Error' : null,
        );
        
        final result = rule.validate('test');
        
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });
      
      test('returns error with dynamic message when validator returns a string', () {
        final rule = DynamicCustomRule<String>(
          validator: (value) => value?.isEmpty ?? true ? 'Error' : null,
        );
        
        final result = rule.validate('');
        
        expect(result.isValid, false);
        expect(result.errorMessage, 'Error');
      });
      
      test('dynamic error message can depend on the value', () {
        final rule = DynamicCustomRule<int>(
          validator: (value) => value == null ? 'Value is null' :
                               value < 0 ? 'Value is negative' :
                               value > 100 ? 'Value is too large' : null,
        );
        
        expect(rule.validate(null).errorMessage, 'Value is null');
        expect(rule.validate(-5).errorMessage, 'Value is negative');
        expect(rule.validate(150).errorMessage, 'Value is too large');
        expect(rule.validate(50).isValid, true);
      });
    });
  });
}