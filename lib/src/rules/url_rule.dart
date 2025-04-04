import '../validation_rule.dart';
import '../validation_result.dart';

/// Validates that a string is a valid URL.
class URLRule extends ValidationRule<String> {
  /// Regular expression for validating URLs.
  final RegExp _urlRegex;

  /// List of allowed protocols (e.g., 'http', 'https', 'ftp').
  final List<String>? _allowedProtocols;

  /// Creates a URL validation rule with the specified error message and configuration.
  ///
  /// The [allowedProtocols] parameter can be used to restrict which URL protocols are considered valid.
  /// If provided, only URLs with the specified protocols will pass validation.
  /// For example, ['http', 'https'] will only allow HTTP and HTTPS URLs.
  ///
  /// If [requireProtocol] is true, URLs must include a protocol (e.g., 'https://') to be valid.
  /// If false, URLs without a protocol (e.g., 'example.com') will also be considered valid.
  URLRule({
    super.errorMessage = 'Please enter a valid URL',
    List<String>? allowedProtocols,
    bool requireProtocol = true,
    String? pattern,
  })  : _allowedProtocols = allowedProtocols,
        _urlRegex = RegExp(
            pattern ??
                (requireProtocol
                    ? r'^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$'
                    : r'^(?:(?:(?:https?|ftp):\/\/))?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$'),
            caseSensitive: true);

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.success();
    }

    if (!_urlRegex.hasMatch(value)) {
      return ValidationResult.error(errorMessage);
    }

    // Check if the URL uses an allowed protocol
    if (_allowedProtocols != null && _allowedProtocols!.isNotEmpty) {
      bool hasAllowedProtocol = false;
      for (final protocol in _allowedProtocols!) {
        if (value.toLowerCase().startsWith('$protocol://')) {
          hasAllowedProtocol = true;
          break;
        }
      }

      if (!hasAllowedProtocol) {
        return ValidationResult.error(
            'URL must use one of the following protocols: ${_allowedProtocols!.join(', ')}');
      }
    }

    return const ValidationResult.success();
  }
}
