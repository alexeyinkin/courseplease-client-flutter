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
  final _newImageSubjectBloc = ModelByIdBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );
  late StreamSubscription _newPhotoSubjectSubscription;
  ProductSubject? _newPhotoSubject;

  InstagramStatusCubit({
    required EditableContact contact,
  }) : super(
    contact: contact,
  ) {
    _newPhotoSubjectSubscription = _newImageSubjectBloc.outState.listen(
      (state) => _onNewPhotoSubjectChange(state.object)
    );

    final params = contact.params as InstagramContactParams;

    if (params.newImageSubjectId != null) {
      _newImageSubjectBloc.setCurrentId(params.newImageSubjectId);
    }
  }

  void _onNewPhotoSubjectChange(ProductSubject? subject) {
    _newPhotoSubject = subject;
    pushOutput();
  }

  @override
  String getProfileSyncOkDescription(EditableContact contact) {
    final descriptionParts = <String>[];
    final params = contact.params as InstagramContactParams;

    final subjectTitle = _newPhotoSubject == null
        ? '...'
        : _newPhotoSubject!.title;

    if (contact.downloadEnabled) {
      switch (params.newImageAction) {
        case InstagramNewImageAction.unsorted:
          descriptionParts.add(tr('InstagramStatusCubit.addNewImagesToUnsorted'));
          break;
        case InstagramNewImageAction.backstage:
          descriptionParts.add(tr('InstagramStatusCubit.addNewImagesToBackstage', namedArgs:{'subjectTitle': subjectTitle}));
          break;
        case InstagramNewImageAction.portfolio:
          descriptionParts.add(tr('InstagramStatusCubit.addNewImagesToPortfolio', namedArgs:{'subjectTitle': subjectTitle}));
          break;
        default:
          throw Exception('Unknown newImageAction: ' + params.newImageAction.toString());
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
