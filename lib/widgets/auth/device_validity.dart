import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/widgets/fitted_icon_text.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DeviceValidityWidget extends StatefulWidget {
  final WidgetBuilder determiningDeviceBuilder;
  final WidgetBuilder validDeviceBuilder;
  final WidgetBuilder invalidDeviceBuilder;

  DeviceValidityWidget({
    @required this.determiningDeviceBuilder,
    @required this.validDeviceBuilder,
    @required this.invalidDeviceBuilder,
  });

  @override
  State<DeviceValidityWidget> createState() => DeviceValidityWidgetState();
}

class DeviceValidityWidgetState extends State<DeviceValidityWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationCubit.outState,
      initialData: _authenticationCubit.initialState,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data),
    );
  }

  Widget _buildWithState(BuildContext context, AuthenticationState state) {
    switch (state.deviceValidity) {
      case DeviceValidity.determining:
        return _buildDetermining(context);
      case DeviceValidity.valid:
        return _buildValid(context);
      case DeviceValidity.invalid:
        return _buildInvalid(context);
    }
    throw Exception('Unknown device validity value: ' + state.deviceValidity.toString());
  }

  Widget _buildValid(BuildContext context) {
    return widget.validDeviceBuilder(context);
  }

  Widget _buildInvalid(BuildContext context) {
    return widget.invalidDeviceBuilder(context);
  }

  Widget _buildDetermining(BuildContext context) {
    return widget.determiningDeviceBuilder(context);
  }
}

class CommonDeviceValidityWidget extends StatelessWidget {
  final WidgetBuilder validDeviceBuilder;

  CommonDeviceValidityWidget({
    @required this.validDeviceBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DeviceValidityWidget(
      determiningDeviceBuilder: (context) => SmallCircularProgressIndicator(),
      validDeviceBuilder: validDeviceBuilder,
      invalidDeviceBuilder: (context) => InvalidDeviceWidget(),
    );
  }
}

class InvalidDeviceWidget extends FittedIconTextWidget {
  InvalidDeviceWidget() : super(
    iconData: Icons.error,
    text: tr('errors.notAuthorized'),
  );
}
