import 'package:form_shield/form_shield.dart';

/// A validator that can be used with Flutter's form validation system.
///
/// This class provides a way to chain multiple synchronous validation rules
/// and is compatible with Flutter's built-in `FormFieldValidator`.
class Validator<T> {
  /// The list of validation rules to apply.
  final List<ValidationRule<T>> _rules;

  String? _errorMessage;

  /// Creates an immutable `Validator` instance with the provided list of rules.
  Validator._(List<ValidationRule<T>> rules)
      : _rules = List.unmodifiable(rules),
        _errorMessage = null;

  /// Creates a new `Validator` instance by adding the provided [rule]
  /// to the existing list of rules.
  Validator<T> addRule(ValidationRule<T> rule) {
    return Validator<T>._([..._rules, rule]);
  }

  /// Returns the current error message from synchronous validation.
  String? get errorMessage => _errorMessage;

  /// Executes the validation logic for the given [value] against all registered rules.
  ///
  /// Synchronous rules are applied immediately, returning an error message if any fail.
  /// Returns `null` if validation passes.
  String? call(T? value) {
    // Run sync validation
    for (final rule in _rules) {
      final result = rule.validate(value);
      if (!result.isValid) {
        _errorMessage = result.errorMessage;
        return _errorMessage;
      }
    }

    _errorMessage = null;
    return null;
  }
}

String? Function(T?) validator<T>(List<ValidationRule<T>> rules) {
  final v = Validator<T>._(rules);
  return (T? value) => v(value);
}
