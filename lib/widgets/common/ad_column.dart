import 'package:flutter/material.dart';

class AdColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Ancho del contenedor para anuncios
      height: 100, // Altura del contenedor para anuncios
      color: Colors.blueGrey[100], // Color de fondo para el contenedor de anuncios
      child: Center(
        child: Text(
          'Anuncio',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
