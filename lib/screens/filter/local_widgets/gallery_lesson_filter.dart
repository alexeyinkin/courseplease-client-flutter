import 'package:courseplease/screens/filter/local_blocs/gallery_lesson_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/dialog_section.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GalleryLessonFilterDialogContentWidget extends StatelessWidget {
  final GalleryLessonFilterDialogCubit cubit;

  GalleryLessonFilterDialogContentWidget({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GalleryLessonFilterDialogCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, GalleryLessonFilterDialogCubitState state) {
    return ListView(
      shrinkWrap: true,
      children: [
        _getLangsPart(state),
      ],
    );
  }

  Widget _getLangsPart(GalleryLessonFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('GalleryLessonFilterDialogContentWidget.subtitles.langs'),
      child: LanguageListEditor(
        controller: state.langsController,
      ),
    );
  }
}
