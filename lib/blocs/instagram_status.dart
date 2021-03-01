import 'dart:async';
import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'model_by_id.dart';

class InstagramStatusCubit extends ContactStatusCubit {
  final _newPhotoSubjectBloc = ModelByIdBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );
  StreamSubscription _newPhotoSubjectSubscription;
  ProductSubject _newPhotoSubject; // Nullable

  InstagramStatusCubit() {
    _newPhotoSubjectSubscription = _newPhotoSubjectBloc.outState.listen(
      (state) => _onNewPhotoSubjectChange(state.object)
    );
  }

  void _onNewPhotoSubjectChange(ProductSubject subject) {
    _newPhotoSubject = subject;
    pushOutput();
  }

  @override
  void setContact(EditableContact contact) {
    final params = contact.params as InstagramContactParams;

    if (params.newImageSubjectId != null) {
      _newPhotoSubjectBloc.setCurrentId(params.newImageSubjectId);
    }

    super.setContact(contact);
  }

  @override
  String getProfileSyncOkDescription(EditableContact contact) {
    final descriptionParts = <String>[];
    final params = contact.params as InstagramContactParams;

    if (contact.downloadEnabled) {
      switch (params.newImageAction) {
        case InstagramNewImageAction.unsorted:
          descriptionParts.add(tr('InstagramStatusCubit.addNewImagesToUnsorted'));
          break;
        case InstagramNewImageAction.portfolio:
          final subjectTitle = _newPhotoSubject == null
              ? '...'
              : _newPhotoSubject.title;
          descriptionParts.add(tr('InstagramStatusCubit.addNewImagesToPortfolio', namedArgs:{'subjectTitle': subjectTitle}));
          break;
      }
    }

    return descriptionParts.join(tr('common.sentenceSeparator'));
  }

  @override
  void dispose() {
    _newPhotoSubjectSubscription.cancel();
    super.dispose();
  }
}
