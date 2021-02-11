import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/screens/choose_product_subject/choose_product_subject.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/material.dart';

class InstagramContactParamsWidget extends StatefulWidget {
  final MeResponseData meResponseData;
  final InstagramContactParams params;

  InstagramContactParamsWidget({
    @required this.meResponseData,
    @required this.params,
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
        Text("Place new photos to:"),
        RadioListTile(
          title: Text("Unsorted, so I can set category for each work or delete it"),
          value: InstagramNewPhotoAction.unsorted,
          groupValue: widget.params.newPhotoAction,
          onChanged: _handleNewPhotoActionChange,
        ),
        RadioListTile(
          title: Row(
            children: [
              Text("My portfolio as a teacher of "),
              _getPortfolioProductSubjectSelect(),
            ],
          ),
          value: InstagramNewPhotoAction.portfolio,
          groupValue: widget.params.newPhotoAction,
          onChanged: _handleNewPhotoActionChange,
        ),
      ],
    );
  }

  Widget _getPortfolioProductSubjectSelect() {
    final teacherSubjectIds = _getTeacherSubjectIds();

    return teacherSubjectIds.isEmpty && widget.params.newPhotoSubjectId == null
        ? _getChoosePortfolioProductSubjectButton()
        : _getPortfolioProductSubjectDropdown(teacherSubjectIds);
  }

  Widget _getChoosePortfolioProductSubjectButton() {
    return ElevatedButton(
      onPressed: _choosePortfolioProductSubject,
      child: Text("Choose subject..."),
    );
  }

  void _choosePortfolioProductSubject() async {
    final id = await Navigator.of(context).pushNamed(
      ChooseProductSubjectScreen.routeName,
    );

    if (id != null) {
      _handleNewPhotoPortfolioSubjectIdChange(id);
    }
  }

  Widget _getPortfolioProductSubjectDropdown(List<int> showIds) {
    return ProductSubjectDropdown(
      selectedId: widget.params.newPhotoSubjectId,
      showIds: showIds,
      onChanged: _handleNewPhotoPortfolioSubjectIdChange,
      hint: Opacity(
        opacity: .5,
        child: Text("(Choose)"),
      ),
    );
  }

  List<int> _getTeacherSubjectIds() {
    final result = <int>[];

    for (final teacherSubject in widget.meResponseData.teacherSubjects ?? []) {
      result.add(teacherSubject.subjectId);
    }

    return result;
  }

  void _handleNewPhotoActionChange(InstagramNewPhotoAction value) {
    setState(() {
      widget.params.newPhotoAction = value;
    });
  }

  void _handleNewPhotoPortfolioSubjectIdChange(int id) {
    setState(() {
      widget.params.newPhotoAction = InstagramNewPhotoAction.portfolio;
      widget.params.newPhotoSubjectId = id;
    });
  }
}