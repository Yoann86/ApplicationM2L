// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './produit.dart';
import 'global.dart';

void main() async{
    runApp(Formulaire());
}

String cleanToken(String token) {
    token = token.replaceAll(RegExp(r'[\"\n\r\s]+'), '');
    return token;
}

class Formulaire extends StatelessWidget {
    const Formulaire({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: LoginPage(),
        );
    }
}

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    // ignore: library_private_types_in_public_api
    _LoginPageState createState() => _LoginPageState();
}

void redirectToProduit(BuildContext context, String token) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
        builder: (BuildContext context) => Produit(token: token,),
        ),
    );
}

class _LoginPageState extends State<LoginPage> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<void> sendData() async {
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();
        final response = await http.post(
            Uri.parse('$apiUrl/connexion/'),
            headers: {'Content-Type': 'application/json; charset=UTF-8',},
            body: jsonEncode({'email': email,'mdp':password}), 
        );

        if (response.statusCode == 200) {
            print('Données envoyées avec succès');
            print("test");
            final String token = cleanToken(response.body);
            print(token);
            
            final response2 = await http.get(
                Uri.parse('$apiUrl/autorisation/'),
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $token',
                },
            );
            print('URL de la requête: ${response2.request!.url}');
            if (response2.body=="1"){
                // ignore: use_build_context_synchronously
                redirectToProduit(context,token);
            }
            else {
                print('Pas les autorisations requises');
            }

        } else {
            print('Échec de l\'envoi des données avec le code de statut');
        }
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    title: Text('Outil M2L'),     
                ),
                body: Center(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                ),
                                obscureText: true,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: sendData,
                                child: Text('Se connecter'),
                            ),
                        ],
                        ),
                    ),
                ),
            ),
        );
    }
}
