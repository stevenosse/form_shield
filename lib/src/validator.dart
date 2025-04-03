import 'validation_rule.dart';

/// A validator that can be used with Flutter's form validation system.
///
/// This class provides a way to chain multiple validation rules and
/// is compatible with Flutter's built-in form validation.
/// A generic validator class designed for integration with Flutter's form
/// validation mechanism.
///
/// This class enables the chaining of multiple `ValidationRule` instances
/// and provides a `call` method compatible with `FormFieldValidator`.
class Validator<T> {
  /// The list of validation rules to apply.
  final List<ValidationRule<T>> _rules;

  /// Creates a validator with the specified validation rules.
  /// Creates an immutable `Validator` instance with the provided list of rules.
  Validator(List<ValidationRule<T>> rules) : _rules = List.unmodifiable(rules);

  /// Creates a new `Validator` instance by adding the provided [rule]
  /// to the existing list of rules.
  ///
  /// This allows for fluent chaining of validation rules.
  Validator<T> addRule(ValidationRule<T> rule) {
    return Validator<T>([..._rules, rule]);
  }

  /// Executes the validation logic for the given [value] against all registered rules.
  ///
  /// Iterates through the `_rules` list and applies each rule's `validate` method.
  /// Returns `null` if the [value] passes all validation rules.
  /// Otherwise, returns the `errorMessage` from the first `ValidationRule` that fails.
  String? call(T? value) {
    for (final rule in _rules) {
      final result = rule.validate(value);
      if (!result.isValid) {
        return result.errorMessage;
      }
    }
    return null;
  }
}

/// Provides convenient static factory methods for creating `Validator` instances
/// for common data types.
extension ValidatorExtensions on Validator {
  /// Creates a `Validator` specifically for `String` types.
  ///
  /// Takes a list of `ValidationRule<String>` to apply.
  static Validator<String> forString(List<ValidationRule<String>> rules) {
    return Validator<String>(rules);
  }

  /// Creates a `Validator` specifically for `num` types (int or double).
  ///
  /// Takes a list of `ValidationRule<num>` to apply.
  static Validator<num> forNumber(List<ValidationRule<num>> rules) {
    return Validator<num>(rules);
  }

  /// Creates a `Validator` specifically for `bool` types.
  ///
  /// Takes a list of `ValidationRule<bool>` to apply.
  static Validator<bool> forBoolean(List<ValidationRule<bool>> rules) {
    return Validator<bool>(rules);
  }

  /// Creates a `Validator` specifically for `DateTime` types.
  ///
  /// Takes a list of `ValidationRule<DateTime>` to apply.
  static Validator<DateTime> forDate(List<ValidationRule<DateTime>> rules) {
    return Validator<DateTime>(rules);
  }
}
