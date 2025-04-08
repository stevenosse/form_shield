import 'package:form_shield/form_shield.dart';

/// A validator that composes multiple validators together.
///
/// This class allows chaining both synchronous validators and asynchronous validators,
/// providing a unified API for form validation.
class ComposedValidator<T> {
  /// The list of synchronous validators.
  final List<Validator<T>> _syncValidators;
  
  /// The list of asynchronous validators.
  final List<AsyncValidator<T>> _asyncValidators;

  /// Creates a `ComposedValidator` with the provided lists of validators.
  ComposedValidator({
    List<Validator<T>> syncValidators = const [],
    List<AsyncValidator<T>> asyncValidators = const [],
  })  : _syncValidators = List.unmodifiable(syncValidators),
        _asyncValidators = List.unmodifiable(asyncValidators);

  /// Returns true if any async validator is currently validating.
  bool get isValidating => _asyncValidators.any((validator) => validator.isValidating);

  /// Returns true if all async validators have passed validation.
  bool get isValid => _asyncValidators.every((validator) => validator.isValid);

  /// Returns the first error message from sync validators, or if none, the first error from async validators.
  String? get errorMessage {
    for (final validator in _syncValidators) {
      if (validator.errorMessage != null) {
        return validator.errorMessage;
      }
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
    // Run all sync validators
    for (final validator in _syncValidators) {
      final error = validator(value);
      if (error != null) {
        // Reset all async validators if sync validation fails
        for (final asyncValidator in _asyncValidators) {
          asyncValidator.reset();
        }
        return error;
      }
    }
    
    // If sync validation passes, trigger all async validators
    for (final validator in _asyncValidators) {
      validator.validate(value);
    }
    
    return null;
  }

  /// Manually triggers asynchronous validation for all async validators.
  ///
  /// Returns true only if all validations pass.
  Future<bool> validateAsync(T? value) async {
    final results = await Future.wait(
      _asyncValidators.map((validator) => validator.validateAsync(value))
    );
    
    return results.every((result) => result);
  }

  /// Cleans up resources by disposing all async validators.
  void dispose() {
    for (final validator in _asyncValidators) {
      validator.dispose();
    }
  }
}
