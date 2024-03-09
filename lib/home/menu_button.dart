import 'package:flutter/material.dart';


class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  MenuButton({required this.icon, required this.label,required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Color.fromARGB(255, 162, 0, 226).withAlpha(30),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 50.0),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}