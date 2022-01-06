import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/explore/bloc.dart';
import 'package:courseplease/screens/explore/screen.dart';
import 'package:flutter/widgets.dart';

class ExplorePage extends BlocMaterialPage<AppConfiguration, ExploreBloc> {
  ExplorePage() : super(
    key: ValueKey('ExplorePage'),
    bloc: ExploreBloc(),
    createScreen: (c) => ExploreScreen(cubit: c),
  );
}
