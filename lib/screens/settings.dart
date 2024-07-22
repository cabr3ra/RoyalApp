import 'package:flutter/material.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'Ajustes',
      bodyContent: [
        Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        // Agrega más widgets aquí según sea necesario
      ],
    );
  }
}
