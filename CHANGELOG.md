# Changelog

[0.2.2] - 2025-04-04
### Changed
- Update documentation

## [0.2.1] - 2025-04-04
### Changed
- Updated documentation

## [0.2.0] - 2025-04-04

### Added

- New validation rules:
  - `DateRule` - Validates dates with min and max constraints
  - `DateRangeRule` - Validates date ranges between two fields
  - `URLRule` - Validates URLs with optional protocol checking
  - `IPAddressRule` - Validates IPv4 and IPv6 addresses
  - `CreditCardRule` - Validates credit card numbers with Luhn algorithm
- Updated documentation

### Changed

- Improved error message formatting
- Enhanced type inference for validation rules
- Better handling of null values
- Updated documentation with more examples

### Fixed

- Edge cases in phone number validation
- Memory leak in form validation
- Type conversion issues in numeric validators


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