import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/service/game_service2.dart';

class WeeklyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameService2>(
      builder: (context, gameService, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildWeekRows(gameService),
        );
      },
    );
  }

  List<Widget> _buildWeekRows(GameService2 gameService) {
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

  bool _isDayCompleted(DateTime dayDate, GameService2 gameService) {
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
        gradient: _getDayCircleGradient(completed, isToday),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          dayDate.day.toString(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  LinearGradient _getDayCircleGradient(bool completed, bool isToday) {
    if (completed) {
      return LinearGradient(
        colors: [AppColors.colorCrown, Colors.deepOrange],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (isToday) {
      return LinearGradient(
        colors: [Colors.white, AppColors.colorSecondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return LinearGradient(
        colors: [Colors.grey, AppColors.colorSecondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
