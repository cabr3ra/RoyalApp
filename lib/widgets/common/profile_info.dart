import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String title;
  final String value;
  final bool isEditing;
  final VoidCallback? onEditPressed;
  final TextInputType keyboardType;
  final TextEditingController controller;

  ProfileInfo({
    required this.title,
    required this.value,
    this.isEditing = false,
    this.onEditPressed,
    this.keyboardType = TextInputType.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: title,
              hintStyle: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
              : GestureDetector(
            onTap: onEditPressed,
            child: Text(
              value.isEmpty ? title : value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
