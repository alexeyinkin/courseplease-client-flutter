import 'dart:async';

import 'package:courseplease/models/filters/comment.dart';
import 'package:flutter/material.dart';

import '../pad.dart';
import 'comment_form.dart';
import 'comment_list.dart';

class CommentListAndForm extends StatefulWidget {
  final CommentFilter filter;
  final FocusNode? commentFocusNode;

  CommentListAndForm({
    required this.filter,
    this.commentFocusNode,
  }) : super(
    key: ValueKey(filter.toString()),
  );

  @override
  _CommentListAndFormState createState() => _CommentListAndFormState();
}

class _CommentListAndFormState extends State<CommentListAndForm> {
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CommentListWidget(
                filter: widget.filter,
                scrollController: _scrollController,
              ),
            ),
          ),
          SmallPadding(),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: CommentForm(
              filter: widget.filter,
              focusNode: widget.commentFocusNode,
              onSubmit: _onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    // Allow to rebuild first so that controller knows its new height.
    Timer(Duration(milliseconds: 0), _animateToBottom);
  }

  void _animateToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(microseconds: 250),
    );
  }
}
