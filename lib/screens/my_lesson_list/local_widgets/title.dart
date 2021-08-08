import 'package:charcode/html_entity.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class TitleWidget extends StatelessWidget {
  final MyLessonFilter filter;
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

    switch (filter.subjectIds.length) {
      case 0:
        break;
      case 1:
        widgets.add(ProductSubjectWidget(id: filter.subjectIds.first));
        break;
      default:
        widgets.add(Text(plural('MyLessonListScreen.title.subjects', filter.subjectIds.length)));
    }

    if (widgets.isEmpty) {
      widgets.add(Text(tr('MyLessonListScreen.title.allMyLessons')));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: alternateWidgetListWith(
        widgets,
        Text(' ' + String.fromCharCode($mdash) + ' '),
      ),
    );
  }
}
