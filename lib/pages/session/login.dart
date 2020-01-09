import 'package:flutter/material.dart';
import 'package:learning/utils/app_traslation_util.dart';
import '../../app_routes.dart';
import '../../utils/app_icon_icons.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common_ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.9],
          colors: [
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColorDark,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text('${AppTranslate.text(context, 'login')}', style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).primaryColor),),
                      CommonUI.heightPadding(),
                      AppTextField(
                        controller: emailCtrl,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CommonUI.heightPadding(),
                      AppTextField(
                        controller: passwordCtrl,
                        label: 'Password',
                        obscureText: true,
                      ),
                      CommonUI.heightPadding(),
                      AppButton.roundedButton(
                          context,
                          text: 'Login',
                          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width
                      ),
                      CommonUI.heightPadding(),
                      Text('or continue with', style: Theme.of(context).textTheme.display3,),
                      CommonUI.heightPadding(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(AppIcon.google, color: Color(0xffDB4437)),
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
                          ),
                          IconButton(
                            icon: Icon(AppIcon.facebook, color: Color(0xff4267B2)),
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
