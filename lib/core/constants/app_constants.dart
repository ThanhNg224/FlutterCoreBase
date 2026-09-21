/// App-wide global constants
abstract class AppConstants {
  static const String appName = 'Flutter Core Base';

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Default mock latency, chosen so skeleton loaders are visible without
  // making the demo feel broken.
  static const Duration mockSdkDelay = Duration(milliseconds: 400);
}
