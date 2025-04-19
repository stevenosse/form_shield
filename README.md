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

✨ **Declarative validation:** Define validation rules in a clear, readable way. <br />
🎨 **Customizable:** Easily tailor rules and error messages to your needs.<br />
🤝 **Flutter integration:** Works seamlessly with Flutter's `Form` and `TextFormField` widgets. <br />
🔒 **Type-safe:** Leverages Dart's type system for safer validation logic. <br />
🔗 **Chainable rules:** Combine multiple validation rules effortlessly. <br />
📚 **Comprehensive built-in rules:** Includes common validation scenarios out-of-the-box (required, email, password, length, numeric range, phone, etc.). <br />
🛠️ **Extensible:** Create your own custom validation rules by extending the base class. <br />
🔄 **Separate sync/async APIs:** Clearly separated APIs for synchronous and asynchronous validation needs. <br />
🧩 **Composable validators:** Combine multiple validators with the `CompositeValidator`. <br />

## Table of Contents
- [Installation](#getting-started)
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
- [Validation vrchitecture](#validation-architecture)
  - [Synchronous validation](#synchronous-validation)
  - [Asynchronous validation](#asynchronous-validation)
  - [Compose validators](#composite-validation)
- [Asynchronous validation rules](#asynchronous-validation-rules)
  - [Username availability checker](#example-username-availability-checker)
  - [Using async validation in forms](#using-async-validation-in-forms)
  - [Debouncing async validation](#debouncing-async-validation)
  - [Manually triggering async validation](#manually-triggering-async-validation)
- [Contributing](#contributing)
- [License](#license)

## Getting started

### Installation

Add `form_shield` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  form_shield: ^0.5.0
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

## Validation architecture

Form Shield offers three distinct validator classes to handle different validation scenarios:

### Synchronous validation

`Validator` handles synchronous validation with immediate results:

```dart
// Create a validator with synchronous rules
final validator = Validator<String>([
  RequiredRule(),
  EmailRule(),
]);

// Use it directly as a FormField validator
TextFormField(
  validator: validator,
)
```

### Asynchronous validation

`AsyncValidator` is specifically for asynchronous validation needs:

```dart
// Create an async validator with async rules
final asyncValidator = AsyncValidator<String>([
  UsernameAvailabilityRule(
    checkAvailability: (username) async {
      // API call or database check
      return await userRepository.isUsernameAvailable(username);
    },
  ),
], debounceDuration: Duration(milliseconds: 500));

// Don't forget to dispose
@override
void dispose() {
  asyncValidator.dispose();
  super.dispose();
}
```

### Composite validation

`CompositeValidator` combines both synchronous and asynchronous validators:

```dart
// Create sync and async validators
final syncValidator = Validator<String>([
  RequiredRule(),
  MinLengthRule(3),
  MaxLengthRule(20),
]);

final asyncValidator = AsyncValidator<String>([
  UsernameAvailabilityRule(
    checkAvailability: _checkUsernameAvailability,
  ),
]);

// Compose them together
final compositeValidator = CompositeValidator<String>(
  syncValidators: [syncValidator],
  asyncValidators: [asyncValidator],
);

// Use in your form
TextFormField(
  validator: compositeValidator,
  // ...
)

// Clean up resources
@override
void dispose() {
  compositeValidator.dispose();
  super.dispose();
}
```

## Asynchronous validation rules

Form Shield supports asynchronous validation for scenarios where validation requires network requests or other async operations (like checking username availability or email uniqueness).

You can create async validation rules by extending the specialized `AsyncValidationRule` class:

#### Example: Username availability checker

```dart
class UsernameAvailabilityRule extends AsyncValidationRule<String> {
  final Future<bool> Function(String username) _checkAvailability;

  const UsernameAvailabilityRule({
    required Future<bool> Function(String username) checkAvailability,
    super.errorMessage = 'This username is already taken',
  }) : _checkAvailability = checkAvailability;

  @override
  ValidationResult validate(String? value) {
    // Basic sync validation for null/empty check
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

When using async validation, use the `AsyncValidator` or `CompositeValidator` class:

```dart
class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  late final AsyncValidator<String> _asyncValidator;
  late final CompositeValidator<String> _compositeValidator;

  @override
  void initState() {
    super.initState();

    _asyncValidator = AsyncValidator<String>([
      UsernameAvailabilityRule(
        checkAvailability: _checkUsernameAvailability,
      ),
    ], debounceDuration: Duration(milliseconds: 500));
    
    _compositeValidator = CompositeValidator<String>(
      syncValidators: [
        Validator<String>([
          RequiredRule(),
          LengthRule(minLength: 3, maxLength: 20),
        ]),
      ],
      asyncValidators: [_asyncValidator],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _compositeValidator.dispose(); // This will handle disposing the async validator
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
        !_compositeValidator.isValidating &&
        _compositeValidator.isValid) {
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
            validator: _compositeValidator,
          ),
          // Show async validation state
          ListenableBuilder(
            listenable: _asyncValidator.asyncState,
            builder: (context, _) {
              if (_compositeValidator.isValidating) {
                return Text('Checking username availability...');
              } else if (!_compositeValidator.isValid && _asyncValidator.errorMessage != null) {
                return Text(
                  _asyncValidator.errorMessage!,
                  style: TextStyle(color: Colors.red),
                );
              } else if (_compositeValidator.isValid) {
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

AsyncValidator includes built-in debouncing to prevent excessive API calls during typing. You can customize the debounce duration:

```dart
AsyncValidator<String>([
  UsernameAvailabilityRule(checkAvailability: _checkUsername),
], debounceDuration: Duration(milliseconds: 800)) // Custom debounce time
```

#### Manually triggering async validation

You can manually trigger async validation using the `validateAsync` method:

```dart
Future<void> _checkUsername() async {
  final isValid = await _asyncValidator.validateAsync(
    _usernameController.text,
    debounceDuration: Duration.zero, // Optional: skip debouncing
  );
  
  if (isValid) {
    // Username is valid and available
  }
}
```

### FAQ
#### How can i show live async validation error message?
You can use the `ListenableBuilder` widget to listen to the async validation state and show the error message when it becomes available. Here's an example:

```dart
```dart
ListenableBuilder(
  listenable: _asyncValidator.asyncState,
  builder: (context, _) {
    if (_compositeValidator.isValidating) {
      return Text('Checking username availability...');
    } else if (!_compositeValidator.isValid && _asyncValidator.errorMessage != null) {
      return Text(
        _asyncValidator.errorMessage!,
        style: TextStyle(color: Colors.red),
      );
    } else if (_compositeValidator.isValid) {
      return Text(
        'Username is available',
        style: TextStyle(color: Colors.green),
      );
    }
    return SizedBox.shrink();
  },
)
```
This will show the error message when the async validation fails, and a success message when it passes.

For live validation feedback as the user types, make sure to set `autovalidateMode` on your Form:

```dart
Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.always, // Enable live validation
  child: Column(
    // Form fields...
  ),
)
```

This ensures validation runs automatically whenever input changes, providing immediate feedback.

## Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggest improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
