import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/service/user_service.dart';
import 'package:royal_app/widgets/common/donation.dart';
import 'package:royal_app/widgets/common/progress_bar.dart';

class AdColumnRight extends StatefulWidget {
  @override
  _AdColumnRightState createState() => _AdColumnRightState();
}

class _AdColumnRightState extends State<AdColumnRight> {
  int _userCount = 0;
  static const int _goal = 1000;

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
  }

  Future<void> _fetchUserCount() async {
    final userService = Provider.of<UserService>(context, listen: false);
    int userCount = await userService.getUserCount();
    setState(() {
      _userCount = userCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '¡Hola! Soy 🍅, estudiante programador y seguidor de la Kings y Queens League.\n\n'
                      'Decidí crear esta web para que jugadores, presidentes, creadores de contenido disfruten tanto como yo disfruté haciéndola.\n\n'
                      '¡Espero que les guste! 😄',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 10),
                  ProgressBar(
                    currentUsers: _userCount,
                    goal: _goal,
                  ),
                ],
              ),
            ),
          ),
          Donation(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
