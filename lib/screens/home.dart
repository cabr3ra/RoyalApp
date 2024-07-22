import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/widgets/common/buttons.dart';
import 'package:royal_app/widgets/common/weekly_calendar.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class Home extends StatelessWidget {
  final double iconSize = 30;
  final double buttonFontSize = 16;
  final double textFontSize = 16;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'Home',
      bodyContent: [
        const SizedBox(height: 10),
        WeeklyCalendar(),
        const SizedBox(height: 10),
        _buildScore(context),
        const SizedBox(height: 50),
        _buildSearchPlayerButton(context),
        const SizedBox(height: 20),
        _buildCareerPlayerButton(context),
      ],
    );
  }

  Widget _buildScore(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Text(
          'Puntos: ${gameService.playerPoints}',
          style: TextStyle(
              fontSize: textFontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Consumer<GameService> _buildSearchPlayerButton(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Buttons(
            icon: Icons.person_search,
            text: '¿Qué Jugador Es?',
            onPressed: () {
              if (gameService.isGameAvailable('searchPlayer')) {
                Navigator.pushNamed(context, Routes.searchPlayer)
                    .then((result) {
                  if (result == true) {
                    gameService.completeSearchPlayerGame(true);

                    if (!gameService.isGameAvailable('searchPlayer') &&
                        !gameService.isGameAvailable('careerPlayer')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '¡Has completado todos los juegos del día!')),
                      );
                    }
                  }
                });
              } else {
                _showNextAvailableTime(context, 'searchPlayer');
              }
            },
            task: 'searchPlayer');
      },
    );
  }

  Consumer<GameService> _buildCareerPlayerButton(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Buttons(
            icon: Icons.person_pin,
            text: 'Modo Carrera',
            onPressed: () {
              if (gameService.isGameAvailable('careerPlayer')) {
                Navigator.pushNamed(context, Routes.careerPlayer)
                    .then((result) {
                  if (result == true) {
                    gameService.completeCareerPlayerGame(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('¡Has completado Modo Carrera!')),
                    );
                    if (!gameService.isGameAvailable('searchPlayer') &&
                        !gameService.isGameAvailable('careerPlayer')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '¡Has completado todos los juegos del día!')),
                      );
                    }
                  }
                });
              } else {
                _showNextAvailableTime(context, 'careerPlayer');
              }
            },
            task: 'careerPlayer');
      },
    );
  }

  void _showNextAvailableTime(BuildContext context, String task) {
    final gameService = Provider.of<GameService>(context, listen: false);
    final duration = gameService.getTimeUntilNextAvailable(task);
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Este juego estará disponible en $hours horas, $minutes minutos y $seconds segundos.',
        ),
      ),
    );
  }
}
