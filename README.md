# Form Shield

<p align="center">
  <img src="https://raw.githubusercontent.com/stevenosse/form_shield/refs/heads/main/logo.svg" width="200" alt="Form Shield Logo">
</p>

<p align="center">
  <a href="https://pub.dev/packages/form_shield"><img src="https://img.shields.io/pub/v/form_shield.svg" alt="pub version"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license"></a>
  <a href="https://codecov.io/gh/stevenosse/form_shield"><img src="https://codecov.io/gh/stevenosse/form_shield/branch/main/graph/badge.svg" alt="codecov"></a>
</p>


A declarative, rule-based form validation library for Flutter apps, offering customizable rules and messages, seamless integration with Flutter forms, type safety, and chainable validation.

It provides a simple yet powerful way to define and apply validation logic to your form fields.

## Features

✨ **Declarative Validation:** Define validation rules in a clear, readable way. <br />
🎨 **Customizable:** Easily tailor rules and error messages to your needs.<br />
🤝 **Flutter Integration:** Works seamlessly with Flutter's `Form` and `TextFormField` widgets. <br />
🔒 **Type-Safe:** Leverages Dart's type system for safer validation logic. <br />
🔗 **Chainable Rules:** Combine multiple validation rules effortlessly. <br />
📚 **Comprehensive Built-in Rules:** Includes common validation scenarios out-of-the-box (required, email, password, length, numeric range, phone, etc.). <br />
🛠️ **Extensible:** Create your own custom validation rules by extending the base class. <br />

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
  - [Basic usage](#basic-usage)
  - [Customizing error messages](#customizing-error-messages)
  - [Using multiple validation rules](#using-multiple-validation-rules)
  - [Custom validation rules](#custom-validation-rules)
  - [Dynamic custom validation](#dynamic-custom-validation)
  - [Validating numbers](#validating-numbers)
  - [Phone number validation](#phone-number-validation)
  - [Password validation with options](#password-validation-with-options)
  - [Password confirmation](#password-confirmation)
- [Available validation rules](#available-validation-rules)
- [Creating your own validation rules](#creating-your-own-validation-rules)
- [Contributing](#contributing)
- [License](#license)

## Getting started

### Installation

Add `form_shield` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  form_shield: ^0.3.0
```

Then, run `flutter pub get`.

## Usage

### Basic usage

Import the package:
```dart
import 'package:form_shield/form_shield.dart';
```

Wrap your `TextFormField` (or other form fields) within a `Form` widget and assign a `GlobalKey<FormState>`. Use the `Validator` class to attach rules to the `validator` property of your fields:

```dart
import 'package:flutter/material.dart';
import 'package:form_shield/form_shield.dart';

class MyForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: Validator<String>([
              RequiredRule(),
              EmailRule(),
            ]),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: Validator<String>([
              RequiredRule(),
              PasswordRule(),
            ]),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, proceed
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

### Customizing error messages

```dart
Validator<String>([
  RequiredRule(errorMessage: 'Please enter your email address'),
  EmailRule(errorMessage: 'Please enter a valid email address'),
])
```

### Using multiple validation rules

```dart
Validator<String>([
  RequiredRule(),
  MinLengthRule(8, errorMessage: 'Username must be at least 8 characters'),
  MaxLengthRule(20, errorMessage: 'Username cannot exceed 20 characters'),
])
```

### Custom validation rules

```dart
Validator<String>([
  RequiredRule(),
  CustomRule(
    validator: (value) => value != 'admin',
    errorMessage: 'Username cannot be "admin"',
  ),
])
```

### Dynamic custom validation

```dart
Validator<String>([
  DynamicCustomRule(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a value';
      }
      if (value.contains(' ')) {
        return 'No spaces allowed';
      }
      return null; // Validation passed
    },
  ),
])
```

### Validating numbers

```dart
Validator<num>([
  MinValueRule(18, errorMessage: 'You must be at least 18 years old'),
  MaxValueRule(120, errorMessage: 'Please enter a valid age'),
])
```

### Phone number validation

```dart
// General phone validation
Validator<String>([
  RequiredRule(),
  PhoneRule(),
])

// Country-specific phone validation
Validator<String>([
  RequiredRule(),
  CountryPhoneRule(countryCode: 'CM'),
])
```

### Password validation with options

```dart
Validator<String>([
  RequiredRule(),
  PasswordRule(
    options: PasswordOptions(
      minLength: 10,
      requireUppercase: true,
      requireLowercase: true,
      requireDigit: true,
      requireSpecialChar: true,
    ),
    errorMessage: 'Password does not meet security requirements',
  ),
])
```

### Password confirmation

```dart
final passwordController = TextEditingController();

// Password field
TextFormField(
  controller: passwordController,
  validator: Validator<String>([
    RequiredRule(),
    PasswordRule(),
  ]),
)

// Confirm password field
TextFormField(
  validator: Validator<String>([
    RequiredRule(),
    PasswordMatchRule(
      passwordGetter: () => passwordController.text,
      errorMessage: 'Passwords do not match',
    ),
  ]),
)
```

## Available validation rules

- `RequiredRule` - Validates that a value is not null or empty
- `EmailRule` - Validates that a string is a valid email address
- `PasswordRule` - Validates that a string meets password requirements
- `PasswordMatchRule` - Validates that a string matches another string
- `LengthRule` - Validates that a string's length is within specified bounds
- `MinLengthRule` - Validates that a string's length is at least a specified minimum
- `MaxLengthRule` - Validates that a string's length is at most a specified maximum
- `ValueRule` - Validates that a numeric value is within specified bounds
- `MinValueRule` - Validates that a numeric value is at least a specified minimum
- `MaxValueRule` - Validates that a numeric value is at most a specified maximum
- `PhoneRule` - Validates that a string is a valid phone number
- `CountryPhoneRule` - Validates that a string is a valid phone number for a specific country
- `UrlRule` - Validates that a string is a valid URL
- `IPAddressRule` - Validates that a string is a valid IPv4 or IPv6 address
- `CreditCardRule` - Validates that a string is a valid credit card number
- `DateRangeRule` - Validates that a date is within a specified range
- `CustomRule` - A validation rule that uses a custom function to validate values
- `DynamicCustomRule` - A validation rule that uses a custom function to validate values and return a dynamic error message

## Creating your own validation rules

You can create your own validation rules by extending the `ValidationRule` class:

```dart
class NoSpacesRule extends ValidationRule<String> {
  const NoSpacesRule({
    String errorMessage = 'No spaces allowed',
  }) : super(errorMessage: errorMessage);

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (value.contains(' ')) {
      return ValidationResult.error(errorMessage);
    }

    return const ValidationResult.success();
  }
}
```

Then use it like any other validation rule:

```dart
Validator<String>([
  RequiredRule(),
  NoSpacesRule(),
])
```

### Asynchronous validation rules

Form Shield supports asynchronous validation for scenarios where validation requires network requests or other async operations (like checking username availability or email uniqueness).

You can create async validation rules by either:
1. Extending the `ValidationRule` class and overriding the `validateAsync` method
2. Extending the specialized `AsyncValidationRule` class

#### Example: Username availability checker

```dart
class UsernameAvailabilityRule extends ValidationRule<String> {
  final Future<bool> Function(String username) _checkAvailability;

  const UsernameAvailabilityRule({
    required Future<bool> Function(String username) checkAvailability,
    super.errorMessage = 'This username is already taken',
  }) : _checkAvailability = checkAvailability;

  @override
  ValidationResult validate(String? value) {
    // Perform synchronous validation first
    if (value == null || value.isEmpty) {
      return ValidationResult.error('Username cannot be empty');
    }
    return const ValidationResult.success();
  }

  @override
  Future<ValidationResult> validateAsync(String? value) async {
    // Run sync validation first
    final syncResult = validate(value);
    if (!syncResult.isValid) {
      return syncResult;
    }

    try {
      // Perform the async validation
      final isAvailable = await _checkAvailability(value!);
      if (isAvailable) {
        return const ValidationResult.success();
      } else {
        return ValidationResult.error(errorMessage);
      }
    } catch (e) {
      return ValidationResult.error('Error checking username availability: $e');
    }
  }
}
```

#### Using async validation in forms

When using async validation, you need to:
1. Create a validator instance as a field in your state class
2. Initialize it in `initState()`
3. Dispose of it in `dispose()`
4. Check both sync and async validation states before submitting

```dart
class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  late final Validator<String> _usernameValidator;

  @override
  void initState() {
    super.initState();

    _usernameValidator = Validator<String>([
      RequiredRule(),
      UsernameAvailabilityRule(
        checkAvailability: _checkUsernameAvailability,
      ),
    ], debounceDuration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameValidator.dispose(); // Important to prevent memory leaks
    super.dispose();
  }

  Future<bool> _checkUsernameAvailability(String username) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 1));
    final takenUsernames = ['admin', 'user', 'test'];
    return !takenUsernames.contains(username.toLowerCase());
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        !_usernameValidator.isValidating &&
        _usernameValidator.isValid) {
      // All validations passed, proceed with form submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: _usernameValidator,
          ),
          // Show async validation state
          ValueListenableBuilder<AsyncValidationStateData>(
            valueListenable: _usernameValidator.asyncState,
            builder: (context, state, _) {
              if (state.isValidating) {
                return Text('Checking username availability...');
              } else if (state.isValid == false) {
                return Text(
                  state.errorMessage ?? 'Invalid username',
                  style: TextStyle(color: Colors.red),
                );
              } else if (state.isValid == true) {
                return Text(
                  'Username is available',
                  style: TextStyle(color: Colors.green),
                );
              }
              return SizedBox.shrink();
            },
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

#### Debouncing async validation

Form Shield includes built-in debouncing for async validation to prevent excessive API calls during typing. You can customize the debounce duration:

```dart
Validator<String>([
  RequiredRule(),
  UsernameAvailabilityRule(checkAvailability: _checkUsername),
], debounceDuration: Duration(milliseconds: 800)) // Custom debounce time
```

#### Manually triggering async validation

You can manually trigger async validation using the `validateAsync` method:

```dart
Future<void> _checkUsername() async {
  final isValid = await _usernameValidator.validateAsync(
    _usernameController.text,
    debounceDuration: Duration.zero, // Optional: skip debouncing
  );
  
  if (isValid) {
    // Username is valid and available
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggest improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
