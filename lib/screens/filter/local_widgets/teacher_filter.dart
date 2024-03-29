import 'package:courseplease/models/shop/price_range.dart';
import 'package:courseplease/screens/filter/local_blocs/teacher_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/dialog_section.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:courseplease/widgets/location_editor.dart';
import 'package:courseplease/widgets/price_range_slider.dart';
import 'package:courseplease/widgets/price_range_text.dart';
import 'package:courseplease/widgets/teaching_format_checkbox_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeacherFilterDialogContentWidget extends StatelessWidget {
  final TeacherFilterDialogCubit cubit;

  TeacherFilterDialogContentWidget({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TeacherFilterDialogCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, TeacherFilterDialogCubitState state) {
    return ListView(
      shrinkWrap: true,
      children: [
        _getFormatsPart(state),
        Container(height: 30),
        _getLocationPart(state),
        Container(height: 30),
        _getPricePart(state),
        Container(height: 30),
        _getLangsPart(state),
      ],
    );
  }

  Widget _getFormatsPart(TeacherFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('TeacherFilterDialogContentWidget.subtitles.formats'),
      child: TeachingFormatCheckboxGroupWidget(
        controller: state.formatsController,
      ),
    );
  }

  Widget _getLocationPart(TeacherFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('TeacherFilterDialogContentWidget.subtitles.location'),
      child: LocationEditorWidget(
        controller: state.locationController,
        showStreetAddress: false,
        showMap: false,
        showPrivacy: false,
      ),
    );
  }

  Widget _getPricePart(TeacherFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('TeacherFilterDialogContentWidget.subtitles.price'),
      child: PriceRangeSlider(
        controller: state.priceRangeController,
        maxUsd: PriceRange.maxUsd, // TODO: Query server for price range
      ),
      titleTrailing: PriceRangeControllerTextWidget(
        controller: state.priceRangeController,
      ),
    );
  }

  Widget _getLangsPart(TeacherFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('TeacherFilterDialogContentWidget.subtitles.langs'),
      child: LanguageListEditor(
        controller: state.langsController,
      ),
    );
  }
}
