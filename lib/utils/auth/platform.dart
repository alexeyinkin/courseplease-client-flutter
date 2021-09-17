import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Contains info from dart's Platform class but in an instance.
class PlatformInstance {
  final Map<String, String> environment;
  final String executable;
  final List<String> executableArguments;
  final String localeName;
  final String localHostname;
  final int numberOfProcessors;
  final String operatingSystem;
  final String operatingSystemVersion;
  final String? packageConfig;
  final String pathSeparator;
  final String resolvedExecutable;
  final Uri script;
  final String version;

  PlatformInstance._({
    required this.environment,
    required this.executable,
    required this.executableArguments,
    required this.localeName,
    required this.localHostname,
    required this.numberOfProcessors,
    required this.operatingSystem,
    required this.operatingSystemVersion,
    required this.packageConfig,
    required this.pathSeparator,
    required this.resolvedExecutable,
    required this.script,
    required this.version,
  });

  factory PlatformInstance.current() {
    if (kIsWeb) return PlatformInstance._createWeb();

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return PlatformInstance._createFromPlatform();

      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        throw UnimplementedError();

      default:
        throw Exception('Unknown platform: ' + defaultTargetPlatform.toString());
    }
  }

  factory PlatformInstance._createFromPlatform() {
    return PlatformInstance._(
        environment:            Platform.environment,
        executable:             Platform.executable,
        executableArguments:    Platform.executableArguments,
        localeName:             Platform.localeName,
        localHostname:          Platform.localHostname,
        numberOfProcessors:     Platform.numberOfProcessors,
        operatingSystem:        Platform.operatingSystem,
        operatingSystemVersion: Platform.operatingSystemVersion,
        packageConfig:          Platform.packageConfig,
        pathSeparator:          Platform.pathSeparator,
        resolvedExecutable:     Platform.resolvedExecutable,
        script:                 Platform.script,
        version:                Platform.version
    );
  }

  factory PlatformInstance._createWeb() {
    return PlatformInstance._(
      environment:              {},
      executable:               '',
      executableArguments:      [],
      localeName:               window.locale.languageCode,
      localHostname:            'localhost',
      numberOfProcessors:       1,
      operatingSystem:          'web', // TODO: Get web OS, maybe from dartHtml.window.navigator.userAgent or with https://pub.dev/packages/platform_detect
      operatingSystemVersion:   '',
      packageConfig:            null,
      pathSeparator:            '/',
      resolvedExecutable:       '',
      script:                   Uri(scheme: 'file', path: '/main.dart'),
      version:                  '777', // TODO: Await https://stackoverflow.com/q/69191408/11382675
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();

    map['environment']            = environment;
    map['executable']             = executable;
    map['executableArguments']    = executableArguments;
    map['localeName']             = localeName;
    map['localHostname']          = localHostname;
    map['numberOfProcessors']     = numberOfProcessors;
    map['operatingSystem']        = operatingSystem;
    map['operatingSystemVersion'] = operatingSystemVersion;
    map['packageConfig']          = packageConfig;
    map['pathSeparator']          = pathSeparator;
    map['resolvedExecutable']     = resolvedExecutable;
    map['script']                 = script.toString();
    map['version']                = version;

    return map;
  }
}
