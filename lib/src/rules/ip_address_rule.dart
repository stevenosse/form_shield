import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a string is a valid IP address (IPv4 or IPv6).
class IPAddressRule extends ValidationRule<String> {
  /// Whether to allow IPv4 addresses.
  final bool allowIPv4;

  /// Whether to allow IPv6 addresses.
  final bool allowIPv6;

  /// Regular expression for validating IPv4 addresses.
  static final RegExp _ipv4Regex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

  /// Regular expression for validating IPv6 addresses.
  static final RegExp _ipv6Regex = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$');

  /// Creates an IP address validation rule with the specified configuration and error message.
  ///
  /// By default, both IPv4 and IPv6 addresses are allowed. You can restrict validation
  /// to only IPv4 or only IPv6 by setting the corresponding parameter to false.
  IPAddressRule({
    super.errorMessage = 'Please enter a valid IP address',
    this.allowIPv4 = true,
    this.allowIPv6 = true,
  }) : assert(
            allowIPv4 || allowIPv6, 'At least one IP version must be allowed');

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    final isIPv4 = allowIPv4 && _ipv4Regex.hasMatch(value);
    final isIPv6 = allowIPv6 && _ipv6Regex.hasMatch(value);

    if (!isIPv4 && !isIPv6) {
      if (allowIPv4 && allowIPv6) {
        return ValidationResult.error(
            'Please enter a valid IPv4 or IPv6 address');
      } else if (allowIPv4) {
        return ValidationResult.error('Please enter a valid IPv4 address');
      } else {
        return ValidationResult.error('Please enter a valid IPv6 address');
      }
    }

    return const ValidationResult.success();
  }
}
