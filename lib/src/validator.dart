import 'dart:async';
import 'package:form_shield/form_shield.dart';

/// A validator that can be used with Flutter's form validation system.
///
/// This class provides a way to chain multiple validation rules, supports
/// asynchronous validation with state notifiers, and includes a customizable
/// debounce timer for async operations. It is compatible with Flutter's
/// built-in `FormFieldValidator`.
class Validator<T> {
  /// The list of validation rules to apply.
  final List<ValidationRule<T>> _rules;

  /// The state of asynchronous validation.
  final AsyncValidationState _asyncState;

  /// Timer for debouncing async validation calls.
  Timer? _debounceTimer;

  /// Default debounce duration for async validation.
  final Duration _debounceDuration;

  T? _lastValidatedValue;

  /// Creates an immutable `Validator` instance with the provided list of rules.
  Validator(
    List<ValidationRule<T>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  })  : _rules = List.unmodifiable(rules),
        _asyncState = AsyncValidationState(),
        _debounceDuration = debounceDuration;

  static Validator<String> forString(
    List<ValidationRule<String>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    return Validator<String>(rules, debounceDuration: debounceDuration);
  }

  static Validator<num> forNumber(
    List<ValidationRule<num>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    return Validator<num>(rules, debounceDuration: debounceDuration);
  }

  static Validator<bool> forBoolean(
    List<ValidationRule<bool>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    return Validator<bool>(rules, debounceDuration: debounceDuration);
  }

  static Validator<DateTime> forDate(
    List<ValidationRule<DateTime>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    return Validator<DateTime>(rules, debounceDuration: debounceDuration);
  }

  /// Creates a new `Validator` instance by adding the provided [rule]
  /// to the existing list of rules, preserving the debounce duration.
  Validator<T> addRule(ValidationRule<T> rule) {
    return Validator<T>([..._rules, rule], debounceDuration: _debounceDuration);
  }

  /// Returns the async validation state if rules are present, null otherwise.
  AsyncValidationState get asyncState => _asyncState;

  /// Executes the validation logic for the given [value] against all registered rules.
  ///
  /// Synchronous rules are applied immediately, returning an error message if any fail.
  /// If all sync rules pass and rules exist, triggers debounced async validation.
  /// Returns `null` if sync validation passes, with async results reflected in `asyncState`.
  String? call(T? value) {
    // Run sync validation
    for (final rule in _rules) {
      final result = rule.validate(value);
      if (!result.isValid) {
        _asyncState.reset();
        return result.errorMessage;
      }
    }

    if (value != _lastValidatedValue) {
      _lastValidatedValue = value;
      _triggerAsyncValidation(value);
    }

    return null;
  }

  /// Triggers asynchronous validation with debouncing for the given [value].
  void _triggerAsyncValidation(T? value) {
    _debounceTimer?.cancel();
    _asyncState.validating();

    // Start a new debounce timer
    _debounceTimer = Timer(_debounceDuration, () async {
      for (final rule in _rules) {
        try {
          final result = await rule.validateAsync(value);
          if (!result.isValid) {
            _asyncState.invalid(result.errorMessage!);
            return;
          }
        } catch (e) {
          _asyncState.invalid('Validation error: $e');
          return;
        }
      }
      _asyncState.valid();
    });
  }

  /// Manually triggers async validation with an optional custom debounce duration.
  ///
  /// Returns `true` if all validations pass, `false` otherwise.
  Future<bool> validateAsync(T? value, {Duration? debounceDuration}) async {
    final completer = Completer<bool>();
    _debounceTimer?.cancel();

    _asyncState.validating();

    _debounceTimer = Timer(debounceDuration ?? _debounceDuration, () async {
      for (final rule in _rules) {
        if (completer.isCompleted) break;
        try {
          final result = await rule.validateAsync(value);
          if (!result.isValid) {
            _asyncState.invalid(result.errorMessage!);
            completer.complete(false);
            return;
          }
        } catch (e) {
          _asyncState.invalid('Validation error: $e');
          completer.complete(false);
          return;
        }
      }
      if (!completer.isCompleted) {
        _asyncState.valid();
        completer.complete(true);
      }
    });

    return completer.future;
  }

  /// Cleans up resources by canceling any pending debounce timer.
  void dispose() {
    _debounceTimer?.cancel();
  }
}
