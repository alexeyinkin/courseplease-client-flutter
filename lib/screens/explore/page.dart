import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/bloc.dart';
import 'package:courseplease/screens/explore/screen.dart';
import 'package:flutter/widgets.dart';

class ExplorePage extends BlocMaterialPage<MyPageConfiguration, ExploreBloc> {
  static const factoryKey = 'ExplorePage';

  ExplorePage() : super(
    key: ValueKey(factoryKey),
    bloc: ExploreBloc(),
    createScreen: (c) => ExploreScreen(cubit: c),
  );
}
