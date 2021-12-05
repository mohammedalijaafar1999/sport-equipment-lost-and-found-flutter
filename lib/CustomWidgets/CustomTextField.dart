import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;
  final Function? action;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double padding;

  const CustomTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.obsecureText = false,
      this.action,
      this.prefixIcon,
      this.suffixIcon,
      this.padding = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: this.padding),
        child: TextField(
          obscureText: this.obsecureText,
          controller: this.controller,
          decoration: InputDecoration(
              hintText: "$hintText",
              border: InputBorder.none,
              prefixIcon: this.prefixIcon,
              suffixIcon: this.suffixIcon),
          onChanged: (val) {
            action?.call(val);
          },
        ),
      ),
    );
  }
}
