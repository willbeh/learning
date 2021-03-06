import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String errorMsg;
  final Function(String) saveFn;
  final String Function(String) validatorFn;
  final Function(String) onFieldSubmittedFn;
  final TextInputType keyboardType;
  final IconData iconData;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLines;
  final Color borderColor;
  final Function(String) onChange;
  final Widget suffixIcon;

  const AppTextField({this.label, this.errorMsg = '', this.saveFn, this.validatorFn, this.iconData, this.focusNode, this.onFieldSubmittedFn,
    this.keyboardType = TextInputType.text, this.textInputAction = TextInputAction.done, this.controller, this.obscureText = false, this.maxLines = 1,
    this.borderColor = Colors.grey, this.onChange, this.suffixIcon
  });

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: _buildInputDecoration(context),
      style: Theme.of(context).textTheme.display2,
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
      onChanged: (onChange == null) ? null : onChange ,
    );
  }
}
