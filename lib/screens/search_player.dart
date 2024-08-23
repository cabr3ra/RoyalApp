import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/widgets/player/player_item.dart';
import 'package:royal_app/widgets/common/search_input.dart';
import 'package:royal_app/widgets/common/attempts_info.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class SearchPlayer extends StatefulWidget {
  @override
  _SearchPlayerState createState() => _SearchPlayerState();
}

class _SearchPlayerState extends State<SearchPlayer> {
  // Controladores y servicios
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  // Variables para manejar resultados y estado del juego
  List<Player> _searchResults = [];
  List<Player> _attemptedPlayers = [];
  Player? _randomPlayer;
  static const int maxAttempts = 8;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _fetchRandomPlayer();
    _startTime = DateTime.now();
  }

  // Método para obtener un jugador aleatorio
  void _fetchRandomPlayer() async {
    try {
      Player? newRandomPlayer = await _firestoreService.getRandomPlayer();
      setState(() {
        _randomPlayer = newRandomPlayer;
      });
    } catch (e) {
      print('Error fetching random player: $e');
    }
  }

  // Método para realizar búsqueda de jugadores y obtener sus URLs de imágenes
  void _performSearch(String query) async {
    if (query.isEmpty) {
      _clearSearchResults();
    } else {
      try {
        // Buscar jugadores en la base de datos
        List<Player> results = await _firestoreService.searchPlayers(query);

        // Cargar las URLs de las imágenes en paralelo
        List<Future<Player>> imageFutures = results.map((player) async {
          String imageUrl = await _storageService.getPlayerImageUrl(
              player.name, player.surname);
          player.imageUrl = imageUrl;
          return player;
        }).toList();

        // Esperar a que todas las imágenes se carguen
        List<Player> playersWithImages = await Future.wait(imageFutures);

        // Actualizar el estado con los jugadores y sus URLs de imágenes
        setState(() {
          _searchResults = playersWithImages;
        });
      } catch (error) {
        print('Error al buscar jugadores: $error');
      }
    }
  }

  // Método para limpiar los resultados de búsqueda
  void _clearSearchResults() {
    setState(() {
      _searchResults.clear();
    });
  }

  // Método para seleccionar un jugador
  void _selectPlayer(Player player, GameService gameService) {
    if (_attemptedPlayers.length < maxAttempts) {
      setState(() {
        _attemptedPlayers.insert(0, player);
        if (_attemptedPlayers.length > maxAttempts) {
          _attemptedPlayers.removeLast();
        }
        _searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: '¿Qué Jugador Es?',
      bodyContent: [
        SearchInput(
          controller: _searchController,
          onChanged: _performSearch,
          onClear: _clearSearchResults,
        ),
        _buildSearchResultsContainer(),
        SizedBox(height: 5),
        _buildAttemptsInfo(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _attemptedPlayers.length,
            itemBuilder: (context, index) {
              Player player = _attemptedPlayers[index];
              return PlayerItem(
                player: player,
                randomPlayer: _randomPlayer,
                onPlayerMatch: (_) {},
                firestoreService: _firestoreService,
                storageService: _storageService,
                startTime: _startTime!,
                attempts: _attemptedPlayers.length,
                gameService: Provider.of<GameService>(context, listen: false),
              );
            },
          ),
        ),
      ],
    );
  }

  // Construye el contenedor de resultados de búsqueda
  Widget _buildSearchResultsContainer() {
    return Expanded(
      flex: _searchResults.isNotEmpty ? 1 : 0,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        child: _searchResults.isNotEmpty
            ? _buildSearchResults()
            : SizedBox(height: 0),
      ),
    );
  }

  // Construye la lista de resultados de búsqueda
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        Player player = _searchResults[index];
        return ListTile(
          leading: _buildPlayerImage(player.imageUrl),
          title: Text(
            '${player.name} ${player.surname}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => _selectPlayer(
            player,
            Provider.of<GameService>(context, listen: false),
          ),
        );
      },
    );
  }

  Widget _buildPlayerImage(String imageUrl) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
            : Icon(Icons.person, size: 40, color: Colors.grey),
      ),
    );
  }

  // Construye la información de intentos
  Widget _buildAttemptsInfo() {
    return AttemptsInfo(maxAttempts, _attemptedPlayers.length);
  }
}
