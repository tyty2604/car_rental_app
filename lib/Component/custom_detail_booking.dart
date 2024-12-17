import 'package:flutter/material.dart';

class CustomBooking extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;

  const CustomBooking({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
    );
  }
}
