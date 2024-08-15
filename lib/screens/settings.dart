import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/widgets/common/base_screen.dart';
import 'package:royal_app/service/user_service.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'Ajustes',
      bodyContent: [
        SizedBox(height: 100),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.privacyPolicy);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: Text(
            'Política de privacidad',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: () => _handleSignOut(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            'Salir',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignOut(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.signOut();
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
