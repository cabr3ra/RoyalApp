import 'package:flutter/material.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class PlayerList extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'Lista de Jugadores',
      showAppBar: true,
      bodyContent: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      'Lista de Jugadores',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '(si ves que falta algún jugador contáctame para actualizar la lista)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Player>>(
                  future: _firestoreService.getAllPlayers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('No hay jugadores registrados'));
                    } else {
                      final players = snapshot.data!;

                      return ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          int playerNumber = index + 1;
                          Player player = players[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: FutureBuilder<String>(
                                future: _storageService.getPlayerImageUrl(
                                    player.name, player.surname),
                                builder: (context, imageUrlSnapshot) {
                                  if (imageUrlSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (imageUrlSnapshot.hasError) {
                                    return Icon(Icons.error);
                                  } else if (!imageUrlSnapshot.hasData ||
                                      imageUrlSnapshot.data!.isEmpty) {
                                    return Icon(Icons.image_not_supported);
                                  } else {
                                    final imageUrl = imageUrlSnapshot.data!;
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                      radius: 20,
                                    );
                                  }
                                },
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    '$playerNumber. ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          12, // Ajusta el tamaño de la fuente según sea necesario
                                    ),
                                  ),
                                  Text(
                                    '${player.name} ${player.surname}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          12, // Ajusta el tamaño de la fuente según sea necesario
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
