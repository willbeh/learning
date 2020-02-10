import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/widgets/app_avatar.dart';
import 'package:provider/provider.dart';
import 'package:learning/states/app_state.dart';
import '../widgets/common_ui.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);

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
                AppAvatar(radius: 30),
                CommonUI.heightPadding(),
                if(user?.displayName != null)
                  Text('${user?.displayName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                Text('${user?.email}', style: TextStyle(color: Colors.white),),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Change to ${(Provider.of<AppState>(context, listen: false).isLightTheme) ? 'Dark' : 'Light'} theme'),
            onTap: () => Provider.of<AppState>(context, listen: false).invertTheme(),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: (){
              Navigator.pop(context);
              AppRouter.navigator.pushNamed(AppRouter.profilePage);
            }
          ),
          ListTile(
              title: Text('My Video'),
              onTap: (){
                Navigator.pop(context);
                AppRouter.navigator.pushNamed(AppRouter.myVideosPage);
              }
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.splashPage, (route) => false);
              userRepository.signOut();
            }//userRepository.signOut().then((_) => Navigator.pushReplacementNamed(context, '/')),
          ),
        ],
      ),
    );
  }
}
