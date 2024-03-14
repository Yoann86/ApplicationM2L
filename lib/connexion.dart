// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(Formulaire());
}

class Formulaire extends StatelessWidget {
    const Formulaire({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
            title: Text('Hello World App'),
            ),
            body: Center(
            child: Text(
                'Hello, World!',
                style: TextStyle(fontSize: 24),
            ),
            ),
        ),
        );
    }
}
