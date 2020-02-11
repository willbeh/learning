import 'package:flutter/material.dart';
import 'package:learning/pages/home/bottom_nav_video.dart';
import 'package:learning/pages/home/home_info.dart';
import 'package:learning/pages/profile/my_courses.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/states/home_page_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeInfo(),
      MyCoursesPage(),
      ProfilePage(),
    ];

    return ChangeNotifierProvider(
      create: (_) => HomePageState(),
      child: Consumer<HomePageState>(
        builder: (context, homePageState, child) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  _widgetOptions.elementAt(homePageState.selectedIndex),
                  if(homePageState.selectedIndex != 2)
                    child,
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('${AppTranslate.text(context, 'bottom_home')}'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  title: Text('${AppTranslate.text(context, 'bottom_course')}'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('${AppTranslate.text(context, 'bottom_account')}'),
                ),
              ],
              currentIndex: homePageState.selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (i) {
                homePageState.selectedIndex = i;
              },
            ),
          );
        },
        // don't need to rebuild bottomNavVideo
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavVideo(),
        ),
      ),
    );
  }
}
