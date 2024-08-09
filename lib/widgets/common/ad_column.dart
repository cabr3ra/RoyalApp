import 'package:flutter/material.dart';

class AdColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Center(
        child: Text(
          'Anuncio',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
