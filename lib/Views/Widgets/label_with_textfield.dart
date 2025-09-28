import 'package:flutter/material.dart';

class LabelWithTextfield extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String imgPath;
  final String hintText;
  final IconData? suffixIcon;
  final bool obSecureText;

  const LabelWithTextfield({
    super.key,
    required this.label,
    required this.controller,
    required this.imgPath,
    required this.hintText,
    this.suffixIcon,
    this.obSecureText = false,
  });

  @override
  State<LabelWithTextfield> createState() => _LabelWithTextfieldState();
}

class _LabelWithTextfieldState extends State<LabelWithTextfield> {
  @override
  Widget build(BuildContext context) {
    Widget IconNavbar() {
      return Image.asset(
        widget.imgPath,
        height: 30,
        width: 30,
        color: Color(0XFF41AB5D),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
        ),
        TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          controller: widget.controller,
          validator: (value) => value == null || value.isEmpty
              ? 'Fill The Required Section'
              : null,
          obscureText: widget.obSecureText,
          decoration: InputDecoration(
            prefixIcon: IconNavbar(),
            suffixIcon: InkWell(
              onTap: () {},
              child: Icon(
                widget.suffixIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 20,
              color: Color(0XFF41AB5D).withOpacity(0.15),
            ),
            fillColor: Color(0XFFEDF8E9).withOpacity(0.15),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
