import 'package:charcode/html_entity.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/contact_title.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class TitleWidget extends StatelessWidget {
  final MyImageFilter filter;
  final Map<int, EditableContact> contactsByIds;
  final ModelListByIdsBloc<int, ProductSubject> productSubjectsByIdsBloc;

  TitleWidget({
    required this.filter,
    required this.contactsByIds,
    required this.productSubjectsByIdsBloc,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    String? trailing;

    switch (filter.contactIds.length) {
      case 0:
        break;
      case 1:
        final contactId = filter.contactIds[0];
        if (!contactsByIds.containsKey(contactId)) {
          widgets.add(Text(plural('EditImageListScreen.title.profiles', 1)));
        } else {
          widgets.add(ContactTitleWidget(contact: contactsByIds[contactId]!));
        }
        trailing = tr('EditImageListScreen.title.allImages');
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.profiles', filter.contactIds.length)));
        trailing = tr('EditImageListScreen.title.allImages');
    }

    if (filter.unsorted) {
      trailing = tr('MyProfileWidget.sortImportedMedia');
    } else {
      switch (filter.albumIds.length) {
        case 0:
          break;
        case 1:
          trailing = plural('EditImageListScreen.title.albums', 1); // TODO: Show the album title.
          break;
        default:
          trailing = plural('EditImageListScreen.title.profiles', filter.contactIds.length);
      }
    }

    if (trailing != null) {
      widgets.add(Text(trailing));
    }

    switch (filter.purposeIds.length) {
      case 0:
        break;
      case 1:
        widgets.add(
          StreamBuilder<ModelListByIdsState<int, ProductSubject>>(
            stream: productSubjectsByIdsBloc.outState,
            builder: (context, snapshot) => _getAlbumPurposeWidget(filter.purposeIds[0], snapshot.data),
          ),
        );
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.purposes', filter.purposeIds.length)));
    }

    switch (filter.subjectIds.length) {
      case 0:
        break;
      case 1:
        widgets.add(ProductSubjectWidget(id: filter.subjectIds.first));
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.subjects', filter.subjectIds.length)));
    }

    if (widgets.isEmpty) {
      widgets.add(Text(tr('EditImageListScreen.title.allMyImages')));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: alternateWidgetListWith(
        widgets,
        Text(' ' + String.fromCharCode($mdash) + ' '),
      ),
    );
  }

  Widget _getAlbumPurposeWidget(
    int purposeId,
    ModelListByIdsState<int, ProductSubject>? subjectsState,
  ) {
    final key = subjectsState == null || subjectsState.objects.length != 1
        ? purposeId.toString() + '_asTheOnly'
        : ImageAlbumPurpose.requireTitleKey(purposeId, subjectsState.objects[0]);

    return Text(tr('models.Image.purposes.' + key));
  }
}
