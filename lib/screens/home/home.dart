import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/screens/home/local_widgets/teaching_tab.dart';
import 'package:courseplease/widgets/messages_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab.dart';
import 'package:courseplease/screens/home/local_widgets/messages_tab.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'local_blocs/home.dart';
import 'local_widgets/learning_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeScreenCubit = GetIt.instance.get<HomeScreenCubit>();
  final _pollEventsButtonIndex = 5;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<HomeScreenCubitState>(
        stream: _homeScreenCubit.outState,
        builder: (context, snapshot) => _buildWithState(
          snapshot.data ?? _homeScreenCubit.initialState
        ),
      ),
    );
  }

  Widget _buildWithState(HomeScreenCubitState state) {
    return Scaffold(
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: IndexedStack(
          children: [
            ExploreTab(),
            LearningTabWidget(),
            TeachingTabWidget(),
            MessagesTab(),
            ProfileTab(),
          ],
          index: state.currentTabIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentTabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTap,
        unselectedItemColor: Theme.of(context).textTheme.caption!.color,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: tr('ExploreTabWidget.iconTitle'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: tr('LearningTabWidget.iconTitle'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.teach_mco),
            label: tr('TeachingTabWidget.iconTitle'),
          ),
          BottomNavigationBarItem(
            icon: MessagesIconWidget(),
            label: tr('MessagesTabWidget.iconTitle'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr('MyProfileTabWidget.iconTitle'),
          ),
          // TODO: Remove this debugging button:
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: "Poll Events",
          ),
        ],
      ),
    );
  }

  void _onTabTap(int index) {
    if (index == _pollEventsButtonIndex) {
      _pollEvents();
      return;
    }

    _homeScreenCubit.setCurrentTabIndex(index);
  }

  void _pollEvents() {
    final cubit = GetIt.instance.get<ServerSentEventsCubit>();
    cubit.poll();
  }
}
