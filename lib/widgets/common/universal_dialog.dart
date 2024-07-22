import 'package:flutter/material.dart';
import 'package:royal_app/routing/routes.dart';

enum DialogType { success, failure }

class UniversalDialog {
  static void showMatchDialog({
    required BuildContext context,
    required DialogType dialogType,
    required String imageUrl,
    required String playerName,
    required String playerSurname,
    required Duration elapsedTime,
    required int attempts,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogType == DialogType.success
              ? Colors.black87
              : Colors.redAccent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dialogType == DialogType.success ||
                  dialogType == DialogType.failure)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                '$playerName $playerSurname',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Tiempo: ${elapsedTime.inMinutes}m ${elapsedTime.inSeconds % 60}s',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Intentos: $attempts',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Volver', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.home);
              },
            ),
          ],
        );
      },
    );
  }
}
