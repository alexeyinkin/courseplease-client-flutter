import 'package:courseplease/blocs/instagram_status.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/contact_class_enum.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/profile_sync_status.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

abstract class ContactStatusCubit extends Bloc {
  final _outStatusController = BehaviorSubject<ReadableProfileSyncStatus>();
  Stream<ReadableProfileSyncStatus> get outStatus => _outStatusController.stream;

  EditableContact _contact;

  ContactStatusCubit({
    required EditableContact contact,
  }) :
      _contact = contact
  {
    pushOutput();
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
        description: tr('ContactStatusCubit.downloadEnabledFalse'),
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
        descriptionParts.add(_getLastSynchronized(contact.profileSyncStatus));
        break;
      case RunStatus.running:
        descriptionParts.add(tr('ContactStatusCubit.synchronizingNow'));
        break;
    }

      return ReadableProfileSyncStatus(
        status: contact.profileSyncStatus,
        description: descriptionParts.join(tr('common.sentenceSeparator')),
      );
  }

  @protected
  String? getProfileSyncOkDescription(EditableContact contact) {
    return null;
  }

  String _getLastSynchronized(ProfileSyncStatus status) {
    final dateTimeUpdate = status.dateTimeUpdate;

    if (dateTimeUpdate == null) {
      throw Exception('Complete status must have dateTimeUpdate');
    }

    final durationAgo = formatLongRoughDurationAgo(
      DateTime.now().difference(dateTimeUpdate),
    );
    return tr('ContactStatusCubit.lastSynchronized', namedArgs: {'durationAgo': durationAgo});
  }

  ReadableProfileSyncStatus _getProfileSyncErrorStatus(EditableContact contact) {
    final descriptionParts = <String>[];

    descriptionParts.add(_getErrorLastTried(contact.profileSyncStatus));

    return ReadableProfileSyncStatus(
      status: contact.profileSyncStatus,
      description: descriptionParts.join(tr('common.sentenceSeparator')),
    );
  }

  String _getErrorLastTried(ProfileSyncStatus status) {
    final dateTimeUpdate = status.dateTimeUpdate;

    if (dateTimeUpdate == null) {
      throw Exception('Error status must have dateTimeUpdate when the error was caused');
    }

    final durationAgo = formatLongRoughDurationAgo(
      DateTime.now().difference(dateTimeUpdate),
    );
    return tr('ContactStatusCubit.errorLastTried', namedArgs: {'durationAgo': durationAgo});
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
    required this.status,
    required this.description,
  });
}

class ContactStatusCubitFactory {
  ContactStatusCubit? create(EditableContact contact) {
    switch (contact.className) {
      case ContactClassEnum.instagram:
        return InstagramStatusCubit(contact: contact);
    }

    return null;
  }
}
