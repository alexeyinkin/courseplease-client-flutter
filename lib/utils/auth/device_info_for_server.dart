import 'package:courseplease/utils/auth/platform.dart';
import 'package:courseplease/utils/auth/device_info.dart';
import 'package:device_info/device_info.dart';
import 'package:meta/meta.dart';

import 'device_info.dart';

/// A subset of [DeviceInfo] that is to be sent to the server.
class DeviceInfoForServer {
  final PlatformInstanceForServer platform;
  final AndroidDeviceInfoForServer androidDeviceInfo; // Nullable.
  final IosDeviceInfoForServer iosDeviceInfo; // Nullable.

  DeviceInfoForServer._({
    @required this.platform,
    @required this.androidDeviceInfo,
    @required this.iosDeviceInfo,
  });

  factory DeviceInfoForServer.fromDeviceInfo(DeviceInfo deviceInfo) {
    return DeviceInfoForServer._(
      platform:           PlatformInstanceForServer.fromPlatformInstance(deviceInfo.platform),
      androidDeviceInfo:  AndroidDeviceInfoForServer.fromAndroidDeviceInfo(deviceInfo.androidDeviceInfo),
      iosDeviceInfo:      IosDeviceInfoForServer.fromIosDeviceInfo(deviceInfo.iosDeviceInfo),
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['platform']           = platform.toJson();
    map['androidDeviceInfo']  = androidDeviceInfo?.toJson();
    map['iosDeviceInfo']      = iosDeviceInfo?.toJson();

    return map;
  }
}

class PlatformInstanceForServer {
  final String localeName;
  final String operatingSystem;
  final String operatingSystemVersion;

  PlatformInstanceForServer._({
    @required this.localeName,
    @required this.operatingSystem,
    @required this.operatingSystemVersion,
  });

  factory PlatformInstanceForServer.fromPlatformInstance(PlatformInstance platformInstance) {
    return PlatformInstanceForServer._(
      localeName:             platformInstance.localeName,
      operatingSystem:        platformInstance.operatingSystem,
      operatingSystemVersion: platformInstance.operatingSystemVersion,
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['localeName']             = localeName;
    map['operatingSystem']        = operatingSystem;
    map['operatingSystemVersion'] = operatingSystemVersion;

    return map;
  }
}

class AndroidDeviceInfoForServer {
  final String androidId;
  final String brand;
  final String model;
  final AndroidBuildVersionForServer version;

  AndroidDeviceInfoForServer._({
    @required this.androidId,
    @required this.brand,
    @required this.model,
    @required this.version,
  });

  factory AndroidDeviceInfoForServer.fromAndroidDeviceInfo(AndroidDeviceInfo androidDeviceInfo) { // Nullable argument and return
    if (androidDeviceInfo == null) return null;

    return AndroidDeviceInfoForServer._(
      androidId:  androidDeviceInfo.androidId,
      brand:      androidDeviceInfo.brand,
      model:      androidDeviceInfo.model,
      version:    AndroidBuildVersionForServer.fromAndroidBuildVersion(androidDeviceInfo.version),
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['androidId']  = androidId;
    map['brand']      = brand;
    map['model']      = model;
    map['version']    = version.toJson();

    return map;
  }
}

class AndroidBuildVersionForServer {
  final String baseOS;
  final String release;
  final int sdkInt;

  AndroidBuildVersionForServer._({
    @required this.baseOS,
    @required this.release,
    @required this.sdkInt,
  });

  factory AndroidBuildVersionForServer.fromAndroidBuildVersion(AndroidBuildVersion androidBuildVersion) {
    return AndroidBuildVersionForServer._(
      baseOS:   androidBuildVersion.baseOS,
      release:  androidBuildVersion.release,
      sdkInt:   androidBuildVersion.sdkInt,
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['baseOS']   = baseOS;
    map['release']  = release;
    map['sdkInt']   = sdkInt;

    return map;
  }
}

// TODO: See this in action and decide what fields to keep. Now using all.
class IosDeviceInfoForServer {
  final String name;
  final String systemName;
  final String systemVersion;
  final String model;
  final String localizedModel;
  final String identifierForVendor;
  final bool isPhysicalDevice;
  final IosUtsnameForServer utsname;

  IosDeviceInfoForServer._({
    @required this.name,
    @required this.systemName,
    @required this.systemVersion,
    @required this.model,
    @required this.localizedModel,
    @required this.identifierForVendor,
    @required this.isPhysicalDevice,
    @required this.utsname,
  });

  factory IosDeviceInfoForServer.fromIosDeviceInfo(IosDeviceInfo iosDeviceInfo) { // Nullable argument and return
    if (iosDeviceInfo == null) return null;

    return IosDeviceInfoForServer._(
      name:                 iosDeviceInfo.name,
      systemName:           iosDeviceInfo.systemName,
      systemVersion:        iosDeviceInfo.systemVersion,
      model:                iosDeviceInfo.model,
      localizedModel:       iosDeviceInfo.localizedModel,
      identifierForVendor:  iosDeviceInfo.identifierForVendor,
      isPhysicalDevice:     iosDeviceInfo.isPhysicalDevice,
      utsname:              IosUtsnameForServer.fromIosUtsname(iosDeviceInfo.utsname),
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['name']                 = name;
    map['systemName']           = systemName;
    map['systemVersion']        = systemVersion;
    map['model']                = model;
    map['localizedModel']       = localizedModel;
    map['identifierForVendor']  = identifierForVendor;
    map['isPhysicalDevice']     = isPhysicalDevice;
    map['utsname']              = utsname.toJson();

    return map;
  }
}

// TODO: See this in action and decide what fields to keep. Now using all.
class IosUtsnameForServer {
  final String sysname;
  final String nodename;
  final String release;
  final String version;
  final String machine;

  IosUtsnameForServer._({
    @required this.sysname,
    @required this.nodename,
    @required this.release,
    @required this.version,
    @required this.machine,
  });

  factory IosUtsnameForServer.fromIosUtsname(IosUtsname iosUtsname) {
    return IosUtsnameForServer._(
      sysname:  iosUtsname.sysname,
      nodename: iosUtsname.nodename,
      release:  iosUtsname.release,
      version:  iosUtsname.version,
      machine:  iosUtsname.machine,
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['sysname']  = sysname;
    map['nodename'] = nodename;
    map['release']  = release;
    map['version']  = version;
    map['machine']  = machine;

    return map;
  }
}
