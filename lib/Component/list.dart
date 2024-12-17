import 'package:flutter/material.dart';

class ListCars extends StatelessWidget {
  final TextEditingController controller;
  final String? hinttext;
  final Widget? leading;
  final String text;

  const ListCars({
    super.key,
    required this.controller,
    this.hinttext,
    this.leading,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hinttext,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.indigo,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
