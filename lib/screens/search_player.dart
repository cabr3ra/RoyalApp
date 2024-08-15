import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
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
  static const int maxAttempts = 5;
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

  // Método para realizar búsqueda de jugadores
  void _performSearch(String query) {
    if (query.isEmpty) {
      _clearSearchResults();
    } else {
      _firestoreService.searchPlayers(query).then((results) {
        setState(() {
          _searchResults = results;
        });
      }).catchError((error) {
        print('Error searching players: $error');
      });
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
        const SizedBox(height: 10),
        _buildSearchResultsContainer(),
        const SizedBox(height: 10),
        Center(
          child: AttemptsInfo(maxAttempts, _attemptedPlayers.length),
        ),
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
        decoration: BoxDecoration(
          color: AppColors.colorSecondary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        child: _searchResults.isNotEmpty
            ? _buildSearchResults()
            : SizedBox(height: 50),
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
          title: Text(
            '${player.name} ${player.surname}',
            style: TextStyle(
              color: Colors.white,
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
}
