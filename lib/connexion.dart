// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './produit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(Formulaire());
}

String cleanToken(String token) {
    return token.replaceAll("[\\n\\r\\s\"']+", '');
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
    final String apiUrl = dotenv.env['API_URL'].toString();

    Future<void> sendData() async {
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();
        final response = await http.post(
            Uri.parse('$apiUrl/connexion/'),
            headers: {'Content-Type': 'application/json; charset=UTF-8',},
            body: jsonEncode({'email': email,'mdp':password}), 
        );

        print(apiUrl);

        if (response.statusCode == 200) {
            print('Données envoyées avec succès');

            final String token = cleanToken(response.body);
            print(token);
            final response2 = await http.get(
                Uri.parse('$apiUrl/autorisation/'),
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $token',
                },
            );

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
                title: Text('Hello World App'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.of(context).pop();
                },
            ),
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
