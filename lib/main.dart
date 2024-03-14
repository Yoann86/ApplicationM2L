// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'connexion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: MyPage(),
        );
    }
}

class MyPage extends StatelessWidget {
    const MyPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Page avec bouton'),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Formulaire()),
                        );
                    } , // Appel de la fonction lorsque le bouton est pressé
                    child: Text('Appeler la fonction'),
                ),
            ),
        );
    }
}
