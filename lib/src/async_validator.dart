import 'dart:async';
import 'package:form_shield/form_shield.dart';

/// A validator specifically designed for asynchronous validation operations.
///
/// This class handles debouncing of validation requests and maintains the state
/// of asynchronous validation operations.
class AsyncValidator<T> {
  /// The list of validation rules to apply.
  final List<ValidationRule<T>> _rules;

  /// The state of asynchronous validation.
  final AsyncValidationState _asyncState;

  Timer? _debounceTimer;

  /// Default debounce duration for async validation.
  final Duration _debounceDuration;

  T? _lastValidatedValue;

  /// Creates an immutable `AsyncValidator` instance with the provided list of rules.
  AsyncValidator(
    List<ValidationRule<T>> rules, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  })  : _rules = List.unmodifiable(rules),
        _asyncState = AsyncValidationState(),
        _debounceDuration = debounceDuration;

  /// Creates a new `AsyncValidator` instance by adding the provided [rule]
  /// to the existing list of rules, preserving the debounce duration.
  AsyncValidator<T> addRule(ValidationRule<T> rule) {
    return AsyncValidator<T>([..._rules, rule],
        debounceDuration: _debounceDuration);
  }

  /// Returns the async validation state.
  AsyncValidationState get asyncState => _asyncState;

  /// Returns true if async validation is currently in progress.
  bool get isValidating => _asyncState.isValidating;

  /// Returns true if the last async validation was successful.
  bool get isValid => _asyncState.isValid;

  /// Returns the current error message from async validation.
  String? get errorMessage => _asyncState.errorMessage;

  /// Triggers validation for the given [value] if it differs from the last validated value.
  void validate(T? value) {
    if (value != _lastValidatedValue) {
      _lastValidatedValue = value;
      _triggerAsyncValidation(value);
    }
  }

  /// Triggers asynchronous validation with debouncing for the given [value].
  void _triggerAsyncValidation(T? value) {
    _debounceTimer?.cancel();
    _asyncState.validating();

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

  /// Resets the async validation state.
  void reset() {
    _asyncState.reset();
  }
}
