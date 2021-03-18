class ProfileSyncStatus {
  final int runStatus;
  final DateTime? dateTimeUpdate;

  ProfileSyncStatus({
    required this.runStatus,
    required this.dateTimeUpdate,
  });

  factory ProfileSyncStatus.fromMap(Map<String, dynamic> map) {
    final dateTimeUpdateString = map['dateTimeUpdate'];

    return ProfileSyncStatus(
      runStatus:      map['runStatus'],
      dateTimeUpdate: dateTimeUpdateString == null ? null : DateTime.parse(dateTimeUpdateString),
    );
  }

  factory ProfileSyncStatus.from(ProfileSyncStatus object) {
    return ProfileSyncStatus(
      runStatus: object.runStatus,
      dateTimeUpdate: object.dateTimeUpdate,
    );
  }
}
