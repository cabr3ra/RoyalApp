import 'package:flutter/material.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/screens/career_player.dart';
import 'package:royal_app/screens/home.dart';
import 'package:royal_app/screens/login.dart';
import 'package:royal_app/screens/privacy_policy.dart';
import 'package:royal_app/screens/register.dart';
import 'package:royal_app/screens/search_player.dart';
import 'package:royal_app/screens/list/user_list.dart';
import 'package:royal_app/screens/list/player_list.dart';

Map<String, WidgetBuilder> get appRoutes {
  return {
    Routes.home: (context) => Home(),
    Routes.login: (context) => Login(),
    Routes.register: (context) => Register(),
    Routes.searchPlayer: (context) => SearchPlayer(),
    Routes.careerPlayer: (context) => CareerPlayer(),
    Routes.userList: (context) => UserList(),
    Routes.playerList: (context) => PlayerList(),
    Routes.privacyPolicy: (context) => PrivacyPolicy(),
  };
}
