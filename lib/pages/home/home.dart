import 'package:flutter/material.dart';
import 'package:learning/pages/home/bottom_nav_video.dart';
import 'package:learning/pages/home/home_info.dart';
import 'package:learning/pages/profile/my_courses.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/states/home_page_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex;

  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _controller1 = AnimationController(vsync: this);
    _controller2 = AnimationController(vsync: this);
    _controller3 = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

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
                  _widgetOptions.elementAt(_selectedIndex),
                  if(_selectedIndex != 2)
                    child,
//                  _widgetOptions.elementAt(homePageState.selectedIndex),
//                  if(homePageState.selectedIndex != 2)
//                    child,
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Lottie.asset('assets/lottie/home.json', height: 40, width: 40, controller: _controller1),
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
              currentIndex: _selectedIndex, // homePageState.selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (i) {
                setState(() {
                  _selectedIndex = i;
                });
//                homePageState.selectedIndex = i;
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
