// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(min, max) => "Date must be between ${min} and ${max}";

  static String m1(date) => "Date must be on or after ${date}";

  static String m2(date) => "Date must be on or before ${date}";

  static String m3(min, max) => "Must be between ${min} and ${max} characters";

  static String m4(max) => "Must be at most ${max} characters";

  static String m5(min) => "Must be at least ${min} characters";

  static String m6(length) =>
      "Password must be at least ${length} characters long";

  static String m7(protocols) =>
      "URL must use one of the following protocols: ${protocols}";

  static String m8(min, max) => "Must be between ${min} and ${max}";

  static String m9(max) => "Must be at most ${max}";

  static String m10(min) => "Must be at least ${min}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "dateBetween": m0,
        "dateOnOrAfter": m1,
        "dateOnOrBefore": m2,
        "endDateAfterStart": MessageLookupByLibrary.simpleMessage(
          "End date must be after start date",
        ),
        "invalidCreditCard": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid credit card number",
        ),
        "invalidDate": MessageLookupByLibrary.simpleMessage("Invalid date"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid email address",
        ),
        "invalidIpAddress": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid IP address",
        ),
        "invalidIpv4Address": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid IPv4 address",
        ),
        "invalidIpv4OrIpv6Address": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid IPv4 or IPv6 address",
        ),
        "invalidIpv6Address": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid IPv6 address",
        ),
        "invalidLength": MessageLookupByLibrary.simpleMessage("Invalid length"),
        "invalidPhone": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid phone number",
        ),
        "invalidUrl": MessageLookupByLibrary.simpleMessage(
          "Please enter a valid URL",
        ),
        "invalidValue": MessageLookupByLibrary.simpleMessage("Invalid value"),
        "lengthBetween": m3,
        "lengthMax": m4,
        "lengthMin": m5,
        "passwordDigit": MessageLookupByLibrary.simpleMessage(
          "Password must contain at least one digit",
        ),
        "passwordLowercase": MessageLookupByLibrary.simpleMessage(
          "Password must contain at least one lowercase letter",
        ),
        "passwordMinLength": m6,
        "passwordRequirements": MessageLookupByLibrary.simpleMessage(
          "Password does not meet requirements",
        ),
        "passwordSpecialChar": MessageLookupByLibrary.simpleMessage(
          "Password must contain at least one special character",
        ),
        "passwordUppercase": MessageLookupByLibrary.simpleMessage(
          "Password must contain at least one uppercase letter",
        ),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
          "Passwords do not match",
        ),
        "requiredField": MessageLookupByLibrary.simpleMessage(
          "This field is required",
        ),
        "urlProtocolRequired": m7,
        "valueBetween": m8,
        "valueMax": m9,
        "valueMin": m10,
      };
}
