import 'package:courseplease/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenCubit extends Bloc {
  final _outStateController = BehaviorSubject<HomeScreenCubitState>();
  Stream<HomeScreenCubitState> get outState => _outStateController.stream;

  final initialState = HomeScreenCubitState(currentTabIndex: 0);

  static const _tabsInOrder = [
    HomeScreenTab.explore,
    HomeScreenTab.learn,
    HomeScreenTab.teach,
    HomeScreenTab.messages,
    HomeScreenTab.profile,
  ];

  int _currentTabIndex = 0;

  void setCurrentTab(HomeScreenTab tab) {
    setCurrentTabIndex(_tabsInOrder.indexOf(tab));
  }

  void setCurrentTabIndex(int n) {
    _currentTabIndex = n;
    _pushOutput();
  }

  void _pushOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  HomeScreenCubitState _createState() {
    return HomeScreenCubitState(
      currentTabIndex: _currentTabIndex,
    );
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class HomeScreenCubitState {
  final int currentTabIndex;

  HomeScreenCubitState({
    required this.currentTabIndex,
  });
}

enum HomeScreenTab {
  explore,
  learn,
  teach,
  messages,
  profile,
}
