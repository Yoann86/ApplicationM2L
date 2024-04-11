// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'connexion.dart';

void main() async{
    await dotenv.load(fileName: ".env");
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
                title: Text('M2L Managing Tool'),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Formulaire()),
                        );
                    } , // Appel de la fonction lorsque le bouton est pressé
                    child: Text('Se connecter'),
                ),
            ),
        );
    }
}
