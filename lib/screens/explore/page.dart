import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/explore/bloc.dart';
import 'package:courseplease/screens/explore/screen.dart';
import 'package:flutter/widgets.dart';

class ExplorePage extends BlocMaterialPage<ScreenConfiguration, ExploreBloc> {
  static const factoryKey = 'ExplorePage';

  ExplorePage() : super(
    key: ValueKey(factoryKey),
    bloc: ExploreBloc(),
    createScreen: (c) => ExploreScreen(cubit: c),
  );
}
