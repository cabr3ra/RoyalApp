import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/service/game_service.dart';

class WeeklyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildWeekRows(gameService),
        );
      },
    );
  }

  List<Widget> _buildWeekRows(GameService gameService) {
    final now = DateTime.now();
    final centralDay = now;
    final adjustedStartOfWeek = centralDay.subtract(Duration(days: 3));

    List<Widget> daysInWeek = List.generate(7, (index) {
      final dayDate = adjustedStartOfWeek.add(Duration(days: index));
      final dayCompleted = _isDayCompleted(dayDate, gameService);
      return _buildDayCircle(dayDate, dayCompleted, dayDate == centralDay);
    });

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: daysInWeek,
      ),
    ];
  }

  bool _isDayCompleted(DateTime dayDate, GameService gameService) {
    final startOfDay = DateTime(dayDate.year, dayDate.month, dayDate.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final careerPlayerCompleted = gameService.careerPlayerCompletedAt != null &&
        gameService.careerPlayerCompletedAt!.isAfter(startOfDay) &&
        gameService.careerPlayerCompletedAt!.isBefore(endOfDay);

    final searchPlayerCompleted = gameService.searchPlayerCompletedAt != null &&
        gameService.searchPlayerCompletedAt!.isAfter(startOfDay) &&
        gameService.searchPlayerCompletedAt!.isBefore(endOfDay);

    return careerPlayerCompleted && searchPlayerCompleted;
  }

  Widget _buildDayCircle(DateTime dayDate, bool completed, bool isToday) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: completed ? AppColors.colorExtra : (isToday ? Colors.blue : Colors.grey),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          dayDate.day.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
