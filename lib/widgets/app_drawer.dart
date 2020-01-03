import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_routes.dart';
import '../states/theme_state.dart';
import '../widgets/common_ui.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeState themeState = Provider.of(context);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(Icons.person, size: 32,),
                  radius: 27,
                ),
                CommonUI.heightPadding(),
                Text('Andy Groove1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                Text('andy@email.com', style: TextStyle(color: Colors.white),),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Change to ${(themeState.isLightTheme) ? 'Dark' : 'Light'} theme'),
            onTap: () => themeState.invertTheme(),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeLoginPage, (route) => false),
          ),
        ],
      ),
    );
  }
}
