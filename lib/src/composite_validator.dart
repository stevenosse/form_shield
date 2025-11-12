import 'async_validator.dart';

/// A validator that composes multiple validators together.
///
/// This class allows chaining both synchronous validators and asynchronous validators,
/// providing a unified API for form validation.
class CompositeValidator<T> {
  final List<String? Function(T?)> _syncValidators;
  final List<AsyncValidator<T>> _asyncValidators;
  String? _syncErrorMessage;

  /// Creates a `CompositeValidator` with the provided lists of validators.
  CompositeValidator._({
    List<String? Function(T?)> syncValidators = const [],
    List<AsyncValidator<T>> asyncValidators = const [],
  })  : _syncValidators = List.unmodifiable(syncValidators),
        _asyncValidators = List.unmodifiable(asyncValidators),
        _syncErrorMessage = null;

  /// Returns true if any async validator is currently validating.
  bool get isValidating =>
      _asyncValidators.any((validator) => validator.isValidating);

  /// Returns true if all async validators have passed validation.
  bool get isValid => _asyncValidators.every((validator) => validator.isValid);

  /// Returns the first error message from sync validators, or if none, the first error from async validators.
  String? get errorMessage {
    if (_syncErrorMessage != null) {
      return _syncErrorMessage;
    }
    for (final validator in _asyncValidators) {
      if (validator.errorMessage != null) {
        return validator.errorMessage;
      }
    }
    return null;
  }

  /// Executes synchronous validation and triggers asynchronous validation for the given value.
  ///
  /// Returns an error message if synchronous validation fails, otherwise null.
  String? call(T? value) {
    for (final v in _syncValidators) {
      final error = v(value);
      if (error != null) {
        _syncErrorMessage = error;
        for (final asyncValidator in _asyncValidators) {
          asyncValidator.reset();
        }
        return error;
      }
    }
    _syncErrorMessage = null;
    for (final validator in _asyncValidators) {
      validator.validate(value);
    }
    return null;
  }

  /// Manually triggers asynchronous validation for all async validators.
  ///
  /// Returns true only if all validations pass.
  Future<bool> validateAsync(T? value) async {
    for (final v in _syncValidators) {
      final error = v(value);
      if (error != null) {
        _syncErrorMessage = error;
        for (final asyncValidator in _asyncValidators) {
          asyncValidator.reset();
        }
        return false;
      }
    }
    _syncErrorMessage = null;
    final results = await Future.wait(
        _asyncValidators.map((validator) => validator.validateAsync(value)));
    return results.every((result) => result);
  }

  /// Resets all async validators.
  void reset() {
    for (final validator in _asyncValidators) {
      validator.reset();
    }
  }

  /// Cleans up resources by disposing all async validators.
  void dispose() {
    for (final validator in _asyncValidators) {
      validator.dispose();
    }
  }
}

/// Creates a `CompositeValidator` with the provided list of synchronous validators.
CompositeValidator<T> compositeValidator<T>(
  final List<String? Function(T?)> syncValidators,
  final List<AsyncValidator<T>> asyncValidators,
) =>
    CompositeValidator<T>._(
      syncValidators: syncValidators,
      asyncValidators: asyncValidators,
    );
