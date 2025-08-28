import 'package:flutter/material.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.sort),
          title: const Text('Sắp xếp'),
          onTap: () => Navigator.pushNamed(context, '/sort'),
        ),
      ],
    );
  }
}