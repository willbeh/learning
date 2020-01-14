import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String errorMsg;
  final Function saveFn;
  final Function validatorFn;
  final Function onFieldSubmittedFn;
  final TextInputType keyboardType;
  final IconData iconData;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLines;
  final Color borderColor;

  AppTextField({this.label, this.errorMsg = '', this.saveFn, this.validatorFn, this.iconData, this.focusNode, this.onFieldSubmittedFn,
    this.keyboardType = TextInputType.text, this.textInputAction = TextInputAction.done, this.controller, this.obscureText = false, this.maxLines = 1,
    this.borderColor = Colors.grey
  });

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: label,

      suffixIcon: Icon(iconData),
      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade400),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: _buildInputDecoration(context),
      style: Theme.of(context).textTheme.display3,
//      style: Theme.of(context).textTheme.display1,
      controller: controller,
      textInputAction: textInputAction,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmittedFn,
      maxLines: maxLines,
      validator: errorMsg != '' ? (value) {
        if (value.isEmpty) {
          return errorMsg;
        } else {
          return null;
        }
      } : validatorFn,
      onSaved: saveFn,

    );
  }
}
