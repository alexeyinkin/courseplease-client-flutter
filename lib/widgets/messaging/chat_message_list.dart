import 'dart:collection';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/blocs/chat_message_send_queue_view.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/circle_or_capsule.dart';
import 'package:courseplease/widgets/messaging/chat_message_editor.dart';
import 'package:courseplease/widgets/messaging/sending_chat_message.dart';
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
  final bool showTitle;

  ChatMessageListWidget({
    required this.chat,
    required this.filter,
    required this.showTitle,
  }) : super(
    key: Key('ChatMessageListWidget_' + chat.id.toString()),
  );

  @override
  _ChatMessageListState createState() => _ChatMessageListState(
    chat: chat,
  );
}

class _ChatMessageListState extends State<ChatMessageListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final ChatMessageSendQueueViewCubit _sendQueueCubit;
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  final _visibleMessages = SplayTreeMap<int, ChatMessage>();
  ChatMessage? _earliestVisibleMessage;
  bool _showScrollToBottom = false;

  _ChatMessageListState({
    required Chat chat,
  }) :
    _sendQueueCubit = ChatMessageSendQueueViewCubit.fromChat(chat)
  ;

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
        if (widget.showTitle) _getTitleWidget(),
        HorizontalLine(),
        Expanded(child: _getListWithOverlays(user)),
        HorizontalLine(),
        ChatMessageEditorWidget(
          chatId: widget.chat.id,
          senderUserId: user.id,
        ),
        HorizontalLine(),
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

  Widget _getListView(User currentUser) {
    return Positioned.fill(
      child: ObjectLinearListView<int, ChatMessage, ChatMessageFilter, ChatMessageRepository, ChatMessageTile>(
        reverse: true,
        filter: widget.filter,
        tileFactory: (TileCreationRequest<int, ChatMessage, ChatMessageFilter> request) {
          return _createTile(
            request: request,
            currentUser: currentUser,
          );
        },
        onTap: _handleTap,
        scrollDirection: Axis.vertical,
        scrollController: _scrollController,
        separatorBuilder: (request) => _buildSeparator(currentUser, request),
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
                formatDate(
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
      bottom: 10,
      right: 10,
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

  Widget _buildSeparator(
    User currentUser,
    SeparatorCreationRequest<int, ChatMessage> request,
  ) {
    final under = request.previous;
    final above = request.next;

    if (under == null) {
      return (above == null)
        ? Container() // Above the above the oldest message.
        : _buildUnderNewestMessage(currentUser, above);
    }

    if (above == null) {
      return _buildAboveOldestMessage(under);
    }

    if (areSameDay(under.dateTimeInsert, above.dateTimeInsert)) {
      return _buildSameDaySeparator(under, above);
    }

    return _buildMessageDate(under);
  }

  Widget _buildSameDaySeparator(ChatMessage under, ChatMessage above) {
    if (under.senderUserId == above.senderUserId) return Container();
    return _buildSameDaySpeakersSeparator();
  }

  Widget _buildSameDaySpeakersSeparator() {
    return SmallPadding();
  }

  Widget _buildAboveOldestMessage(ChatMessage message) {
    // A spacing behind the date overlay when scrolled to the top.
    return Container(
      height: 32,
    );
  }

  Widget _buildUnderNewestMessage(User currentUser, ChatMessage newestMessage) {
    return StreamBuilder<ChatMessageSendQueueState>(
      stream: _sendQueueCubit.outState,
      builder: (context, snapshot) => _buildUnderNewestMessageWithQueue(
        snapshot.data ?? _sendQueueCubit.initialState,
        currentUser,
        newestMessage,
      ),
    );
  }

  Widget _buildUnderNewestMessageWithQueue(
    ChatMessageSendQueueState state,
    User currentUser,
    ChatMessage newestMessage,
  ) {
    if (state.queue.isEmpty) return Container();

    return Opacity(
      opacity: .5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (currentUser.id != newestMessage.senderUserId) _buildSameDaySpeakersSeparator(),
          ..._getSendingMessageWidgets(state, currentUser),
        ],
      ),
    );
  }

  List<Widget> _getSendingMessageWidgets(
    ChatMessageSendQueueState state,
    User currentUser,
  ) {
    final result = <Widget>[];

    for (final message in state.queue) {
      result.add(
        SendingChatMessageWidget(
          message: message,
          currentUser: currentUser,
        ),
      );
    }

    return result;
  }

  Widget _buildMessageDate(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        formatDate(message.dateTimeInsert, requireLocale(context)),
        textAlign: TextAlign.center,
      ),
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

    if (earliestVisibleMessage != _earliestVisibleMessage && mounted) {
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
