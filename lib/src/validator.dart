import 'package:form_shield/form_shield.dart';

/// A validator that can be used with Flutter's form validation system.
///
/// This class provides a way to chain multiple synchronous validation rules
/// and is compatible with Flutter's built-in `FormFieldValidator`.
class Validator<T> {
  /// The list of validation rules to apply.
  final List<ValidationRule<T>> _rules;

  String? _syncErrorMessage;

  /// Creates an immutable `Validator` instance with the provided list of rules.
  Validator(List<ValidationRule<T>> rules)
      : _rules = List.unmodifiable(rules),
        _syncErrorMessage = null;

  static Validator<String> forString(List<ValidationRule<String>> rules) {
    return Validator<String>(rules);
  }

  static Validator<num> forNumber(List<ValidationRule<num>> rules) {
    return Validator<num>(rules);
  }

  static Validator<bool> forBoolean(List<ValidationRule<bool>> rules) {
    return Validator<bool>(rules);
  }

  static Validator<DateTime> forDate(List<ValidationRule<DateTime>> rules) {
    return Validator<DateTime>(rules);
  }

  /// Creates a new `Validator` instance by adding the provided [rule]
  /// to the existing list of rules.
  Validator<T> addRule(ValidationRule<T> rule) {
    return Validator<T>([..._rules, rule]);
  }

  /// Returns the current error message from synchronous validation.
  String? get errorMessage => _syncErrorMessage;

  /// Executes the validation logic for the given [value] against all registered rules.
  ///
  /// Synchronous rules are applied immediately, returning an error message if any fail.
  /// Returns `null` if validation passes.
  String? call(T? value) {
    // Run sync validation
    for (final rule in _rules) {
      final result = rule.validate(value);
      if (!result.isValid) {
        _syncErrorMessage = result.errorMessage;
        return _syncErrorMessage;
      }
    }

    _syncErrorMessage = null;
    return null;
  }
}
