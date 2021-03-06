import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/profile.service.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_dotted_seperator.dart';
import 'package:learning/widgets/app_text.dart';
import 'package:learning/widgets/loading_stack_screen.dart';
import 'package:logger/logger.dart';
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
  final FocusNode _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Logger log = getLogger('_LoginPageState');
  bool _obscurePassword = true;
  double _initHeight = 0;

  @override
  Widget build(BuildContext context) {
    return LoadingStackScreen(
      isLoading: _isLoading,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Theme.of(context).accentColor,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset('assets/images/brand/yellow_flower.png', ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/images/brand/green_leave.png'),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text('${AppTranslate.text(context, 'login_title')}'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if(_initHeight == 0) {
                  _initHeight = constraints.constrainHeight();
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ((_initHeight == 0) ? constraints.constrainHeight() : _initHeight) - 44,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _buildEmailSignIn(context),
                            InkWell(
                              onTap: () => AppRouter.navigator.pushNamed(AppRouter.forgetPage),
                              child: Text('${AppTranslate.text(context, 'login_forget')}', style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white),),
                            ),
                            _buildSocialSignIn(context)
                          ],
                        ),
                      ),
//                      Container(
//                        color: Colors.white,
//                        padding: const EdgeInsets.symmetric(vertical: 14),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text('${AppTranslate.text(context, 'login_donot')}', style: Theme.of(context).textTheme.display2,),
//                            Text('${AppTranslate.text(context, 'login_signup')}', style: Theme.of(context).textTheme.display2.copyWith(fontWeight: FontWeight.bold ,color: Theme.of(context).primaryColor),),
//                          ],
//                        ),
//                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmailSignIn(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  if(value.trim() == '') {
                    return '${AppTranslate.text(context, 'login_email_err')}';
                  }

                  if(!AppText.validateEmail(value)) {
                    return '${AppTranslate.text(context, 'login_email_err_valid')}';
                  }

                  return null;
                },
                onFieldSubmittedFn: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
              ),
              CommonUI.heightPadding(height: 15),
              AppTextField(
                controller: passwordCtrl,
                label: '${AppTranslate.text(context, 'login_password')}',
                errorMsg: '${AppTranslate.text(context, 'login_password_err')}',
                obscureText: _obscurePassword,
                borderColor: AppColor.greyLight,
                textInputAction: TextInputAction.done,
                focusNode: _passwordFocus,
                onFieldSubmittedFn: (_) {
                  _signInEmail(context);
                },
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              CommonUI.heightPadding(height: 30),
              AppButton.roundedButton(
                context,
                text: 'Login',
                onPressed: () => _signInEmail(context), // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                textStyle: Theme.of(context).textTheme.display2.copyWith(color: Colors.white)
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialSignIn(BuildContext context){
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width/2 - 85, child: const AppDottedSeparator(color: AppColor.greyDottedLine,)),
              Text('or continue with', style: Theme.of(context).textTheme.display2.copyWith(fontWeight: FontWeight.bold),),
              Container(width: MediaQuery.of(context).size.width/2 - 85, child: const AppDottedSeparator(color: AppColor.greyDottedLine,)),
            ],
          ),
          CommonUI.heightPadding(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildSocialButton( context,
                text: 'Facebook',
                color: AppColor.facebook,
                icon: Image.asset('assets/images/icons/facebook_512.png', height: 30,)
              ),
              _buildSocialButton( context,
                text: 'Google',
                color: AppColor.google,
                onTap: _signInGoogle,
                icon: Image.asset('assets/images/icons/google.png', height: 30,)
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {Widget icon, String text, Color color, Function onTap}){
    return AppButton.roundedButton(
      context,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          CommonUI.widthPadding(width: 10),
          Text('$text', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold))
        ],
      ),
      onPressed: () => onTap(context), // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
      color: Colors.white,
      width: 110,
      elevation: 0,
      paddingVertical: 12,
      borderColor: AppColor.greyLight,
    );
  }

  void _signInEmail(BuildContext context){
    if(_formKey.currentState.validate()){
      setState(() {
        _isLoading = true;
      });
      CommonUI.dismissKeyboard(context);
      userRepository.signInWithCredentials(emailCtrl.text, passwordCtrl.text).then((user) {
        _signInSuccess(context, user);
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

  void _signInGoogle(BuildContext context){
    setState(() {
      _isLoading = true;
    });

    userRepository.signInWithGoogle().then((user) {
      if(user != null){
        _signInSuccess(context, user);
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      log.d('error $error');
    });
  }

  void _signInSuccess(BuildContext context, FirebaseUser user){
    profileFirebaseService.findById(id: user.uid).first.then((profile) {
      AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.homePage, (route)=>false);
    }).catchError((error) {
      CommonUI.alertBox(context,
          title: 'Whoops',
          msg: '${AppTranslate.text(context, 'login_no_profile_msg')}',
          titleColor: AppColor.redAlert,
          closeText: 'Okay'
      );
      //userRepository.signOut();
      //delete user if profile not exist
      if(error.toString().contains('called on null')){
        user.delete();
      }
      userRepository.signOut();
      _isLoading = false;
    });
  }
}