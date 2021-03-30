import 'package:courseplease/blocs/realtime.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MessagesIconWidget extends StatefulWidget {
  @override
  _MessagesIconWidgetState createState() => _MessagesIconWidgetState();
}

class _MessagesIconWidgetState extends State<MessagesIconWidget> {
  final _realtimeFactoryCubit = GetIt.instance.get<RealtimeFactoryCubit>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RealtimeState>(
      stream: _realtimeFactoryCubit.outState,
      builder: (context, snapshot) => _buildWithRealtimeState(
        snapshot.data ?? _realtimeFactoryCubit.initialState,
      ),
    );
  }

  Widget _buildWithRealtimeState(RealtimeState state) {
    return Stack(
      children: [
        Icon(Icons.chat),
        _getStatusWidget(state),
      ],
    );
  }

  Widget _getStatusWidget(RealtimeState state) {
    switch (state.status) {
      case RealtimeStatus.connected:
        return Container(width: 0, height: 0); // If non-zero, the icon shifts.
      case RealtimeStatus.failed:
        return _getStatusDotLeft(state);
      case RealtimeStatus.notAttempted:
      case RealtimeStatus.connecting:
        return _getStatusProgressIndicator();
    }
  }

  Widget _getStatusDotRight(RealtimeState state) {
    // Positioned at the bottom-right border of the speech bubble on the icon.
    return Positioned(
      right: 2,
      bottom: 6,
      child: _getStatusDot(state),
    );
  }

  Widget _getStatusDotLeft(RealtimeState state) {
    return Positioned(
      left: 0,
      bottom: 1,
      child: _getStatusDot(state),
    );
  }

  Widget _getStatusDot(RealtimeState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _getStatusColor(state),
      ),
      width: 5,
      height: 5,
    );
  }

  Color _getStatusColor(RealtimeState state) {
    switch (state.status) {
      case RealtimeStatus.notAttempted:
        return Colors.transparent;
      case RealtimeStatus.connecting:
        return Color(0xFFF08000);
      case RealtimeStatus.connected:
        return Color(0xFF008000);
      case RealtimeStatus.failed:
        return Color(0xFFA00000);
    }
  }

  Widget _getStatusProgressIndicator() {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 6,
        height: 6,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xC0404040)),
        ),
      ),
    );
  }
}
