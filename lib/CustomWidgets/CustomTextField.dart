import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;
  final Function? action;

  const CustomTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.obsecureText = false,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          obscureText: this.obsecureText,
          controller: this.controller,
          decoration:
              InputDecoration(hintText: "$hintText", border: InputBorder.none),
          onChanged: (val) {
            action?.call(val);
          },
        ),
      ),
    );
  }
}
