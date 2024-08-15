import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/widgets/common/ad_column.dart';
import 'package:royal_app/routing/routes.dart';

class BaseScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> bodyContent;
  final bool showAppBar;

  BaseScreen({
    this.appBarTitle = '',
    required this.bodyContent,
    this.showAppBar = true,
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      // Transparent to show the gradient
                      child: Center(
                        child: AdColumn(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.transparent,
                      // Transparent to show the gradient
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showAppBar) _buildAppBar(context),
                          Flexible(
                            flex: 2, // Adjust flex value as needed
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      // Transparent to show the gradient
                      child: Center(
                        child: AdColumn(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(),
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
