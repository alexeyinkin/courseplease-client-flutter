import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab.dart';
import 'package:courseplease/screens/home/local_widgets/messages_tab.dart';
import 'package:courseplease/screens/home/local_widgets/picked_tab.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentTab = 0;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        unselectedItemColor: Theme.of(context).textTheme.caption.color,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: tr('ExploreTabWidget.iconTitle'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: tr('PickedTabWidget.iconTitle'),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: tr('MessagesTabWidget.iconTitle'),
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr('MyProfileTabWidget.iconTitle'),
          ),
        ],
      ),
    );
  }

  void _onTabTap(int index) {
    setState(() {
      _currentTab = index;
    });
  }
}
