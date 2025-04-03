import '../validation_rule.dart';
import '../validation_result.dart';

/// Configuration options for password validation.
class PasswordOptions {
  /// Minimum length of the password.
  final int minLength;

  /// Whether to require at least one uppercase letter.
  final bool requireUppercase;

  /// Whether to require at least one lowercase letter.
  final bool requireLowercase;

  /// Whether to require at least one digit.
  final bool requireDigit;

  /// Whether to require at least one special character.
  final bool requireSpecialChar;

  /// Creates password validation options.
  const PasswordOptions({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireDigit = true,
    this.requireSpecialChar = true,
  });
}

/// Validates that a string meets password requirements.
class PasswordRule extends ValidationRule<String> {
  /// Configuration options for password validation.
  final PasswordOptions options;

  /// Creates a password validation rule with the specified error message and options.
  const PasswordRule({
    super.errorMessage = 'Password does not meet requirements',
    this.options = const PasswordOptions(),
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    final List<String> errors = [];

    if (value.length < options.minLength) {
      errors.add('Password must be at least ${options.minLength} characters long');
    }

    if (options.requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }

    if (options.requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }

    if (options.requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one digit');
    }

    if (options.requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('Password must contain at least one special character');
    }

    if (errors.isNotEmpty) {
      return ValidationResult.error(errors.join('\n'));
    }

    return const ValidationResult.success();
  }
}

/// Validates that a string matches another string (e.g., for password confirmation).
class PasswordMatchRule extends ValidationRule<String> {
  /// The password to match against.
  final String Function() passwordGetter;

  /// Creates a password match validation rule.
  const PasswordMatchRule({
    required this.passwordGetter,
    super.errorMessage = 'Passwords do not match',
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (value != passwordGetter()) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
