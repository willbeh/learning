import 'package:flutter/material.dart';
import 'package:learning/pages/home/bottom_nav_video.dart';
import 'package:learning/pages/home/home_info.dart';
import 'package:learning/pages/profile/my_courses.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:lottie/lottie.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    const Duration duration = Duration(seconds: 1);
    _selectedIndex = 0;
    _controller1 = AnimationController(vsync: this)..duration = duration;
    _controller2 = AnimationController(vsync: this)..duration = duration;
    _controller3 = AnimationController(vsync: this)..duration = duration;

    _controller1.forward(from: 0);
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
      HomeInfo(_navigateTo),
      MyCoursesPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            if(_selectedIndex != 2)
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavVideo(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Lottie.asset('assets/lottie/home.json', height: 35, width: 35, controller: _controller1),
            title: Text('${AppTranslate.text(context, 'bottom_home')}'),
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 35,
              height: 35,
              child: Center(child: Lottie.asset('assets/lottie/my_courses.json', height: 30, width: 30, controller: _controller2)),
            ),
            title: Text('${AppTranslate.text(context, 'bottom_course')}'),
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 35,
              height: 35,
              child: Center(child: Lottie.asset('assets/lottie/profile.json', height: 30, width: 30, controller: _controller3)),
            ),
            title: Text('${AppTranslate.text(context, 'bottom_account')}'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (i) {
          _animatedNavIcon(i);
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }

  Function _navigateTo(int i) {
    _animatedNavIcon(i);
    setState(() {
      _selectedIndex = i;
    });
    return null;
  }

  void _animatedNavIcon(int i) {
    switch (i) {
      case 0:
        _controller1.forward(from: 0);
        _controller2.value = 0;
        _controller3.value = 0;
        break;

      case 1:
        _controller2.forward(from: 0);
        _controller1.value = 0;
        _controller3.value = 0;
        break;

      case 2:
        _controller3.forward(from: 0);
        _controller1.value = 0;
        _controller2.value = 0;
        break;

      default:
        break;
    }
  }
}
