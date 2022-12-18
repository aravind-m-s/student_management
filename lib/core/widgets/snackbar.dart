import 'package:flutter/material.dart';

showSnackBar(Color color, String message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
  ));
}
