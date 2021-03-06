import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/states/app_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_avatar.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatelessWidget {
  final Logger log = getLogger('ProfilePage');

  @override
  Widget build(BuildContext context) {
    final Profile profile = Provider.of(context);
    final FirebaseUser user = Provider.of(context);

    // TODO avatar

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppTranslate.text(context, 'account_title')}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CommonUI.heightPadding(),
            AppAvatar(radius: 50, fontSize: 36,),
            CommonUI.heightPadding(),
            Text('${profile?.name}', style: Theme.of(context).textTheme.headline.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(height: 15),
            Text('${user?.email}', style: Theme.of(context).textTheme.display2.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),),
            CommonUI.heightPadding(),
            _buildListOption(context),
            CommonUI.heightPadding(),
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () => AppRouter.navigator.pushNamed(AppRouter.tempVideos),
                title: Text('${AppTranslate.text(context, 'account_about')}'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            CommonUI.heightPadding(),
            FlatButton(
              onPressed: () {
                AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.splashPage, (route) => false);
                userRepository.signOut();
              },
              child: Text('${AppTranslate.text(context, 'logout')}', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),),
            ),
            CommonUI.heightPadding(),
            FutureBuilder(
              future: _getPackageInfo(),
              builder: (context, snap) {
                if(snap.hasError) {
                  log.d('package info error ${snap.error.toString()}');
                }

                return Text('${snap.data}', style: Theme.of(context).textTheme.display4,);
              },
            ),
            CommonUI.heightPadding(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildListOption(BuildContext context) {

    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            title: Text('${AppTranslate.text(context, 'account_edit_profile')}'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => AppRouter.navigator.pushNamed(AppRouter.editProfilePage),
          ),
          ListTile(
            title: Text('${AppTranslate.text(context, 'account_settings')}'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            title: Text('${AppTranslate.text(context, 'account_language')}'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              CommonUI.alertBox(context,
                title: '${AppTranslate.text(context, 'account_select_language')}',
                child: Column(
                  children: AppState.supportedLanguages.map((lang) {
                    final AppState appState = Provider.of(context, listen: false);
                    return RadioListTile(
                      value: lang,
                      title: Text('${AppTranslate.text(context, 'account_select_$lang')}'),
                      groupValue: appState.lang,
                      onChanged: (val) {
                        if(appState.lang != val) {
                          appState.setLang(val as String);
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
                ),
                closeText: 'OK',
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> _getPackageInfo() async{
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;

    return '$version';
  }

//  void _addVideo(){
//    final List<String> videos = ['389187332'];
//    const Map<String, String> headers = {
//      'Accept': 'application/vnd.vimeo.*+json;version=3.4',
//      'Authorization': 'Bearer 1e75ca442f1666bf534893e2cd923f83',
//    };
//
//    videos.forEach((video) {
//      log.d('video $video');
//      http.get('https://api.vimeo.com/videos/$video',headers: headers).then((res) {
//        log.d('${json.decode(res.body)}');
//        videoFirebaseService.insert(data: {
//          'id': video,
//          'vid': video,
//          'data': json.decode(res.body),
//          'date': DateTime.now()
//        }).then((_) => log.d('added'))
//        .catchError((error) => log.w('Error insert $error'));
//      }).catchError((error) {
//        log.w('get $video error - $error');
//      });
//    });
//  }
}