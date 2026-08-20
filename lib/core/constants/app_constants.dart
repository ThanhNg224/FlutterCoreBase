/// App-wide global constants
abstract class AppConstants {
  static const String appName = 'Flutter SDK Host Base';
  static const String appVersion = '1.0.0';

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Default Mock Delay
  static const Duration mockSdkDelay = Duration(milliseconds: 1800);
}
