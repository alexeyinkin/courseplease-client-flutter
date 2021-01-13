import 'package:flutter/material.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab.dart';
import 'package:courseplease/screens/home/local_widgets/messages_tab.dart';
import 'package:courseplease/screens/home/local_widgets/picked_tab.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
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
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Picked',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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

  void _popup() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(title: Text('Popup')),
              body: Center(child: Text('Popup body.')),
            );
          }
      ),
    );
  }
}

abstract class TitleWidgetProvider extends StatefulWidget {
  Widget getTitleWidget();
}
