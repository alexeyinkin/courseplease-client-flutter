import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/widgets/messages_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab.dart';
import 'package:courseplease/screens/home/local_widgets/messages_tab.dart';
import 'package:courseplease/screens/home/local_widgets/picked_tab.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentTab = 0;
  final _pollEventsButtonIndex = 4;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(
          bucket: _pageStorageBucket,
          child: IndexedStack(
            children: [
              ExploreTab(),
              PickedTab(),
              MessagesTab(),
              ProfileTab(),
            ],
            index: _currentTab,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          type: BottomNavigationBarType.fixed,
          onTap: _onTabTap,
          unselectedItemColor: Theme.of(context).textTheme.caption!.color,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: tr('ExploreTabWidget.iconTitle'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: tr('PickedTabWidget.iconTitle'),
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
      ),
    );
  }

  void _onTabTap(int index) {
    if (index == _pollEventsButtonIndex) {
      _pollEvents();
      return;
    }

    setState(() {
      _currentTab = index;
    });
  }

  void _pollEvents() {
    final cubit = GetIt.instance.get<ServerSentEventsCubit>();
    cubit.poll();
  }
}
