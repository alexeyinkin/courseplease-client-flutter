import 'package:courseplease/blocs/instagram_status.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/profile_sync_status.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

abstract class ContactStatusCubit extends Bloc {
  final _outStatusController = BehaviorSubject<ReadableProfileSyncStatus>();
  Stream<ReadableProfileSyncStatus> get outStatus => _outStatusController.stream;

  EditableContact _contact;

  void setContact(EditableContact contact) {
    if (contact != _contact) {
      // Contact will only change if it is re-parsed from an API request
      // so this gives no false-positive rebuilds.
      _contact = contact;
      pushOutput();
    }
  }

  @protected
  void pushOutput() {
    final status = getProfileSyncStatus(_contact);
    _outStatusController.sink.add(status);
  }

  @protected
  ReadableProfileSyncStatus getProfileSyncStatus(EditableContact contact) {
    if (contact.downloadEnabled == false) {
      return ReadableProfileSyncStatus(
        status: contact.profileSyncStatus,
        description: "Off. Not downloading anything.",
      );
    }

    switch (contact.profileSyncStatus.runStatus) {
      case RunStatus.pending:
        return ReadableProfileSyncStatus(status: contact.profileSyncStatus, description: '');
      case RunStatus.complete:
      case RunStatus.running:
        return _getProfileSyncOkStatus(contact);
      case RunStatus.error:
        return _getProfileSyncErrorStatus(contact);
      default:
        throw Exception('Unknown profile sync run status: ' + contact.profileSyncStatus.runStatus.toString());
    }
  }

  ReadableProfileSyncStatus _getProfileSyncOkStatus(EditableContact contact) {
    final descriptionParts = <String>[];
    final classSpecific = getProfileSyncOkDescription(contact);

    if (classSpecific != null) {
      descriptionParts.add(classSpecific);
    }

    switch (contact.profileSyncStatus.runStatus) {
      case RunStatus.complete:
        descriptionParts.add(_getLastSynced(contact.profileSyncStatus));
        break;
      case RunStatus.running:
        descriptionParts.add("Synchronizing now.");
        break;
    }

      return ReadableProfileSyncStatus(
        status: contact.profileSyncStatus,
        description: descriptionParts.join(' '),
      );
  }

  @protected
  String getProfileSyncOkDescription(EditableContact contact) { // Return nullable
    return null;
  }

  String _getLastSynced(ProfileSyncStatus status) {
    final duration = DateTime.now().difference(status.dateTimeUpdate);
    return "Last sync " + duration.inMinutes.toString() + " min ago.";
  }

  ReadableProfileSyncStatus _getProfileSyncErrorStatus(EditableContact contact) {
    final descriptionParts = <String>[];

    descriptionParts.add("Error.");
    descriptionParts.add(_getLastTried(contact.profileSyncStatus));

    return ReadableProfileSyncStatus(
      status: contact.profileSyncStatus,
      description: descriptionParts.join(' '),
    );
  }

  String _getLastTried(ProfileSyncStatus status) {
    final duration = DateTime.now().difference(status.dateTimeUpdate);
    return "Last tried " + duration.inMinutes.toString() + " min ago.";
  }

  @override
  void dispose() {
    _outStatusController.close();
  }
}

class ReadableProfileSyncStatus {
  final ProfileSyncStatus status;
  final String description;

  ReadableProfileSyncStatus({
    @required this.status,
    @required this.description,
  });
}

class ContactStatusCubitFactory {
  ContactStatusCubit create(EditableContact contact) { // Return nullable
    switch (contact.className) {
      case 'instagram':
        return InstagramStatusCubit();
    }

    return null;
  }
}
