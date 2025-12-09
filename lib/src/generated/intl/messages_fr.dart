// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(min, max) =>
      "La date doit être comprise entre ${min} et ${max}";

  static String m1(date) => "La date doit être le ou après le ${date}";

  static String m2(date) => "La date doit être le ou avant le ${date}";

  static String m3(min, max) =>
      "Doit contenir entre ${min} et ${max} caractères";

  static String m4(max) => "Doit contenir au plus ${max} caractères";

  static String m5(min) => "Doit contenir au moins ${min} caractères";

  static String m6(length) =>
      "Le mot de passe doit contenir au moins ${length} caractères";

  static String m7(protocols) =>
      "L\'URL doit utiliser l\'un des protocoles suivants : ${protocols}";

  static String m8(min, max) => "Doit être compris entre ${min} et ${max}";

  static String m9(max) => "Doit être au plus ${max}";

  static String m10(min) => "Doit être au moins ${min}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "dateBetween": m0,
        "dateOnOrAfter": m1,
        "dateOnOrBefore": m2,
        "endDateAfterStart": MessageLookupByLibrary.simpleMessage(
          "La date de fin doit être postérieure à la date de début",
        ),
        "invalidCreditCard": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer un numéro de carte de crédit valide",
        ),
        "invalidDate": MessageLookupByLibrary.simpleMessage("Date invalide"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une adresse e-mail valide",
        ),
        "invalidIpAddress": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une adresse IP valide",
        ),
        "invalidIpv4Address": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une adresse IPv4 valide",
        ),
        "invalidIpv4OrIpv6Address": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une adresse IPv4 ou IPv6 valide",
        ),
        "invalidIpv6Address": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une adresse IPv6 valide",
        ),
        "invalidLength":
            MessageLookupByLibrary.simpleMessage("Longueur invalide"),
        "invalidPhone": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer un numéro de téléphone valide",
        ),
        "invalidUrl": MessageLookupByLibrary.simpleMessage(
          "Veuillez entrer une URL valide",
        ),
        "invalidValue": MessageLookupByLibrary.simpleMessage("Valeur invalide"),
        "lengthBetween": m3,
        "lengthMax": m4,
        "lengthMin": m5,
        "passwordDigit": MessageLookupByLibrary.simpleMessage(
          "Le mot de passe doit contenir au moins un chiffre",
        ),
        "passwordLowercase": MessageLookupByLibrary.simpleMessage(
          "Le mot de passe doit contenir au moins une minuscule",
        ),
        "passwordMinLength": m6,
        "passwordRequirements": MessageLookupByLibrary.simpleMessage(
          "Le mot de passe ne respecte pas les exigences",
        ),
        "passwordSpecialChar": MessageLookupByLibrary.simpleMessage(
          "Le mot de passe doit contenir au moins un caractère spécial",
        ),
        "passwordUppercase": MessageLookupByLibrary.simpleMessage(
          "Le mot de passe doit contenir au moins une majuscule",
        ),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
          "Les mots de passe ne correspondent pas",
        ),
        "requiredField": MessageLookupByLibrary.simpleMessage(
          "Ce champ est obligatoire",
        ),
        "urlProtocolRequired": m7,
        "valueBetween": m8,
        "valueMax": m9,
        "valueMin": m10,
      };
}
