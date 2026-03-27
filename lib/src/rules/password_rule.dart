import '../validation_rule.dart';
import '../validation_result.dart';
import '../form_shield_localizations.dart';

/// Configuration options for password validation.
class PasswordOptions {
  /// Minimum length of the password.
  final int minLength;

  /// Maximum length of the password. If null, no maximum is enforced.
  final int? maxLength;

  /// Whether to require at least one uppercase letter.
  final bool requireUppercase;

  /// Whether to require at least one lowercase letter.
  final bool requireLowercase;

  /// Whether to require at least one digit.
  final bool requireDigit;

  /// Whether to require at least one special character (any non-alphanumeric character).
  final bool requireSpecialChar;

  /// Custom error message for minimum length validation.
  final String? minLengthMessage;

  /// Custom error message for maximum length validation.
  final String? maxLengthMessage;

  /// Custom error message for uppercase letter requirement.
  final String? uppercaseMessage;

  /// Custom error message for lowercase letter requirement.
  final String? lowercaseMessage;

  /// Custom error message for digit requirement.
  final String? digitMessage;

  /// Custom error message for special character requirement.
  final String? specialCharMessage;

  /// Creates password validation options.
  const PasswordOptions({
    this.minLength = 8,
    this.maxLength,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireDigit = true,
    this.requireSpecialChar = true,
    this.minLengthMessage,
    this.maxLengthMessage,
    this.uppercaseMessage,
    this.lowercaseMessage,
    this.digitMessage,
    this.specialCharMessage,
  });
}

/// Validates that a string meets password requirements.
class PasswordRule extends ValidationRule<String> {
  /// Configuration options for password validation.
  final PasswordOptions options;

  /// Creates a password validation rule with the specified error message and options.
  ///
  /// If custom messages are not provided in options, uses localized messages.
  const PasswordRule({
    super.errorMessage = '',
    this.options = const PasswordOptions(),
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    final List<String> errors = [];

    if (value.length < options.minLength) {
      errors.add(options.minLengthMessage ??
          FormShieldLocalizations.passwordMinLength(options.minLength));
    }

    if (options.maxLength != null && value.length > options.maxLength!) {
      errors.add(options.maxLengthMessage ??
          FormShieldLocalizations.passwordMinLength(options.maxLength!));
    }

    if (options.requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      errors.add(options.uppercaseMessage ??
          FormShieldLocalizations.passwordUppercase);
    }

    if (options.requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      errors.add(options.lowercaseMessage ??
          FormShieldLocalizations.passwordLowercase);
    }

    if (options.requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      errors.add(options.digitMessage ?? FormShieldLocalizations.passwordDigit);
    }

    if (options.requireSpecialChar &&
        !value.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      errors.add(options.specialCharMessage ??
          FormShieldLocalizations.passwordSpecialChar);
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
  ///
  /// If [errorMessage] is not provided, uses the localized message.
  const PasswordMatchRule({
    required this.passwordGetter,
    super.errorMessage = '',
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (value != passwordGetter()) {
      final message = errorMessage.isNotEmpty
          ? errorMessage
          : FormShieldLocalizations.passwordsDoNotMatch;
      return ValidationResult.error(message);
    }

    return const ValidationResult.success();
  }
}
