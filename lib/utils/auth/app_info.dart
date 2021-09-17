import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  final String version;
  final String buildNumber;

  AppInfo._({
    required this.version,
    required this.buildNumber,
  });

  static getCurrent() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return AppInfo._(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['version']      = version;
    map['buildNumber']  = buildNumber;

    return map;
  }
}
