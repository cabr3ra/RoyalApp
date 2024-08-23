import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/service/game_service.dart';

class Buttons extends StatefulWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final String task;

  const Buttons({
    required this.imagePath,
    required this.onPressed,
    this.task = '',
  });

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        final isAvailable = gameService.isGameAvailable(widget.task);
        final isCompleted = !isAvailable;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: ElevatedButton(
            onPressed: isAvailable ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              backgroundColor: isCompleted ? AppColors.colorCrown : AppColors.colorSecondary,
              shape: CircleBorder(),
              side: BorderSide(
                color: isCompleted ? AppColors.colorCrown : Colors.white,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: isHovered ? 80 : 60,
                height: isHovered ? 80 : 60,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
