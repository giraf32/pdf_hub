import 'package:flutter/material.dart';

class AppWithError extends StatelessWidget {
 final String message;

  const AppWithError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
