import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Container(
         padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(50), // Border radius
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black), // Foreground color
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Border radius for SnackBar
        ),
        duration: const Duration(seconds: 3),
      )
  );
}
