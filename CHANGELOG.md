# Changelog

## [0.6.1]

### Changed
- Changelog ><

## [0.6.0] - 2025-04-20
### Added
- Customization options for validation error messages on specific password rules

### Changed
- Update documentation

## [0.5.0] - 2025-04-19
### Added
- Introduce `FormInputValueRule` for validating numeric values with min and max constraints. The main difference with `ValueRule` is that it works with form inputs (hence accepts `String?` as value).

### Changed
- Update documentation

## [0.4.1] - 2025-04-14
### Fixed
- Fix regex pattern for email validation to correctly handle multiple domains

## [0.4.0] - 2025-04-08
### Added
- Introduce `AsyncValidator` class for handling asynchronous validation
- New `CompositeValidator` class for combining multiple validators (to offer an unified API for both sync and async validation)
- Update readme with new async validation examples

## [0.3.0] - 2025-04-05
### Added
- Asynchronous validation support:
  - New `AsyncValidationRule` base class for creating async-specific validation rules
  - Async validation state tracking with `AsyncValidationState` class
  - Debouncing support for async validation to prevent excessive API calls
  - Manual async validation triggering with `validateAsync()` method
  - Example implementation of username availability checking
- New properties for validation state management:
  - `isValidating` - Indicates if async validation is in progress
  - `isValid` - Indicates if the last async validation was successful
  - `errorMessage` - Provides the current error message from either sync or async validation

## [0.2.2] - 2025-04-04
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