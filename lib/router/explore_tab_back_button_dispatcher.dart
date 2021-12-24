import 'abstract_tab_back_button_dispatcher.dart';
import 'explore_tab_state.dart';

class ExploreTabBackButtonDispatcher extends AbstractTabBackButtonDispatcher {
  @override
  final ExploreTabState state;

  ExploreTabBackButtonDispatcher(this.state) : super(state);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    if (await super.invokeCallback(defaultValue)) return true;

    state.currentTreePositionBloc.up();
    return true;
  }
}
