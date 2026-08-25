// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Flutter Core Base';

  @override
  String get settingsTooltip => 'Cài đặt';

  @override
  String get catalogTitle => 'Danh mục tính năng SDK';

  @override
  String get catalogSubtitle => 'Khám phá các tính năng và module SDK tích hợp trong ứng dụng mẫu.';

  @override
  String get developerSdkSettingsTitle => 'Cài đặt Nhà phát triển & SDK';

  @override
  String get sdkEnvironmentTitle => 'Cấu hình môi trường';

  @override
  String get useDevServerLabel => 'Sử dụng máy chủ Dev';

  @override
  String get connectedDevEnvironment => 'Đang kết nối môi trường Dev';

  @override
  String get connectedProdEnvironment => 'Đang kết nối môi trường Production';

  @override
  String get activeBaseUrlLabel => 'URL gốc đang dùng:';

  @override
  String get mockSdkModeLabel => 'Chế độ Mock SDK';

  @override
  String get mockSdkModeDescription => 'Mô phỏng phản hồi từ SDK mà không phụ thuộc phần cứng thiết bị';

  @override
  String get credentialsTitle => 'Thông tin xác thực & Ghi đè';

  @override
  String get credentialsDescription =>
      'Ghi đè thông tin sandbox mặc định, chỉ áp dụng trên thiết bị này. Để trống nếu muốn giữ mặc định.';

  @override
  String get appTokenLabel => 'App Token';

  @override
  String get clientKeyLabel => 'Client Key';

  @override
  String credentialsActiveHint(String value) {
    return 'Đang dùng: $value';
  }

  @override
  String get resetCredentialsButton => 'Đặt lại mặc định';

  @override
  String get credentialsResetMessage => 'Đã xoá thông tin xác thực ghi đè';

  @override
  String get saveCredentialsButton => 'Lưu thông tin xác thực';

  @override
  String get credentialsSavedMessage => 'Đã cập nhật thông tin xác thực';

  @override
  String get appearanceThemeTitle => 'Giao diện & Chủ đề';

  @override
  String get themeModeLabel => 'Chế độ giao diện';

  @override
  String get themeModeSystem => 'Hệ thống';

  @override
  String get themeModeLight => 'Sáng';

  @override
  String get themeModeDark => 'Tối';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get aboutTitle => 'Giới thiệu';

  @override
  String get sdkVersionLabel => 'Phiên bản ứng dụng:';

  @override
  String get errorNetwork => 'Không kết nối được tới máy chủ. Vui lòng kiểm tra kết nối mạng của thiết bị và thử lại.';

  @override
  String get errorServer => 'Máy chủ không hoàn tất được yêu cầu này. Vui lòng thử lại sau ít phút.';

  @override
  String get errorUnauthorized =>
      'Máy chủ từ chối thông tin xác thực này. Vui lòng kiểm tra app token và client key trong Cài đặt.';

  @override
  String get errorSdk => 'SDK gốc không thể hoàn thành thao tác trên thiết bị này.';

  @override
  String get errorStorage => 'Không đọc được cài đặt cục bộ của ứng dụng.';

  @override
  String get errorUnexpected => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get closeButton => 'Đóng';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get cancelButton => 'Huỷ';

  @override
  String get saveButton => 'Lưu';

  @override
  String get confirmButton => 'Xác nhận';

  @override
  String get somethingWentWrongMessage => 'Đã xảy ra lỗi';

  @override
  String pageNotFoundMessage(String uri) {
    return 'Không tìm thấy trang: $uri';
  }
}
