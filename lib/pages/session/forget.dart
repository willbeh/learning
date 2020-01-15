import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/app_text.dart';
import 'package:learning/widgets/app_text_field.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:learning/widgets/loading_stack_screen.dart';

class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingStackScreen(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${AppTranslate.text(context, 'forget_title')}'),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: <Widget>[
                AppTextField(
                  controller: emailCtrl,
                  label: '${AppTranslate.text(context, 'login_email')}',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: AppColor.greyLight,
                  validatorFn: (String value) {
                    if (value.trim() == '')
                      return '${AppTranslate.text(context, 'login_email_err')}';

                    if (!AppText.validateEmail(value))
                      return '${AppTranslate.text(context, 'login_email_err_valid')}';

                    return null;
                  },
                  onFieldSubmittedFn: (_) => _resetPassword(),
                ),
                CommonUI.heightPadding(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    '${AppTranslate.text(context, 'forget_msg')}',
                    style: Theme.of(context).textTheme.display3,
                  ),
                ),
                CommonUI.heightPadding(),
                AppButton.roundedButton(
                  context,
                  text: '${AppTranslate.text(context, 'forget_btn')}',
                  onPressed: () =>
                      _resetPassword(), // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeHomePage, (route) => false),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _resetPassword() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      userRepository.resetPassword(emailCtrl.text).then((_) {
        setState(() {
          _isLoading = false;
        });
        CommonUI.dismissKeyboard(context);
        CommonUI.alertBox(
          context,
          title: 'Reset Successful',
          child: Column(
            children: <Widget>[
              Text('Reset instruction has been sent to you mailbox. Please follow the instruction there.', style: Theme.of(context).textTheme.display2,
                textAlign: TextAlign.center,
              ),
              CommonUI.heightPadding(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColor.greyLight),
                ),
                child: Text('${emailCtrl.text}', style: Theme.of(context).textTheme.display3, textAlign: TextAlign.center),
              )
            ],
          ),
          titleColor: Theme.of(context).primaryColor,
          actions: [
            AppButton.roundedButton(context,
                text: '${AppTranslate.text(context, 'okay')}',
                paddingVertical: 5,
                textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
            )
          ]
        );
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        CommonUI.alertBox(context,
            title: 'Whoops',
            msg: '${error.message}',
            titleColor: AppColor.redAlert,
            closeText: 'Okay');
      });
    }
  }
}
