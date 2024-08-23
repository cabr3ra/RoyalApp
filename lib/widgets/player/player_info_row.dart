import 'package:flutter/material.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/widgets/common/universal_dialog.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/widgets/common/animation_info.dart';

class PlayerInfoRow extends StatefulWidget {
  final Player player;
  final FirestoreService firestoreService;
  final StorageService storageService;
  final Player? randomPlayer;
  final Function(Player) onPlayerMatch;
  final DateTime startTime;
  final int attempts;
  final GameService gameService;

  PlayerInfoRow({
    required this.player,
    required this.firestoreService,
    required this.storageService,
    required this.randomPlayer,
    required this.onPlayerMatch,
    required this.startTime,
    required this.attempts,
    required this.gameService,
  });

  @override
  _PlayerInfoRowState createState() => _PlayerInfoRowState();
}

class _PlayerInfoRowState extends State<PlayerInfoRow> {
  late Future<Map<String, dynamic>> _playerCareerFuture;
  String _imageUrl = '';
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _fetchImageUrl();
    _playerCareerFuture = _fetchPlayerCareer();
  }

  @override
  void didUpdateWidget(PlayerInfoRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player.id != oldWidget.player.id) {
      _fetchImageUrl();
    }
  }

  // Obtiene la URL de la imagen del jugador desde el servicio de almacenamiento.
  Future<void> _fetchImageUrl() async {
    try {
      final imageUrl = await widget.storageService
          .getPlayerImageUrl(widget.player.name, widget.player.surname);
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error fetching image URL: $e');
      setState(() {});
    }
  }

  // Obtiene los datos de la carrera del jugador desde el servicio de Firestore.
  Future<Map<String, dynamic>> _fetchPlayerCareer() async {
    final careerData =
        await widget.firestoreService.getPlayerCareer(widget.player.id);
    return {'career': careerData};
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Muestra el diálogo de éxito o fracaso basado en las condiciones
      if (_shouldShowSuccessDialog() && !_dialogShown) {
        _dialogShown = true;
        Future.delayed(Duration(milliseconds: 1500), () {
          _showSuccessDialog(context);
        });
      } else if (_shouldShowFailureDialog() && !_dialogShown) {
        _dialogShown = true;
        Future.delayed(Duration(milliseconds: 1500), () {
          _showFailureDialog(context);
        });
      }
    });

    return _buildPlayerRow();
  }

  // Determina si se debe mostrar un diálogo de éxito.
  bool _shouldShowSuccessDialog() {
    return widget.randomPlayer != null &&
        widget.player.id == widget.randomPlayer!.id;
  }

  // Determina si se debe mostrar un diálogo de fracaso.
  bool _shouldShowFailureDialog() {
    return widget.randomPlayer != null && widget.attempts >= 8;
  }

  // Construye la fila que muestra la información del jugador.
  Widget _buildPlayerRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Centra la fila horizontalmente
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildPlayerName(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _buildPlayerAvatar(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildPlayerSurname(),
            ),
          ),
        ],
      ),
    );
  }

  // Construye el widget del avatar del jugador.
  Widget _buildPlayerAvatar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: _buildPlayerImage(_imageUrl),
      ),
    );
  }

  // Construye el widget de la imagen del jugador.
  Widget _buildPlayerImage(String imageUrl) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : Icon(Icons.person, size: 60, color: Colors.grey),
      ),
    );
  }

  // Construye el widget del nombre del jugador con animación.
  Widget _buildPlayerName() {
    return AnimationInfo(
      delay: 200,
      animationType: AnimationType.translateX,
      child: Text(
        '${widget.player.name}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.8),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Construye el widget del apellido del jugador con animación.
  Widget _buildPlayerSurname() {
    return AnimationInfo(
      delay: 200,
      animationType: AnimationType.translateXReverse,
      child: Text(
        '${widget.player.surname}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Muestra un diálogo de éxito cuando el jugador coincide con el jugador aleatorio.
  void _showSuccessDialog(BuildContext context) async {
    String imageUrl = await widget.storageService
        .getPlayerImageUrl(widget.player.name, widget.player.surname);

    Duration elapsedTime = DateTime.now().difference(widget.startTime);
    int attempts = widget.attempts;

    widget.onPlayerMatch(widget.player);

    UniversalDialog.showMatchDialog(
      context: context,
      dialogType: DialogType.success,
      imageUrl: imageUrl,
      playerName: widget.player.name,
      playerSurname: widget.player.surname,
      elapsedTime: elapsedTime,
      attempts: attempts,
    );
    widget.gameService.completeCareerPlayerGame(true);
  }

  // Muestra un diálogo de fracaso cuando se alcanza el número máximo de intentos.
  void _showFailureDialog(BuildContext context) async {
    String imageUrl = await widget.storageService.getPlayerImageUrl(
        widget.randomPlayer!.name, widget.randomPlayer!.surname);

    Duration elapsedTime = DateTime.now().difference(widget.startTime);
    int attempts = widget.attempts;

    widget.onPlayerMatch(widget.player);

    UniversalDialog.showMatchDialog(
      context: context,
      dialogType: DialogType.failure,
      imageUrl: imageUrl,
      playerName: widget.randomPlayer!.name,
      playerSurname: widget.randomPlayer!.surname,
      elapsedTime: elapsedTime,
      attempts: attempts,
    );
    widget.gameService.completeCareerPlayerGame(false);
  }
}
