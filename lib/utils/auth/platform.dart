import 'dart:io';

/// Contains info from dart's Platform class but in an instance.
class PlatformInstance {
  // Everything is Nullable in this class.
  final Map<String, String> environment;
  final String executable;
  final List<String> executableArguments;
  final String localeName;
  final String localHostname;
  final int numberOfProcessors;
  final String operatingSystem;
  final String operatingSystemVersion;
  final String packageConfig;
  final String pathSeparator;
  final String resolvedExecutable;
  final Uri script;
  final String version;

  PlatformInstance()
      :
        environment = Platform.environment,
        executable = Platform.executable,
        executableArguments = Platform.executableArguments,
        localeName = Platform.localeName,
        localHostname = Platform.localHostname,
        numberOfProcessors = Platform.numberOfProcessors,
        operatingSystem = Platform.operatingSystem,
        operatingSystemVersion = Platform.operatingSystemVersion,
        packageConfig = Platform.packageConfig,
        pathSeparator = Platform.pathSeparator,
        resolvedExecutable = Platform.resolvedExecutable,
        script = Platform.script,
        version = Platform.version
  ;

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
    map['script']                 = script?.toString();
    map['version']                = version;

    return map;
  }
}
