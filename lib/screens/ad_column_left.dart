import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/service/user_service.dart';

class AdColumnLeft extends StatelessWidget {
  final String imagePath = 'assets/widgets/ranking.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 500,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.colorPrimary,
                            AppColors.colorSecondary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          _buildScore(context),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Expanded(
            child: Container(
              height: 90,
              color: Colors.transparent,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _handleSignOut(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Background color of the button
                  ),
                  child: Text(
                    'Salir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScore(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        return Text(
          'Puntos: ${userService.userData?.points ?? 0}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  void _handleSignOut(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.signOut();
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
