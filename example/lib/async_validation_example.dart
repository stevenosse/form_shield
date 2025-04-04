import 'dart:async';
import 'package:flutter/material.dart';
import 'package:form_shield/form_shield.dart';

class UsernameAvailabilityRule extends ValidationRule<String> {
  final Future<bool> Function(String username) _checkAvailability;

  const UsernameAvailabilityRule({
    required Future<bool> Function(String username) checkAvailability,
    super.errorMessage = 'This username is already taken',
  }) : _checkAvailability = checkAvailability;

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.error('Username cannot be empty');
    }
    return const ValidationResult.success();
  }

  @override
  Future<ValidationResult> validateAsync(String? value) async {
    final syncResult = validate(value);
    if (!syncResult.isValid) {
      return syncResult;
    }

    try {
      final isAvailable = await _checkAvailability(value!);
      if (isAvailable) {
        return const ValidationResult.success();
      } else {
        return ValidationResult.error(errorMessage);
      }
    } catch (e) {
      return ValidationResult.error('Error checking username availability: $e');
    }
  }
}

class AsyncValidationExample extends StatefulWidget {
  const AsyncValidationExample({super.key});

  @override
  State<AsyncValidationExample> createState() => _AsyncValidationExampleState();
}

class _AsyncValidationExampleState extends State<AsyncValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  late final Validator<String> _usernameValidator;

  @override
  void initState() {
    super.initState();

    _usernameValidator = Validator.forString([
      const RequiredRule(errorMessage: 'Username is required'),
      LengthRule(
        minLength: 3,
        maxLength: 20,
        errorMessage: 'Username must be between 3 and 20 characters',
      ),
      UsernameAvailabilityRule(
        checkAvailability: _checkUsernameAvailability,
        errorMessage: 'This username is already taken',
      ),
    ], debounceDuration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _usernameValidator.dispose();
    super.dispose();
  }

  Future<bool> _checkUsernameAvailability(String username) async {
    await Future.delayed(const Duration(seconds: 1));
    final takenUsernames = ['admin', 'user', 'test', 'flutter'];
    return !takenUsernames.contains(username.toLowerCase());
  }

  void _submitForm() {
    final asyncState = _usernameValidator.asyncState;
    if (_formKey.currentState!.validate() &&
        !asyncState.isValidating &&
        asyncState.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (!asyncState.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Validation failed: ${asyncState.errorMessage}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified Validation API Example'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.person_add, size: 80),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username with Async Validation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ListenableBuilder(
                            listenable: _usernameValidator.asyncState,
                            builder: (context, child) {
                              Widget? suffixIcon;
                              if (_usernameValidator.asyncState.isValidating) {
                                suffixIcon = const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              } else if (_usernameValidator
                                  .asyncState
                                  .isValid) {
                                suffixIcon = const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                );
                              } else if (!_usernameValidator
                                  .asyncState
                                  .isValid) {
                                suffixIcon = const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                );
                              }

                              final syncError =
                                  _usernameController.text.isNotEmpty
                                      ? _usernameValidator(
                                        _usernameController.text,
                                      )
                                      : null;

                              final errorToShow =
                                  syncError ??
                                  (!_usernameValidator.asyncState.isValid &&
                                          !_usernameValidator
                                              .asyncState
                                              .isValidating
                                      ? _usernameValidator
                                          .asyncState
                                          .errorMessage
                                      : null);

                              return TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'Choose a username',
                                  prefixIcon: const Icon(Icons.person),
                                  suffixIcon:
                                      suffixIcon != null
                                          ? Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: suffixIcon,
                                          )
                                          : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(width: 2),
                                  ),
                                  errorText: errorToShow,
                                  errorStyle: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                validator: (value) {
                                  final syncResult = _usernameValidator.call(
                                    value,
                                  );
                                  if (syncResult != null) return syncResult;

                                  if (!_usernameValidator.asyncState.isValid &&
                                      !_usernameValidator
                                          .asyncState
                                          .isValidating) {
                                    return _usernameValidator
                                        .asyncState
                                        .errorMessage;
                                  }

                                  return null;
                                },
                                onChanged: (value) {
                                  if (value.length >= 3) {
                                    setState(() {
                                      _usernameValidator(value);
                                    });
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The username field combines both sync and async validation rules in a single list.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ListenableBuilder(
                        listenable: _usernameValidator.asyncState,
                        builder: (context, _) {
                          return ElevatedButton(
                            onPressed:
                                _usernameValidator.asyncState.isValidating
                                    ? null
                                    : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Try usernames: "admin", "user", "test", or "flutter" to see async validation in action',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
