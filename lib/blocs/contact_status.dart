import 'package:courseplease/blocs/instagram_status.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

abstract class ContactStatusCubit extends Bloc {
  final initialStatus = ContactStatus(description: '', problems: null);

  final _outStatusController = BehaviorSubject<ContactStatus>();
  Stream<ContactStatus> get outStatus => _outStatusController.stream;

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
    final status = getContactStatus(_contact);
    _outStatusController.sink.add(status);
  }

  @protected
  ContactStatus getContactStatus(EditableContact contact);

  @protected
  String getOnOffDescription(EditableContact contact) {
    return contact.downloadEnabled ? "On." : "Off. Not downloading anything.";
  }

  @override
  void dispose() {
    _outStatusController.close();
  }
}

class ContactStatus {
  final String description;
  final String problems; // Nullable

  ContactStatus({
    @required this.description,
    @required this.problems,
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
