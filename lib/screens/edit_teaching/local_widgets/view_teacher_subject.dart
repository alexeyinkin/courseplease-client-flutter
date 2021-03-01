import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/image_album_thumb.dart';
import 'package:courseplease/widgets/teacher_subject_product_variants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';

class ViewTeacherSubjectWidget extends StatefulWidget {
  final TeacherSubject teacherSubject;

  ViewTeacherSubjectWidget({
    @required this.teacherSubject,
  });

  @override
  State<ViewTeacherSubjectWidget> createState() => _ViewTeacherSubjectWidgetState();
}

class _ViewTeacherSubjectWidgetState extends State<ViewTeacherSubjectWidget> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  void initState() {
    _productSubjectsByIdsBloc.setCurrentIds([widget.teacherSubject.subjectId]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(ModelListByIdsState<ProductSubject> state) {
    if (state == null || state.objects.isEmpty) return Container();

    final subject = state.objects[0];

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x20808080),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 0),
            child: Row(
              children: [
                Text(
                  subject.title,
                  style: AppStyle.h2,
                ),
                Spacer(),
                ElevatedButton(
                  child: Text(tr('common.buttons.edit')),
                  onPressed: _edit,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Markdown(
              data: widget.teacherSubject.body,
              shrinkWrap: true,
            ),
          ),
          TeacherSubjectProductVariantsWidget(teacherSubject: widget.teacherSubject),
          ImageAlbumThumbsWidget(
            thumbsByPurposeIds: widget.teacherSubject.imageAlbumThumbs,
            productSubject: subject,
            onTap: (purposeId) => _showAlbum(subject, purposeId),
          ),
        ],
      ),
    );
  }

  void _edit() {

  }

  void _showAlbum(ProductSubject subject, int purposeId) async {
    await Navigator.of(context).pushNamed(
      EditImageListScreen.routeName,
      arguments: EditImageListArguments(
        filter: EditImageFilter(
          purposeIds: [purposeId],
          subjectIds: [subject.id],
        ),
      ),
    );

    // TODO: Reload current actor because there might be no more unsorted images.
  }
}
