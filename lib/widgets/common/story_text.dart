import 'dart:math';
import 'package:flutter/material.dart';
import 'package:royal_app/models/story_option.dart';

class StoryText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Seleccionar un mensaje aleatorio de las opciones
    Random random = Random();
    StoryOption selectedOption = storyOptions[random.nextInt(storyOptions.length)];

    return Text(
      selectedOption.message,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
        fontFamily: 'OldEnglish',
      ),
      textAlign: TextAlign.justify,
    );
  }
}
