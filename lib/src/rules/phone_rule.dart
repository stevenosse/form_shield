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

/// Validates that a string is a valid phone number for a specific country.
class CountryPhoneRule extends ValidationRule<String> {
  final String countryCode;

  static const Map<String, String> _countryPatterns = {
    'US': r'^(\+1|1)?[-. ]?\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}$',
    'UK': r'^(\+44|44)?[-. ]?\(?[0-9]{2,5}\)?[-. ]?[0-9]{3,4}[-. ]?[0-9]{3,4}$',
    'FR':
        r'^(\+33|33)?[-. ]?\(?[0-9]{1,2}\)?[-. ]?[0-9]{2}[-. ]?[0-9]{2}[-. ]?[0-9]{2}[-. ]?[0-9]{2}$',
    'DE': r'^(\+49|49)?[-. ]?\(?[0-9]{2,4}\)?[-. ]?[0-9]{3,7}[-. ]?[0-9]{2,8}$',
    'CM': r'^(\+237|237)?[-. ]?[2368][0-9]{7,8}$',
    'CI': r'^(\+225|225)?[-. ]?[0-9]{8}$',
    'SN': r'^(\+221|221)?[-. ]?[7][0-9]{8}$',
    'TG': r'^(\+228|228)?[-. ]?[9][0-9]{7}$',
    'ML': r'^(\+223|223)?[-. ]?[6-7][0-9]{7}$',
    'GA': r'^(\+241|241)?[-. ]?[0-7][0-9]{7}$',
    'CD': r'^(\+243|243)?[-. ]?[0-9]{9}$',
    'CG': r'^(\+242|242)?[-. ]?[0-9]{9}$',
    'CF': r'^(\+236|236)?[-. ]?[7][0-9]{7}$',
    'TD': r'^(\+235|235)?[-. ]?[6-9][0-9]{7}$',
  };

  CountryPhoneRule({
    required this.countryCode,
    super.errorMessage = 'Please enter a valid phone number',
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.success();
    }

    final pattern = _countryPatterns[countryCode.toUpperCase()];
    if (pattern == null) {
      return PhoneRule().validate(value);
    }

    if (!RegExp(pattern).hasMatch(value)) {
      return ValidationResult.error(errorMessage);
    }

    return ValidationResult.success();
  }
}
