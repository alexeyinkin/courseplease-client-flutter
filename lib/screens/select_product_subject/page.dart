import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'screen.dart';

class SelectProductSubjectPage extends BlocMaterialPage<MyPageConfiguration, SelectProductSubjectBloc> {
  SelectProductSubjectPage({
    required bool allowingImagePortfolio,
  }) : super(
    key: ValueKey('SelectProductSubjectPage'),
    bloc: SelectProductSubjectBloc(allowingImagePortfolio: allowingImagePortfolio),
    createScreen: (b) => SelectProductSubjectScreen(bloc: b),
  );
}
