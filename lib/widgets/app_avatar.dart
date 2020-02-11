import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/models/profile.service.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final double fontSize;
  AppAvatar({this.radius = 30, this.fontSize = 24});

  final Logger log = getLogger('AppAvatar');

  @override
  Widget build(BuildContext context) {
    final Profile profile = Provider.of(context);
    final FirebaseUser user = Provider.of(context);

    String photoUrl = '';
    String photoText = '';
    if(profile.photoUrl != null && profile.photoUrl != '') {
      photoUrl = profile.photoUrl;
    } else if(user?.photoUrl != null && user?.photoUrl != '') {
      photoUrl = user.photoUrl;
    } else {
      photoText = (user == null) ? 'E' : user.email.substring(0, 1).toUpperCase();
    }


    return (photoUrl != null && photoUrl != '')
        ? InkWell(
          onTap: () => _viewImage(context, photoUrl),
          child: ImageUtil.showCircularImage(radius, photoUrl),
        )
        : CircleAvatar( //Icon(Icons.person, size: 32,),
      radius: radius,
      child: Text('$photoText', style: TextStyle(fontSize: fontSize),),
    );
  }

  void _viewImage(BuildContext context, String photoUrl) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context, listen: false);
    analytics.logEvent(name: 'avatar_view');
    CommonUI.alertBox(context, title: '${AppTranslate.text(context, 'avatar_title')}',
      child: CachedNetworkImage(
        imageUrl: photoUrl,
        fit: BoxFit.cover,
      ),
      actions: [
        FlatButton(
          onPressed: () => _changeImage(context),
          child: Text('${AppTranslate.text(context, 'change')}'),
        ),
        AppButton.roundedButton(context,
          text: 'Ok',
          textStyle: Theme.of(context).textTheme.display3.copyWith(color: Colors.white),
          onPressed: () => Navigator.pop(context),
          width: 100,
          height: 38,
        )
      ]
    );
  }

  void _changeImage(BuildContext context) {
    Navigator.pop(context);
    showBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${AppTranslate.text(context, 'avatar_confirm_change')}', textAlign: TextAlign.center,),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('${AppTranslate.text(context, 'camera')}'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
//                  Navigator.pop(context);
                  return _getImage(context).then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('${AppTranslate.text(context, 'gallery')}'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
//                  Navigator.pop(context);
                  _getImage(context, source: ImageSource.gallery).then((_) {
                    Navigator.pop(context);
                  }) ;
                },
              ),
              const Divider(),
              AppButton.roundedButton(context,
                text: 'Cancel',
                textStyle: Theme.of(context).textTheme.display3.copyWith(color: Colors.white),
                onPressed: () => Navigator.pop(context),
                width: 100,
                height: 38,
              ),
              CommonUI.heightPadding(height: 10)
            ],
          ),
        )
    );
  }

  Future _getImage(BuildContext context, {ImageSource source = ImageSource.camera}) async {

    final pickImg = await ImagePicker.pickImage(source: source, maxWidth: 500, maxHeight: 500);

    if(pickImg != null) {
      // remove old image if exist
      final FirebaseUser user = Provider.of<FirebaseUser>(context, listen: false);
      final Profile profile = Provider.of<Profile>(context, listen: false);
      final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context, listen: false);

      if(profile.photo != null && profile.photo != '') {
        final StorageReference tmpStorage = FirebaseStorage().ref().child('${profile.photo}');
        await tmpStorage.delete();
      }

      // add in new image
      final String ext = pickImg.path.substring(pickImg.path.lastIndexOf('.'), pickImg.path.length);
      final StorageReference storageReference = FirebaseStorage().ref().child('/avatars/${user.uid}/${user.uid}$ext');


      final StorageUploadTask uploadTask = storageReference.putFile(pickImg, StorageMetadata(contentType: 'image/jpeg'));

      const snackBar = SnackBar(content: Text('Please wait while your image is uploaded'));
      Scaffold.of(context).showSnackBar(snackBar);

      analytics.logEvent(name: 'avatar_create', parameters: {'source': '${source.toString()}'});

      uploadTask.onComplete.then((val) async{
        final dynamic downloadUrl = await storageReference.getDownloadURL();

        profile.photo = storageReference.path;
        profile.photoUrl = downloadUrl.toString();

        profileFirebaseService.update(id: user.uid, data: profile.toJson());


      }).catchError((error) {
        log.w('upload image error $error');
      });
    }
  }
}
