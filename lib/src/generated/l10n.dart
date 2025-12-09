// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class FormShieldI18n {
  FormShieldI18n();

  static FormShieldI18n? _current;

  static FormShieldI18n get current {
    assert(
      _current != null,
      'No instance of FormShieldI18n was loaded. Try to initialize the FormShieldI18n delegate before accessing FormShieldI18n.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<FormShieldI18n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = FormShieldI18n();
      FormShieldI18n._current = instance;

      return instance;
    });
  }

  static FormShieldI18n of(BuildContext context) {
    final instance = FormShieldI18n.maybeOf(context);
    assert(
      instance != null,
      'No instance of FormShieldI18n present in the widget tree. Did you add FormShieldI18n.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static FormShieldI18n? maybeOf(BuildContext context) {
    return Localizations.of<FormShieldI18n>(context, FormShieldI18n);
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: 'Error message when a required field is empty',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: 'Error message for invalid email format',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get invalidPhone {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'invalidPhone',
      desc: 'Error message for invalid phone number format',
      args: [],
    );
  }

  /// `Please enter a valid URL`
  String get invalidUrl {
    return Intl.message(
      'Please enter a valid URL',
      name: 'invalidUrl',
      desc: 'Error message for invalid URL format',
      args: [],
    );
  }

  /// `URL must use one of the following protocols: {protocols}`
  String urlProtocolRequired(String protocols) {
    return Intl.message(
      'URL must use one of the following protocols: $protocols',
      name: 'urlProtocolRequired',
      desc: 'Error message when URL protocol is not in allowed list',
      args: [protocols],
    );
  }

  /// `Please enter a valid credit card number`
  String get invalidCreditCard {
    return Intl.message(
      'Please enter a valid credit card number',
      name: 'invalidCreditCard',
      desc: 'Error message for invalid credit card number',
      args: [],
    );
  }

  /// `Please enter a valid IP address`
  String get invalidIpAddress {
    return Intl.message(
      'Please enter a valid IP address',
      name: 'invalidIpAddress',
      desc: 'Error message for invalid IP address',
      args: [],
    );
  }

  /// `Please enter a valid IPv4 address`
  String get invalidIpv4Address {
    return Intl.message(
      'Please enter a valid IPv4 address',
      name: 'invalidIpv4Address',
      desc: 'Error message for invalid IPv4 address',
      args: [],
    );
  }

  /// `Please enter a valid IPv6 address`
  String get invalidIpv6Address {
    return Intl.message(
      'Please enter a valid IPv6 address',
      name: 'invalidIpv6Address',
      desc: 'Error message for invalid IPv6 address',
      args: [],
    );
  }

  /// `Please enter a valid IPv4 or IPv6 address`
  String get invalidIpv4OrIpv6Address {
    return Intl.message(
      'Please enter a valid IPv4 or IPv6 address',
      name: 'invalidIpv4OrIpv6Address',
      desc:
          'Error message when both IPv4 and IPv6 are allowed but neither matches',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: 'Error message when password confirmation doesn\'t match',
      args: [],
    );
  }

  /// `Password does not meet requirements`
  String get passwordRequirements {
    return Intl.message(
      'Password does not meet requirements',
      name: 'passwordRequirements',
      desc: 'Generic error for password not meeting requirements',
      args: [],
    );
  }

  /// `Password must be at least {length} characters long`
  String passwordMinLength(int length) {
    return Intl.message(
      'Password must be at least $length characters long',
      name: 'passwordMinLength',
      desc: 'Error message for password minimum length',
      args: [length],
    );
  }

  /// `Password must contain at least one uppercase letter`
  String get passwordUppercase {
    return Intl.message(
      'Password must contain at least one uppercase letter',
      name: 'passwordUppercase',
      desc: 'Error message when password lacks uppercase letter',
      args: [],
    );
  }

  /// `Password must contain at least one lowercase letter`
  String get passwordLowercase {
    return Intl.message(
      'Password must contain at least one lowercase letter',
      name: 'passwordLowercase',
      desc: 'Error message when password lacks lowercase letter',
      args: [],
    );
  }

  /// `Password must contain at least one digit`
  String get passwordDigit {
    return Intl.message(
      'Password must contain at least one digit',
      name: 'passwordDigit',
      desc: 'Error message when password lacks digit',
      args: [],
    );
  }

  /// `Password must contain at least one special character`
  String get passwordSpecialChar {
    return Intl.message(
      'Password must contain at least one special character',
      name: 'passwordSpecialChar',
      desc: 'Error message when password lacks special character',
      args: [],
    );
  }

  /// `Must be between {min} and {max} characters`
  String lengthBetween(int min, int max) {
    return Intl.message(
      'Must be between $min and $max characters',
      name: 'lengthBetween',
      desc: 'Error message for string length between min and max',
      args: [min, max],
    );
  }

  /// `Must be at least {min} characters`
  String lengthMin(int min) {
    return Intl.message(
      'Must be at least $min characters',
      name: 'lengthMin',
      desc: 'Error message for string minimum length',
      args: [min],
    );
  }

  /// `Must be at most {max} characters`
  String lengthMax(int max) {
    return Intl.message(
      'Must be at most $max characters',
      name: 'lengthMax',
      desc: 'Error message for string maximum length',
      args: [max],
    );
  }

  /// `Invalid length`
  String get invalidLength {
    return Intl.message(
      'Invalid length',
      name: 'invalidLength',
      desc: 'Generic error for invalid string length',
      args: [],
    );
  }

  /// `Must be between {min} and {max}`
  String valueBetween(String min, String max) {
    return Intl.message(
      'Must be between $min and $max',
      name: 'valueBetween',
      desc: 'Error message for numeric value between min and max',
      args: [min, max],
    );
  }

  /// `Must be at least {min}`
  String valueMin(String min) {
    return Intl.message(
      'Must be at least $min',
      name: 'valueMin',
      desc: 'Error message for numeric minimum value',
      args: [min],
    );
  }

  /// `Must be at most {max}`
  String valueMax(String max) {
    return Intl.message(
      'Must be at most $max',
      name: 'valueMax',
      desc: 'Error message for numeric maximum value',
      args: [max],
    );
  }

  /// `Invalid value`
  String get invalidValue {
    return Intl.message(
      'Invalid value',
      name: 'invalidValue',
      desc: 'Generic error for invalid numeric value',
      args: [],
    );
  }

  /// `Invalid date`
  String get invalidDate {
    return Intl.message(
      'Invalid date',
      name: 'invalidDate',
      desc: 'Generic error for invalid date format',
      args: [],
    );
  }

  /// `Date must be between {min} and {max}`
  String dateBetween(String min, String max) {
    return Intl.message(
      'Date must be between $min and $max',
      name: 'dateBetween',
      desc: 'Error message for date between min and max',
      args: [min, max],
    );
  }

  /// `Date must be on or after {date}`
  String dateOnOrAfter(String date) {
    return Intl.message(
      'Date must be on or after $date',
      name: 'dateOnOrAfter',
      desc: 'Error message for date minimum',
      args: [date],
    );
  }

  /// `Date must be on or before {date}`
  String dateOnOrBefore(String date) {
    return Intl.message(
      'Date must be on or before $date',
      name: 'dateOnOrBefore',
      desc: 'Error message for date maximum',
      args: [date],
    );
  }

  /// `End date must be after start date`
  String get endDateAfterStart {
    return Intl.message(
      'End date must be after start date',
      name: 'endDateAfterStart',
      desc: 'Error message when end date is before start date',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<FormShieldI18n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<FormShieldI18n> load(Locale locale) => FormShieldI18n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
