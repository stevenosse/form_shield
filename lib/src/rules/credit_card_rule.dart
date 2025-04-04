import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a string is a valid credit card number using the Luhn algorithm.
class CreditCardRule extends ValidationRule<String> {
  /// Whether to allow spaces in the credit card number.
  final bool allowSpaces;

  /// Whether to allow hyphens in the credit card number.
  final bool allowHyphens;

  /// Creates a credit card validation rule with the specified configuration and error message.
  CreditCardRule({
    super.errorMessage = 'Please enter a valid credit card number',
    this.allowSpaces = true,
    this.allowHyphens = true,
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    // Normalize the input by removing spaces and hyphens if allowed
    String normalizedValue = value;
    if (allowSpaces) {
      normalizedValue = normalizedValue.replaceAll(' ', '');
    }
    if (allowHyphens) {
      normalizedValue = normalizedValue.replaceAll('-', '');
    }

    // Check if the normalized value contains only digits
    if (!RegExp(r'^\d+$').hasMatch(normalizedValue)) {
      return ValidationResult.error(errorMessage);
    }

    // Check if the length is valid (most credit cards are between 13-19 digits)
    if (normalizedValue.length < 13 || normalizedValue.length > 19) {
      return ValidationResult.error(errorMessage);
    }

    // Validate using the Luhn algorithm
    if (!_validateWithLuhnAlgorithm(normalizedValue)) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }

  /// Validates a credit card number using the Luhn algorithm.
  bool _validateWithLuhnAlgorithm(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    // Process the digits from right to left
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      // Double every second digit
      if (alternate) {
        digit *= 2;
        // If doubling results in a two-digit number, add the digits together
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    // The number is valid if the sum is divisible by 10
    return sum % 10 == 0;
  }
}
