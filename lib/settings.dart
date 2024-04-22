// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import './bottombar.dart';
import './main.dart';
import './produit.dart';

class Param extends StatefulWidget {
    final String token;
    const Param({Key? key, required this.token}) : super(key: key);

    @override
    State<Param> createState() => _ParamState();
}

class _ParamState extends State<Param> {
    int _selectedIndex = 1;

    void _onItemTapped(int index) {
        setState(() {
            _selectedIndex = index;
        });

        if (index==0){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Produit(token:widget.token),
            ));
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Paramètres'),
                automaticallyImplyLeading: false,
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Formulaire()),
                        );
                    } , // Appel de la fonction lorsque le bouton est pressé
                    child: Text('Déconnexion'),
                ),
            ),
            bottomNavigationBar: Barre(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
            ),
        );
    }
}