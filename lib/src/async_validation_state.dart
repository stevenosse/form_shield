import 'package:flutter/foundation.dart';

/// Manages the state of asynchronous validation with notifiers.
class AsyncValidationState extends ValueNotifier<AsyncValidationStateData> {
  AsyncValidationState() : super(AsyncValidationStateData.initial());

  void validating() => value = AsyncValidationStateData.validating();
  void valid() => value = AsyncValidationStateData.valid();
  void invalid(String message) =>
      value = AsyncValidationStateData.invalid(message);
  void reset() => value = AsyncValidationStateData.initial();

  bool get isValidating => value.isValidating;
  bool get isValid => value.isValid ?? false;
  String? get errorMessage => value.errorMessage;
}

class AsyncValidationStateData {
  final bool isValidating;
  final bool? isValid;
  final String? errorMessage;

  const AsyncValidationStateData._({
    required this.isValidating,
    this.isValid,
    this.errorMessage,
  });

  factory AsyncValidationStateData.initial() =>
      const AsyncValidationStateData._(isValidating: false);
  factory AsyncValidationStateData.validating() =>
      const AsyncValidationStateData._(isValidating: true);
  factory AsyncValidationStateData.valid() =>
      const AsyncValidationStateData._(isValidating: false, isValid: true);
  factory AsyncValidationStateData.invalid(String message) =>
      AsyncValidationStateData._(
        isValidating: false,
        isValid: false,
        errorMessage: message,
      );

  @override
  String toString() {
    return 'AsyncValidationStateData(isValidating: $isValidating, isValid: $isValid, errorMessage: $errorMessage)';
  }
}
