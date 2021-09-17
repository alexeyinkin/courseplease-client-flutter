import 'package:courseplease/utils/auth/platform.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

/// All the info that can be obtained about a device.
class DeviceInfo {
  final PlatformInstance platform;
  final AndroidDeviceInfo? androidDeviceInfo;
  final IosDeviceInfo? iosDeviceInfo;

  DeviceInfo._({
    required this.platform,
    required this.androidDeviceInfo,
    required this.iosDeviceInfo,
  });

  static Future<DeviceInfo> getCurrent() async {
    return DeviceInfo._(
      platform:           PlatformInstance.current(),
      androidDeviceInfo:  await _getAndroidDeviceInfo(),
      iosDeviceInfo:      await _getIosDeviceInfo(),
    );
  }

  static Future<AndroidDeviceInfo?> _getAndroidDeviceInfo() async {
    if (defaultTargetPlatform != TargetPlatform.android) return null;

    final plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo?> _getIosDeviceInfo() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return null;

    final plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['platform']           = platform.toJson();
    map['androidDeviceInfo']  = _androidDeviceInfoToJson();
    map['iosDeviceInfo']      = _iosDeviceInfoToJson();

    return map;
  }

  Map<String, dynamic>? _androidDeviceInfoToJson() {
    final androidDeviceInfo = this.androidDeviceInfo;
    if (androidDeviceInfo == null) return null;

    final map = Map<String, dynamic>();

    map['androidId']          = androidDeviceInfo.androidId;
    map['board']              = androidDeviceInfo.board;
    map['bootloader']         = androidDeviceInfo.bootloader;
    map['brand']              = androidDeviceInfo.brand;
    map['device']             = androidDeviceInfo.device;
    map['display']            = androidDeviceInfo.display;
    map['hardware']           = androidDeviceInfo.hardware;
    map['fingerprint']        = androidDeviceInfo.fingerprint;
    map['host']               = androidDeviceInfo.host;
    map['id']                 = androidDeviceInfo.id;
    map['isPhysicalDevice']   = androidDeviceInfo.isPhysicalDevice;
    map['manufacturer']       = androidDeviceInfo.manufacturer;
    map['model']              = androidDeviceInfo.model;
    map['product']            = androidDeviceInfo.product;
    map['supported32BitAbis'] = androidDeviceInfo.supported32BitAbis;
    map['supported64BitAbis'] = androidDeviceInfo.supported64BitAbis;
    map['supportedAbis']      = androidDeviceInfo.supportedAbis;
    map['systemFeatures']     = androidDeviceInfo.systemFeatures;
    map['tags']               = androidDeviceInfo.tags;
    map['type']               = androidDeviceInfo.type;
    map['version']            = _androidBuildVersionToJson(androidDeviceInfo.version);

    return map;
  }

  Map<String, dynamic> _androidBuildVersionToJson(AndroidBuildVersion androidBuildVersion) {
    final map = Map<String, dynamic>();

    map['baseOS']         = androidBuildVersion.baseOS;
    map['codename']       = androidBuildVersion.codename;
    map['incremental']    = androidBuildVersion.incremental;
    map['previewSdkInt']  = androidBuildVersion.previewSdkInt;
    map['release']        = androidBuildVersion.release;
    map['sdkInt']         = androidBuildVersion.sdkInt;
    map['securityPatch']  = androidBuildVersion.securityPatch;

    return map;
  }

  Map<String, dynamic>? _iosDeviceInfoToJson() {
    final iosDeviceInfo = this.iosDeviceInfo;
    if (iosDeviceInfo == null) return null;

    final map = Map<String, dynamic>();

    map['identifierForVendor']  = iosDeviceInfo.identifierForVendor;
    map['isPhysicalDevice']     = iosDeviceInfo.isPhysicalDevice;
    map['localizedModel']       = iosDeviceInfo.localizedModel;
    map['model']                = iosDeviceInfo.model;
    map['name']                 = iosDeviceInfo.name;
    map['systemName']           = iosDeviceInfo.systemName;
    map['systemVersion']        = iosDeviceInfo.systemVersion;
    map['utsname']              = _iosUtsnameToJson(iosDeviceInfo.utsname);

    return map;
  }

  Map<String, dynamic> _iosUtsnameToJson(IosUtsname iosUtsname) {
    final map = Map<String, dynamic>();

    map['sysname']  = iosUtsname.sysname;
    map['nodename'] = iosUtsname.nodename;
    map['release']  = iosUtsname.release;
    map['version']  = iosUtsname.version;
    map['machine']  = iosUtsname.machine;

    return map;
  }
}
