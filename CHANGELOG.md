# Changelog

All notable changes to the Form Shield package will be documented in this file.

The format is based on [Keep a changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-04-03

### Added

- Initial release of Form Shield
- Core validation framework with `ValidationRule` abstract class and `ValidationResult` class
- `Validator` class with support for chaining multiple validation rules
- Type-specific validator factory methods: `forString()`, `forNumber()`, `forBoolean()`, and `forDate()`
- Built-in validation rules:
  - `RequiredRule` - Validates that a value is not null or empty
  - `EmailRule` - Validates email addresses with customizable regex pattern
  - `PasswordRule` - Validates passwords with configurable complexity requirements
  - `PasswordMatchRule` - Validates that passwords match
  - `LengthRule` - Validates string length with min and max constraints
  - `MinLengthRule` - Validates minimum string length
  - `MaxLengthRule` - Validates maximum string length
  - `ValueRule` - Validates numeric values with min and max constraints
  - `MinValueRule` - Validates minimum numeric value
  - `MaxValueRule` - Validates maximum numeric value
  - `PhoneRule` - Validates phone numbers
  - `CountryPhoneRule` - Validates phone numbers for specific countries
  - `CustomRule` - Allows custom validation logic with fixed error message
  - `DynamicCustomRule` - Allows custom validation logic with dynamic error messages
- Seamless integration with Flutter's form validation system
- Example login form implementation