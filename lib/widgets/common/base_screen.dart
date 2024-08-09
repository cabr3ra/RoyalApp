import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/widgets/common/ad_column.dart';
import 'package:royal_app/routing/routes.dart';

class BaseScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> bodyContent;

  BaseScreen({
    this.appBarTitle = '',
    required this.bodyContent,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.colorPrimary,
              AppColors.colorSecondary,
              AppColors.colorPrimary,
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Row(
                children: [
                  if (screenWidth > 600)
                    _buildSideAdColumn(),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 20.0), // Ajusta el padding vertical según sea necesario
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: bodyContent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (screenWidth > 600)
                    _buildSideAdColumn(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSideAdColumn() {
    return Container(
      width: 100,
      color: Colors.transparent,
      child: Center(
        child: AdColumn(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorSecondary, AppColors.colorPrimary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              width: 30,
              height: 30,
              child: Image.asset('assets/widgets/settings.png'),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
        leading: IconButton(
          icon: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('assets/widgets/profile.png'),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.profile);
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorPrimary, AppColors.colorSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          '© 2024 Royal App || Todos los logotipos y marcas son propiedad de sus respectivos propietarios y se utilizan solo para fines de identificación.',
          style: TextStyle(color: Colors.white, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
