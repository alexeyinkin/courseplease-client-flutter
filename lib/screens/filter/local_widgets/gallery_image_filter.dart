import 'package:courseplease/screens/filter/local_blocs/gallery_image_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/dialog_section.dart';
import 'package:courseplease/widgets/location_editor.dart';
import 'package:courseplease/widgets/price_range_slider.dart';
import 'package:courseplease/widgets/price_range_text.dart';
import 'package:courseplease/widgets/teaching_format_checkbox_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GalleryImageFilterDialogContentWidget extends StatelessWidget {
  final GalleryImageFilterDialogCubit cubit;

  GalleryImageFilterDialogContentWidget({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GalleryImageFilterDialogCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, GalleryImageFilterDialogCubitState state) {
    return ListView(
      shrinkWrap: true,
      children: [
        _getFormatsPart(context, state),
        Container(height: 30),
        _getLocationPart(context, state),
        Container(height: 30),
        _getPricePart(context, state),
      ],
    );
  }

  Widget _getFormatsPart(BuildContext context, GalleryImageFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('GalleryImageFilterDialogContentWidget.subtitles.formats'),
      child: TeachingFormatCheckboxGroupWidget(
        controller: state.formatsController,
      ),
    );
  }

  Widget _getLocationPart(BuildContext context, GalleryImageFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('GalleryImageFilterDialogContentWidget.subtitles.location'),
      child: LocationEditorWidget(
        controller: state.locationController,
        showStreetAddress: false,
        showMap: false,
        showPrivacy: false,
      ),
    );
  }

  Widget _getPricePart(BuildContext context, GalleryImageFilterDialogCubitState state) {
    return DialogSectionWidget(
      text: tr('GalleryImageFilterDialogContentWidget.subtitles.price'),
      child: PriceRangeSlider(
        cur: state.cur,
        from: state.priceFrom,
        to: state.priceTo,
        maxUsd: 200, // TODO: Query server for price range
        onChanged: cubit.setPriceRange,
      ),
      titleTrailing: PriceRangeTextWidget(
        cur: state.cur,
        from: state.priceFrom,
        to: state.priceTo,
      ),
    );
  }
}
