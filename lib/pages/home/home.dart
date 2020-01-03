import 'package:flutter/material.dart';
import 'package:learning/app_routes.dart';
import 'package:learning/widgets/app_drawer.dart';
import 'package:learning/states/theme_state.dart';
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
                title: Text("Demo App",
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
              maxCrossAxisExtent: 150,
              childAspectRatio: 1.12,
              children: gridItems.map((item){
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, item['routeName']),
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(item['icon'], size: 28, color: (themeState.isLightTheme) ? Theme.of(context).primaryColor : Colors.white,),
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
}
