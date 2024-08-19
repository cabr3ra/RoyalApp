import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';

class ProgressBar extends StatelessWidget {
  final int currentUsers;
  final int goal;

  ProgressBar({required this.currentUsers, required this.goal});

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 200.0;

    double progressWidth = (currentUsers / goal) * maxWidth;
    progressWidth = progressWidth.clamp(0.0, maxWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'OBJETIVO DE USUARIOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.colorSecondary, AppColors.colorPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                width: progressWidth,
                decoration: BoxDecoration(
                  color: AppColors.colorGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Center(
                child: Text(
                  '$currentUsers / $goal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
