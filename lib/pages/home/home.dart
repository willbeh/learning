import 'package:flutter/material.dart';
import 'package:learning/app_routes.dart';
import 'package:learning/widgets/app_drawer.dart';
import 'package:learning/states/theme_state.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Video',
      'routeName': AppRoutes.routeVideo,
      'icon': Icons.video_library,
    },
  ];

  @override
  Widget build(BuildContext context) {
    ThemeState themeState = Provider.of(context);

    return Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
//            pinned: true,
              floating: true,
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(
                  color: Colors.white
              ),
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Learning",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
//              background: Image.asset('assets/images/bg1.jpeg', fit: BoxFit.cover,),
              ),
              snap: true,
            ),
            SliverGrid.extent(
              maxCrossAxisExtent: 100,
              children: gridItems.map((item){
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, item['routeName']),
                  child: Container(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildCircleIcon(context,
                          icon: Icon(item['icon'], size: 40, color: (themeState.isLightTheme) ? Theme.of(context).primaryColor : Colors.white,),
                        ),
                        CommonUI.heightPadding(height: 3),
                        Text(item['title'], textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2,),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(),
                ],
              ),
            )
          ]
      ),
      drawer: AppDrawer(),
    );
  }

  Widget _buildCircleIcon(BuildContext context, {Icon icon}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        shape: BoxShape.circle,
      ),
      child: icon,
    );
  }
}
