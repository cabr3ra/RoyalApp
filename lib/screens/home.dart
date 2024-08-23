import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/widgets/common/buttons.dart';
import 'package:royal_app/widgets/common/weekly_calendar.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'Home',
      bodyContent: [
        const SizedBox(height: 20),
        WeeklyCalendar(),
        const SizedBox(height: 100),
        _buildButtonGrid(context),
      ],
    );
  }

  Widget _buildButtonGrid(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 50,
            runSpacing: 50,
            children: [
              Buttons(
                imagePath: 'assets/widgets/search.png',
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
                task: 'searchPlayer',
              ),
              Buttons(
                imagePath: 'assets/widgets/career.png',
                onPressed: () {
                  if (gameService.isGameAvailable('careerPlayer')) {
                    Navigator.pushNamed(context, Routes.careerPlayer)
                        .then((result) {
                      if (result == true) {
                        gameService.completeCareerPlayerGame(true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('¡Has completado Modo Carrera!')),
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
                task: 'careerPlayer',
              ),
              // Agregar más botones si es necesario
            ],
          ),
        );
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
