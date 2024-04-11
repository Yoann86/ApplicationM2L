// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './ajout.dart';
import './modif.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Produit extends StatefulWidget {
    final String token;

    const Produit({Key? key, required this.token}) : super(key: key);

    @override
    // ignore: library_private_types_in_public_api
    _ProduitState createState() => _ProduitState();
}

class _ProduitState extends State<Produit> {
    List<dynamic> productList = []; 
    final String apiUrl = dotenv.env['API_URL'].toString();

    @override
    void initState() {
        super.initState();
        getData();
    }

    Future<void> getData() async {
        final response = await http.get(
            Uri.parse('$apiUrl/dashboard/produits'),
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${widget.token}',
            },
        );

        if (response.statusCode == 200) {
            setState(() {
                productList = jsonDecode(response.body) as List<dynamic>;
            });
        } else {
            print('Échec de l\'envoi des données avec le code de statut ${response.statusCode}');
        }
    }

    Future<void> deleteProduct(String uuid) async {
        final response = await http.delete(
            Uri.parse('$apiUrl/produit/$uuid'),
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${widget.token}',
            },
        );

        if (response.statusCode == 200) {
            getData();
        } else {
            print('Échec de la suppression du produit avec le code de statut ${response.statusCode}');
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: null,
            
            body: productList.isEmpty
                ? Center(
                    child: Text("chargement ..."), 
                    )
                : Column(children:[
                    Expanded(child: 
                        ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                            final product = productList[index];
                            return Card(
                                elevation: 3,
                                margin: EdgeInsets.all(8),
                                child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                            product['nom'],
                                                            style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                            'Prix: ${product['prix'].toStringAsFixed(2)}€',
                                                            style: TextStyle(fontSize: 16),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                            'Quantité: ${product['quantite']}',
                                                            style: TextStyle(fontSize: 16),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            SizedBox(width: 16),
                                            Image.network(
                                                '$apiUrl/${product['image']}',
                                                width: 100, 
                                                height: 100, 
                                                fit: BoxFit.cover, 
                                            ),
                                            SizedBox(width: 16),
                                            PopupMenuButton<String>(
                                                onSelected: (value) {
                                                    if (value == 'modifier') {
                                                        Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ModificationPage(nom:product['nom'],description:product['description'],prix:product['prix'].toString(),quantite:product['quantite'].toString(),uuid:product['uuid'],token:widget.token)),
                                                        );
                                                    } else if (value == 'supprimer') {
                                                        String uuid = product['uuid'];
                                                        deleteProduct(uuid);
                                                    }
                                                },
                                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                    PopupMenuItem<String>(
                                                        value: 'modifier',
                                                        child: ListTile(
                                                            leading: Icon(Icons.edit),
                                                            title: Text('Modifier'),
                                                        ),
                                                    ),
                                                    PopupMenuItem<String>(
                                                        value: 'supprimer',
                                                        child: ListTile(
                                                            leading: Icon(Icons.delete),
                                                            title: Text('Supprimer'),
                                                        ),
                                                    ),
                                                ],
                                            )
                                ])),
                            );},
                        ),
                    ),
                    Container(margin: EdgeInsets.only(bottom: 16),
                        child:
                            FloatingActionButton(
                                onPressed: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AjoutPage(token:widget.token)),
                                    );
                                },
                                child: Icon(Icons.add),
                            ),
                        ),
                ])
        );
    }
}