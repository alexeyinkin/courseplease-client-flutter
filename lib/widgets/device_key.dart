import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DeviceKeyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.instance.get<AuthenticationBloc>();
    return StreamBuilder<AuthenticationState>(
      stream: cubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final key = state.deviceKey;
    final text = (key == null)
        ? 'Device not Registered'
        : 'Device: ' + key;

    return Opacity(
      opacity: .5,
      child: SelectableText(
        text,
        style: AppStyle.minor,
      ),
    );
  }
}
