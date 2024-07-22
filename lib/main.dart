import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/firebase_options.dart';
import 'package:royal_app/firebase/auth_service.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/routing/app_routes.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/service/user_profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(RoyalApp());
}

class RoyalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        // Proveedor para UserProfileService
        ChangeNotifierProxyProvider2<FirestoreService, AuthService, UserProfileService>(
          create: (_) => UserProfileService(
            Provider.of<FirestoreService>(_, listen: false),
            Provider.of<AuthService>(_, listen: false),
          ),
          update: (_, firestoreService, authService, userProfileService) =>
              UserProfileService(firestoreService, authService),
        ),

        // Proveedor para GameService
        ChangeNotifierProxyProvider<UserProfileService, GameService>(
          create: (context) => GameService(
            Provider.of<UserProfileService>(context, listen: false),
          ),
          update: (context, userProfileService, gameService) =>
              GameService(userProfileService),
        ),
      ],
      child: MaterialApp(
        title: 'Royal App',
        routes: appRoutes,
        initialRoute: Routes.login,
      ),
    );
  }
}
