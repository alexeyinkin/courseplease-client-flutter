import 'dart:async';

import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/select_product_subject/events.dart';
import 'package:courseplease/screens/select_product_subject/page.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/teacher_product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../bloc.dart';

class InstagramContactParamsWidget extends StatefulWidget {
  final EditIntegrationBloc editIntegrationBloc;
  final MeResponseData meResponseData;
  final InstagramContactParams params;

  InstagramContactParamsWidget({
    required this.editIntegrationBloc,
    required this.meResponseData,
    required this.params,
  });

  @override
  State<InstagramContactParamsWidget> createState() => _InstagramContactParamsWidgetState();
}

class _InstagramContactParamsWidgetState extends State<InstagramContactParamsWidget> {
  StreamSubscription? _productSubjectSubscription;

  @override
  void initState() {
    super.initState();
    _productSubjectSubscription = widget.editIntegrationBloc.productSubjectChanges.listen(
      _handleNewPhotoPortfolioSubjectChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('InstagramContactParamsWidget.placeNewImagesTo.title')),
        _getUnsortedRadio(),
        _getBackstageRadio(),
        _getPortfolioRadio(),
      ],
    );
  }

  Widget _getUnsortedRadio() {
    return RadioListTile(
      title: Text(tr('InstagramContactParamsWidget.placeNewImagesTo.unsorted')),
      value: InstagramNewImageAction.unsorted,
      groupValue: widget.params.newImageAction,
      onChanged: _handleNewPhotoActionChange,
    );
  }

  Widget _getBackstageRadio() {
    final selected = (widget.params.newImageAction == InstagramNewImageAction.backstage);
    final List<Widget> children;

    if (!selected) {
      children = [
        Text(tr('InstagramContactParamsWidget.placeNewImagesTo.backstage')),
      ];
    } else {
      children = [
        Text(tr('InstagramContactParamsWidget.placeNewImagesToSelected.backstage')),
        SmallPadding(),
        Expanded(
          child: _getPortfolioProductSubjectSelect(allowingImagePortfolio: false),
        ),
      ];
    }

    return RadioListTile(
      title: Row(children: children),
      value: InstagramNewImageAction.backstage,
      groupValue: widget.params.newImageAction,
      onChanged: _handleNewPhotoActionChange,
    );
  }

  Widget _getPortfolioRadio() {
    final selected = (widget.params.newImageAction == InstagramNewImageAction.portfolio);
    final List<Widget> children;

    if (!selected) {
      children = [
        Text(tr('InstagramContactParamsWidget.placeNewImagesTo.portfolio')),
      ];
    } else {
      children = [
        Text(tr('InstagramContactParamsWidget.placeNewImagesToSelected.portfolio')),
        SmallPadding(),
        Expanded(
          child: _getPortfolioProductSubjectSelect(allowingImagePortfolio: true),
        ),
      ];
    }

    return RadioListTile(
      title: Row(children: children),
      value: InstagramNewImageAction.portfolio,
      groupValue: widget.params.newImageAction,
      onChanged: _handleNewPhotoActionChange,
    );
  }

  Widget _getPortfolioProductSubjectSelect({
    required bool allowingImagePortfolio,
  }) {
    final teacherSubjectIds = _getTeacherSubjectIds();

    return teacherSubjectIds.isEmpty && widget.params.newImageSubjectId == null
        ? _getChoosePortfolioProductSubjectButton(allowingImagePortfolio: allowingImagePortfolio)
        : _getPortfolioProductSubjectDropdown(allowingImagePortfolio: allowingImagePortfolio);
  }

  Widget _getChoosePortfolioProductSubjectButton({
    required bool allowingImagePortfolio,
  }) {
    return ElevatedButton(
      onPressed: () => _onSelectSubjectPressed(allowingImagePortfolio: allowingImagePortfolio),
      child: Text(tr('InstagramContactParamsWidget.buttons.selectSubject')),
    );
  }

  void _onSelectSubjectPressed({
    required bool allowingImagePortfolio,
  }) async {
    GetIt.instance.get<AppState>().pushPage(
      SelectProductSubjectPage(
        allowingImagePortfolio: allowingImagePortfolio,
      ),
    );
  }

  Widget _getPortfolioProductSubjectDropdown({
    required bool allowingImagePortfolio,
  }) {
    return TeacherProductSubjectDropdown(
      selectedId: widget.params.newImageSubjectId,
      onChanged: _handleNewPhotoPortfolioSubjectIdChange,
      hintText: tr('InstagramContactParamsWidget.buttons.selectSubject'),
      allowingImagePortfolio: allowingImagePortfolio,
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

  void _handleNewPhotoPortfolioSubjectChanged(ProductSubjectSelectedEvent event) {
    _handleNewPhotoPortfolioSubjectIdChange(event.productSubjectId);
  }

  void _handleNewPhotoPortfolioSubjectIdChange(int id) {
    setState(() {
      widget.params.newImageSubjectId = id;
    });
  }

  @override
  void dispose() {
    _productSubjectSubscription?.cancel();
    super.dispose();
  }
}
