import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/service/game_service.dart';

class Buttons extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final String task;

  const Buttons({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.task = '',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        final isAvailable = gameService.isGameAvailable(task);
        final isCompleted = !isAvailable;

        return ElevatedButton(
          onPressed: isAvailable ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: isCompleted ? AppColors.colorCrown : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: isCompleted ? AppColors.colorCrown : AppColors.colorSecondary,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isCompleted ? Colors.white : AppColors.colorSecondary),
              SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.white : AppColors.colorSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
