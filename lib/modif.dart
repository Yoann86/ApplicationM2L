// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './produit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ModificationPage extends StatelessWidget {
    final String uuid;
    final String nom;
    final String description;
    final String prix;
    final String quantite;
    final String token;

    const ModificationPage({
        Key? key,
        required this.uuid,
        required this.nom,
        required this.description,
        required this.prix,
        required this.quantite,
        required this.token,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final TextEditingController _nomController = TextEditingController(text: nom);
        final TextEditingController _prixController = TextEditingController(text: prix);
        final TextEditingController _descriptionController = TextEditingController(text: description);
        final TextEditingController _quantiteController = TextEditingController(text: quantite);

        return Scaffold(
            appBar: AppBar(
                title: const Text('Modifier un article'),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ModificationForm(
                uuid: uuid,
                nomController: _nomController,
                prixController: _prixController,
                descriptionController: _descriptionController,
                quantiteController: _quantiteController,
                token: token,
                ),
            ),
        );
    }
}

class ModificationForm extends StatefulWidget {
    final String uuid;
    final TextEditingController nomController;
    final TextEditingController prixController;
    final TextEditingController descriptionController;
    final TextEditingController quantiteController;
    final String token;

    const ModificationForm({
        Key? key,
        required this.uuid,
        required this.nomController,
        required this.prixController,
        required this.descriptionController,
        required this.quantiteController,
        required this.token,
    }) : super(key: key);

    @override
    State<ModificationForm> createState() => _ModificationFormState();
}

class _ModificationFormState extends State<ModificationForm> {
    final _formKey = GlobalKey<FormState>();
    final String apiUrl = dotenv.env['API_URL'].toString();

    Future<void> _updateData() async {
        final nom = widget.nomController.text;
        final description = widget.descriptionController.text;
        final prix = widget.prixController.text;
        final quantite = widget.quantiteController.text;

        final response = await http.put(
            Uri.parse('$apiUrl/dashboard/modifierproduit/${widget.uuid}'),
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${widget.token}',
            },
            body: jsonEncode({
                'nom': nom,
                'description': description,
                'prix': prix,
                'quantite': quantite,
            }),
        );

        if (response.statusCode == 200) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Produit(token: widget.token)),
            );
        } else {
            print("erreur modif");
        }
    }

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    TextFormField(
                        controller: widget.nomController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un nom.';
                            }
                            return null;
                        },
                    ),
                    TextFormField(
                        controller: widget.prixController,
                        decoration: const InputDecoration(labelText: 'Prix'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un prix.';
                            }
                            return null;
                        },
                    ),
                    TextFormField(
                        controller: widget.descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Veuillez entrer une description.';
                            }
                            return null;
                        },
                    ),
                    TextFormField(
                        controller: widget.quantiteController,
                        decoration: const InputDecoration(labelText: 'Quantité'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Veuillez entrer une quantité.';
                            }
                            return null;
                        },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                                await _updateData();
                            }
                        },
                        child: const Text('Modifier'),
                    ),
                ],
            ),
        );
    }
}