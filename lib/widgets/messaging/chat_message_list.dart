import 'dart:collection';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/circle_or_capsule.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../object_linear_list_view.dart';
import '../pad.dart';
import 'chat_avatar.dart';
import 'chat_message_tile.dart';
import 'chat_name.dart';

class ChatMessageListWidget extends StatefulWidget {
  final Chat chat;
  final ChatMessageFilter filter;

  ChatMessageListWidget({
    required this.chat,
    required this.filter,
  });

  @override
  _ChatMessageListState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  final _visibleMessages = SplayTreeMap<int, ChatMessage>();
  ChatMessage? _earliestVisibleMessage;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final user = state.data?.user;
    if (user == null) {
      throw Exception('Should only get here if authenticated');
    }

    return Column(
      children: [
        _getTitleWidget(),
        HorizontalLine(),
        Expanded(child: _getListWithOverlays(user)),
        HorizontalLine(),
        TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _getTitleWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatAvatarWidget(chat: widget.chat, size: 20),
          SmallPadding(),
          ChatNameWidget(chat: widget.chat),
        ],
      ),
    );
  }

  Widget _getListWithOverlays(User user) {
    return Container(
      child: Stack(
        children: [
          _getListView(user),
          _getEarliestVisibleDateWidget(),
          _getScrollToBottomButton(),
        ],
      ),
    );
  }

  Widget _getListView(User user) {
    return Positioned.fill(
      child: ObjectLinearListView<int, ChatMessage, ChatMessageFilter, ChatMessageRepository, ChatMessageTile>(
        reverse: true,
        filter: widget.filter,
        tileFactory: (TileCreationRequest<int, ChatMessage, ChatMessageFilter> request) {
          return _createTile(
            request: request,
            currentUser: user,
          );
        },
        onTap: _handleTap,
        scrollDirection: Axis.vertical,
        scrollController: _scrollController,
        separatorBuilder: _buildSeparator,
      ),
    );
  }

  ChatMessageTile _createTile({
    required TileCreationRequest<int, ChatMessage, ChatMessageFilter> request,
    required User currentUser,
  }) {
    return ChatMessageTile(
      request: request,
      currentUser: currentUser,
      onVisibilityChanged: (info) => _onMessageVisibilityChanged(
        request.object,
        info,
      ),
    );
  }

  Widget _getEarliestVisibleDateWidget() {
    if (_earliestVisibleMessage == null) return Container();

    return Positioned(
      left: 0,
      right: 0,
      top: 5,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleOrCapsuleWidget(
              color: const Color(0x60000000),
              child: Text(
                formatTimeOrDate(
                  _earliestVisibleMessage!.dateTimeInsert,
                  requireLocale(context),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScrollToBottomButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: _showScrollToBottom ? 1 : 0,
        duration: Duration(microseconds: 250),
        child: FloatingActionButton(
          child: Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: _scrollDown,
          mini: true,
          backgroundColor: Color(0xFF808080),
        ),
      ),
    );
  }

  Widget _buildSeparator({
    required BuildContext context,
    required ChatMessage? previous,
    required ChatMessage? next,
    required int nextIndex,
  }) {
    if (previous == null) {
      return Container();
    }

    if (next == null) {
      return _buildBeforeFirstMessage(previous);
    }

    if (areSameDay(previous.dateTimeInsert, next.dateTimeInsert)) {
      return Container();
    }

    return _buildMessageDate(previous);
  }

  Widget _buildBeforeFirstMessage(ChatMessage message) {
    return Column(
      children: [
        SmallPadding(),
        _buildMessageDate(message),
      ]
    );
  }

  Widget _buildMessageDate(ChatMessage message) {
    return Text(
      formatTimeOrDate(message.dateTimeInsert, requireLocale(context)),
      textAlign: TextAlign.center,
    );
  }

  void _onMessageVisibilityChanged(ChatMessage message, VisibilityInfo info) {
    if (info.visibleFraction > 0 && !_visibleMessages.containsKey(message.id)) {
      _visibleMessages[message.id] = message;
      _onVisibleMessagesChanged();
    } else if (info.visibleFraction == 0 && _visibleMessages.containsKey(message.id)) {
      _visibleMessages.remove(message.id);
      _onVisibleMessagesChanged();
    }
  }

  void _onVisibleMessagesChanged() {
    ChatMessage? earliestVisibleMessage;

    for (final message in _visibleMessages.values) {
      earliestVisibleMessage = message;
      break;
    }

    if (earliestVisibleMessage != _earliestVisibleMessage) {
      setState(() {
        _earliestVisibleMessage = earliestVisibleMessage;
      });
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      0,
      curve: Curves.linear,
      duration: Duration(microseconds: 250),
    );
  }

  void _scrollListener() {
    final isBottom = (_scrollController.offset <= _scrollController.position.minScrollExtent);
    final showScrollToBottom = !isBottom;

    if (showScrollToBottom != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = !isBottom;
      });
    }
  }

  void _handleTap(ChatMessage chat, int index) {

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
