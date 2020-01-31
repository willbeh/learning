import 'package:flutter/material.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/services/user_repository.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),

      ),
      body: ListView(
        children: <Widget>[
          Text('${profile?.name}'),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.splashPage, (route) => false);
              userRepository.signOut();
            },
          )
        ],
      ),
    );
  }
}