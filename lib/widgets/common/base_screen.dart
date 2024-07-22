import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/widgets/common/ad_column.dart';
import 'package:royal_app/routing/routes.dart';

class BaseScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> bodyContent;

  BaseScreen({
    required this.appBarTitle,
    required this.bodyContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: AdColumn(),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.colorPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
              color: Colors.grey[300],
              child: Center(
                child: AdColumn(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
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
}
