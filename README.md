<p align="center">
  <img src="logo.svg" width="200" alt="Form Shield Logo">
</p>

[![pub version](https://img.shields.io/pub/v/form_shield.svg)](https://pub.dev/packages/form_shield)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# Form Shield

A declarative, rule-based form validation library for Flutter apps, offering customizable rules and messages, seamless integration with Flutter forms, type safety, and chainable validation.

It provides a simple yet powerful way to define and apply validation logic to your form fields.

## Features

✨ **Declarative Validation:** Define validation rules in a clear, readable way.
🎨 **Customizable:** Easily tailor rules and error messages to your needs.
🤝 **Flutter Integration:** Works seamlessly with Flutter's `Form` and `TextFormField` widgets.
🔒 **Type-Safe:** Leverages Dart's type system for safer validation logic.
🔗 **Chainable Rules:** Combine multiple validation rules effortlessly.
📚 **Comprehensive Built-in Rules:** Includes common validation scenarios out-of-the-box (required, email, password, length, numeric range, phone, etc.).
🛠️ **Extensible:** Create your own custom validation rules by extending the base class.

## Getting started

### Installation

Add `form_shield` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  form_shield: ^0.1.0
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

## Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggest improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
