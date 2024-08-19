import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/screens/ad_column_left.dart';
import 'package:royal_app/screens/ad_column_right.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> bodyContent;
  final bool showAppBar;
  final bool showAdColumnLeft;
  final bool showAdColumnRight;

  BaseScreen({
    this.appBarTitle = '',
    required this.bodyContent,
    this.showAppBar = true,
    this.showAdColumnLeft = true,
    this.showAdColumnRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.colorPrimary,
                    AppColors.colorSecondary,
                    AppColors.colorPrimary
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  if (showAdColumnLeft)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: AdColumnLeft(),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showAppBar) _buildAppBar(context),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: bodyContent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showAdColumnRight)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: AdColumnRight(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.colorPrimary,
              AppColors.colorSecondary,
              AppColors.colorPrimary
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      centerTitle: true,
      title: Hero(
        tag: 'logoImage',
        child: IconButton(
          icon: SizedBox(
            height: 40,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.home);
          },
        ),
      ),
      actions: [
        IconButton(
          icon: SizedBox(
            height: 30,
            child: Image.asset(
              'assets/widgets/perfil.png',
              fit: BoxFit.contain,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.playerList);
          },
        ),
      ],
    );
  }


  Widget _buildFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorPrimary, AppColors.colorSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              '© 2024 Royal App || Todos los logotipos y marcas son propiedad de sus respectivos propietarios y se utilizan solo para fines de identificación.',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.privacyPolicy);
                },
                child: Text(
                  'Políticas de privacidad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              GestureDetector(
                onTap: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'uri.tucody@gmail.com',
                  );

                  try {
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    } else {
                      print('No se puede abrir la aplicación de correo.');
                    }
                  } catch (e) {
                    print('Error lanzando el correo: $e');
                  }
                },
                child: Text(
                  'Contacto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
