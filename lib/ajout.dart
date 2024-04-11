// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, use_build_context_synchronously
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import './produit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AjoutPage extends StatelessWidget {
    final String token;

    const AjoutPage({Key? key, required this.token}) : super(key: key);
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Ajouter un article'),
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: AjoutForm(token:token),
            ),
        );
    }
}

class AjoutForm extends StatefulWidget {
    final String token;
    const AjoutForm({Key? key, required this.token}) : super(key: key);

    @override
    State<AjoutForm> createState() => _AjoutFormState();
}

class _AjoutFormState extends State<AjoutForm> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nomController = TextEditingController();
    final TextEditingController _prixController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _quantiteController = TextEditingController();
    Uint8List? _imageBytes;
    final String apiUrl = dotenv.env['API_URL'].toString();

    Future<void> _getImage() async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
            final imageBytes = await pickedFile.readAsBytes();
            setState(() {
                _imageBytes = imageBytes;
            });
        }
    }

    Future<int> _uploadData() async {
        final nom = _nomController.text;
        final description = _descriptionController.text;
        final prix = _prixController.text;
        final quantite = _quantiteController.text;

        if (_imageBytes == null) {
            return -1;
        }

        var request = http.MultipartRequest(
            'POST',
            Uri.parse('$apiUrl/dashboard/ajouterproduit'),
        );

        request.headers['Content-Type'] = 'application/json; charset=UTF-8';
        request.headers['Authorization'] = 'Bearer ${widget.token}';

        request.files.add(http.MultipartFile.fromBytes(
            'image',
            _imageBytes!,
            filename: 'image_$nom$prix$quantite.jpg',
        ));

        request.fields['nom'] = nom;
        request.fields['description'] = description;
        request.fields['prix'] = prix;
        request.fields['quantite'] = quantite;

        var response = await request.send();

        print(response.statusCode);
        return response.statusCode;
    }

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom.';
                        }
                        return null;
                    },
                ),
                TextFormField(
                    controller: _prixController,
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
                    controller: _descriptionController,
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
                    controller: _quantiteController,
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
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    if (_imageBytes != null)
                        Image.memory(
                            _imageBytes!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                        ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: _getImage,
                        child: Text('Sélectionner une image'),
                    ),
                    ],
                ),
                ElevatedButton(
                    onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                            final statusCode = await _uploadData();
                            if (statusCode == 200) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Produit(token: widget.token)),
                            );
                        }
                    }
                },
                    child: const Text('Ajouter'),
                ),
                ],
            ),
        );
    }
}