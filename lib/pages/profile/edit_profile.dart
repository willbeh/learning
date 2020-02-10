import 'package:flutter/material.dart';
import 'package:learning/utils/app_traslation_util.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppTranslate.text(context, 'edit_profile_title')}'),
      ),
    );
  }
}
