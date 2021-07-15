import 'dart:convert';

import 'package:courseplease/blocs/comment_form.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:courseplease/widgets/send_message_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  final CommentFilter filter;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;

  CommentForm({
    required this.filter,
    this.focusNode,
    this.onSubmit,
  }) : super(
    key: ValueKey('form_' + jsonEncode(filter.toJson()))
  );

  @override
  _CommentFormState createState() => _CommentFormState(filter: filter);
}

class _CommentFormState extends State<CommentForm> {
  final CommentFormCubit _cubit;

  _CommentFormState({
    required CommentFilter filter,
  }) :
      _cubit = CommentFormCubit(filter: filter)
  {
    _cubit.results.listen(_onResult);
  }

  void _onResult(DialogResult result) {
    showErrorIfShould(context, result);

    if (result.code == DialogResultCode.ok && widget.onSubmit != null) {
      widget.onSubmit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<CommentFormCubitState>(
        stream: _cubit.states,
        builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
      ),
    );
  }

  Widget _buildWithState(CommentFormCubitState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: state.controller,
            focusNode: widget.focusNode,
            labelText: tr('CommentForm.commentHere'),
            minLines: 1,
            maxLines: 5,
            enabled: !state.inProgress,
          ),
        ),
        SendMessageButton(onPressed: _cubit.submit),
      ],
    );
  }
}
