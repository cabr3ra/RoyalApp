import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/firebase_options.dart';
import 'package:royal_app/service/user_service.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/routing/app_routes.dart';
import 'package:royal_app/routing/routes.dart';

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
        // Proveedor para FirestoreService
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),

        // Proveedor para StorageService
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),

        // Proveedor para FirebaseFirestore
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),

        // Proveedor para UserService
        ChangeNotifierProxyProvider<FirebaseFirestore, UserService>(
          create: (context) => UserService(),
          update: (context, firestore, userService) {
            userService!.updateFirestore(firestore);
            return userService;
          },
        ),

        // Proveedor para GameService
        ChangeNotifierProxyProvider<UserService, GameService>(
          create: (context) => GameService(
            Provider.of<UserService>(context, listen: false),
          ),
          update: (context, userService, gameService) {
            gameService!.updateUserService(userService);
            return gameService;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Royal App',
        routes: appRoutes,
        initialRoute: Routes.login,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
