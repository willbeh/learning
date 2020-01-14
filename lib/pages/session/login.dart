import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/app_color.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_dotted_seperator.dart';
import 'package:learning/widgets/app_text.dart';
import 'package:learning/widgets/loading_stack_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var log = getLogger('_LoginPageState');

  @override
  Widget build(BuildContext context) {
    return LoadingStackScreen(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${AppTranslate.text(context, 'login_title')}'),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _buildEmailSignIn(context),
                      FlatButton(
                        child: Text('${AppTranslate.text(context, 'login_forget')}', style: TextStyle(color: Theme.of(context).primaryColor),),
                        onPressed: () => null,
                      ),
                      _buildSocialSignIn(context)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${AppTranslate.text(context, 'login_donot')}', style: Theme.of(context).textTheme.display2,),
                      Text('${AppTranslate.text(context, 'login_signup')}', style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmailSignIn(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
//        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            AppTextField(
              controller: emailCtrl,
              label: '${AppTranslate.text(context, 'login_email')}',
              keyboardType: TextInputType.emailAddress,
              borderColor: AppColor.greyLight,
              validatorFn: (String value) {
                if(value.trim() == '')
                  return '${AppTranslate.text(context, 'login_email_err')}';

                if(!AppText.validateEmail(value))
                  return '${AppTranslate.text(context, 'login_email_err_valid')}';

                return null;
              },
            ),
            CommonUI.heightPadding(),
            AppTextField(
              controller: passwordCtrl,
              label: '${AppTranslate.text(context, 'login_password')}',
              errorMsg: '${AppTranslate.text(context, 'login_password_err')}',
              obscureText: true,
              borderColor: AppColor.greyLight,
            ),
            CommonUI.heightPadding(),
            AppButton.roundedButton(
              context,
              text: 'Login',
              onPressed: () => _signInEmail(), // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSocialSignIn(BuildContext context){
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width/2 - 90, child: AppDottedSeparator(color: AppColor.greyDottedLine,)),
              Text('or continue with', style: Theme.of(context).textTheme.display2,),
              Container(width: MediaQuery.of(context).size.width/2 - 90, child: AppDottedSeparator(color: AppColor.greyDottedLine,)),
            ],
          ),
          CommonUI.heightPadding(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildSocialButton( context,
                text: 'Facebook',
                color: AppColor.facebook,
                icon: AppIcon.facebook
              ),
              _buildSocialButton( context,
                text: 'Google',
                color: AppColor.google,
                onTap: _signInGoogle,
                icon: AppIcon.google
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {IconData icon, String text, Color color, Function onTap}){
    return AppButton.roundedButton(
      context,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          CommonUI.widthPadding(width: 5),
          Text('$text', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500))
        ],
      ),
      onPressed: () => onTap(), // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
      color: Colors.white,
      width: 110,
      elevation: 0,
      paddingVertical: 12,
      borderColor: AppColor.greyLight,
    );
  }

  _signInEmail(){
    if(_formKey.currentState.validate()){
      setState(() {
        _isLoading = true;
      });
      userRepository.signInWithCredentials(emailCtrl.text, passwordCtrl.text).then((user) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false);
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        CommonUI.alertBox(context,
            title: 'Whoops',
            msg: '${error.message}',
            titleColor: AppColor.redAlert,
            closeText: 'Okay'
        );
      });
    }

  }

  _signInGoogle() async{
    setState(() {
      _isLoading = true;
    });
    FirebaseUser user = await userRepository.signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    if(user != null){
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false);
    }
  }
}