/// String masking and redaction utilities.
abstract final class Redaction {
  /// Rendered in place of a null value.
  static const absentMarker = '(none)';

  /// Masks secret strings (e.g. tokens) keeping visible start and end characters.
  static String secret(String? value, {int visible = 4}) {
    if (value == null) return absentMarker;
    if (value.length <= visible * 2) return '*' * value.length;
    return '${value.substring(0, visible)}…${value.substring(value.length - visible)}';
  }

  /// Masks string keeping only the trailing characters.
  static String tail(String? value, {int visible = 3}) {
    if (value == null) return absentMarker;
    if (value.length <= visible) return '*' * value.length;
    return '${'*' * (value.length - visible)}${value.substring(value.length - visible)}';
  }

  /// Returns string length format `<N chars>`.
  static String length(String? value) => value == null ? absentMarker : '<${value.length} chars>';

  /// Returns runtime type name.
  static String typeOf(Object? value) => value == null ? absentMarker : value.runtimeType.toString();
}
