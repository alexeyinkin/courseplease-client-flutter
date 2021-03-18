import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/screens/select_product_subject/select_product_subject.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InstagramContactParamsWidget extends StatefulWidget {
  final MeResponseData meResponseData;
  final InstagramContactParams params;

  InstagramContactParamsWidget({
    required this.meResponseData,
    required this.params,
  });

  @override
  State<InstagramContactParamsWidget> createState() => _InstagramContactParamsWidgetState();
}

class _InstagramContactParamsWidgetState extends State<InstagramContactParamsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('InstagramContactParamsWidget.placeNewImagesTo.title')),
        RadioListTile(
          title: Text(tr('InstagramContactParamsWidget.placeNewImagesTo.unsorted')),
          value: InstagramNewImageAction.unsorted,
          groupValue: widget.params.newImageAction,
          onChanged: _handleNewPhotoActionChange,
        ),
        RadioListTile(
          title: Row(
            children: [
              Text(tr('InstagramContactParamsWidget.placeNewImagesTo.portfolio')),
              SmallPadding(),
              _getPortfolioProductSubjectSelect(),
            ],
          ),
          value: InstagramNewImageAction.portfolio,
          groupValue: widget.params.newImageAction,
          onChanged: _handleNewPhotoActionChange,
        ),
      ],
    );
  }

  Widget _getPortfolioProductSubjectSelect() {
    final teacherSubjectIds = _getTeacherSubjectIds();

    return teacherSubjectIds.isEmpty && widget.params.newImageSubjectId == null
        ? _getChoosePortfolioProductSubjectButton()
        : _getPortfolioProductSubjectDropdown(teacherSubjectIds);
  }

  Widget _getChoosePortfolioProductSubjectButton() {
    return ElevatedButton(
      onPressed: _selectPortfolioProductSubject,
      child: Text(tr('InstagramContactParamsWidget.buttons.selectSubject')),
    );
  }

  void _selectPortfolioProductSubject() async {
    final id = await SelectProductSubjectScreen.selectSubjectId(context);
    if (id != null) {
      _handleNewPhotoPortfolioSubjectIdChange(id);
    }
  }

  Widget _getPortfolioProductSubjectDropdown(List<int> showIds) {
    return ProductSubjectDropdown(
      selectedId: widget.params.newImageSubjectId,
      showIds: showIds,
      onChanged: _handleNewPhotoPortfolioSubjectIdChange,
      hint: Opacity(
        opacity: .5,
        child: Text(tr('InstagramContactParamsWidget.buttons.selectSubject')),
      ),
    );
  }

  List<int> _getTeacherSubjectIds() {
    final result = <int>[];

    for (final teacherSubject in widget.meResponseData.teacherSubjects) {
      result.add(teacherSubject.subjectId);
    }

    return result;
  }

  void _handleNewPhotoActionChange(InstagramNewImageAction? value) {
    if (value == null) {
      throw Exception('Never happens as all radios have values.');
    }
    setState(() {
      widget.params.newImageAction = value;
    });
  }

  void _handleNewPhotoPortfolioSubjectIdChange(int id) {
    setState(() {
      widget.params.newImageAction = InstagramNewImageAction.portfolio;
      widget.params.newImageSubjectId = id;
    });
  }
}
