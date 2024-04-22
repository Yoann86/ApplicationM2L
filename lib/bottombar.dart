import 'package:flutter/material.dart';

class Barre extends StatelessWidget {
    final int currentIndex;
    final void Function(int) onTap;

    const Barre({Key? key,required this.currentIndex,required this.onTap,}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Accueil',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Paramètres',
                ),
            ],
        );
    }
}