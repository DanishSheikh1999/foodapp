import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final Color color;
  final Icon icon;
  final double width;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color backgroundColor;
  final TextInputAction textInputAction;
  final Function(String value) onChanged;
  final Function(String value) validator;
  final Function(String value) onSubmitted;

  CustomTextFormField({
    Key key,
    this.hint,
    this.color,
    this.icon,
    this.width,
    this.keyboardType,
    this.obscureText,
    this.backgroundColor,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.onSubmitted,
  }) : super(key: key);
      
  @override
  Widget build(BuildContext context) {
    return Container(
      width:width,
      padding:EdgeInsets.symmetric(horizontal: 20),
      decoration:BoxDecoration(
        color:backgroundColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextFormField(
        textInputAction: textInputAction,
        validator:validator,
        onFieldSubmitted: onSubmitted,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged:onChanged,
        cursorColor:color,
        style:Theme.of(context).textTheme.overline.copyWith(color: color,
        fontSize:16),
        decoration: InputDecoration(
          errorStyle:Theme.of(context).textTheme.overline.copyWith(
            color: color,
            fontSize:12
          ),
          border: InputBorder.none,
          icon: icon,
          hintText: hint,
          hintStyle: TextStyle(
            color:color,
            fontSize: 16
          )
        ),
      ),
      
    );
  }
}
