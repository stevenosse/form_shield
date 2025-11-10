import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a string is a valid phone number.
class PhoneRule extends ValidationRule<String> {
  final RegExp _phoneRegex;

  PhoneRule({
    super.errorMessage = 'Please enter a valid phone number',
    String pattern =
        r'^\+?[0-9]{1,3}?[-. ]?\(?[0-9]{1,3}?\)?[-. ]?[0-9]{1,4}[-. ]?[0-9]{1,4}[-. ]?[0-9]{1,9}$',
  }) : _phoneRegex = RegExp(pattern);

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.success();
    }

    if (!_phoneRegex.hasMatch(value)) {
      return ValidationResult.error(errorMessage);
    }

    return ValidationResult.success();
  }
}
