import 'package:flutter/material.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/widgets/common/universal_dialog.dart';
import 'package:royal_app/widgets/common/age_calculator.dart';
import 'package:royal_app/widgets/common/animation_info.dart';
import 'package:royal_app/service/game_service.dart';

class PlayerItem extends StatefulWidget {
  final Player player;
  final FirestoreService firestoreService;
  final StorageService storageService;
  final Player? randomPlayer;
  final Function(Player) onPlayerMatch;
  final DateTime startTime;
  final int attempts;
  final GameService gameService;

  PlayerItem({
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
  _PlayerItemState createState() => _PlayerItemState();
}

class _PlayerItemState extends State<PlayerItem> {
  late Future<Map<String, String>> _playerInfoFuture;

  @override
  void initState() {
    super.initState();
    _playerInfoFuture = _fetchPlayerInfo();
  }

  @override
  void didUpdateWidget(PlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player != widget.player) {
      _playerInfoFuture = _fetchPlayerInfo();
    }
  }

  // Obtiene la información del jugador desde los servicios de almacenamiento y Firestore
  Future<Map<String, String>> _fetchPlayerInfo() async {
    final teamImageUrl =
        await widget.storageService.getTeamImageUrl(widget.player.actualTeamId);
    final nationalityImageUrl = await widget.storageService
        .getNationalityImageUrl(widget.player.nationalityId);
    final positionAbb =
        await widget.firestoreService.getPositionAbb(widget.player.positionId);

    return {
      'teamImageUrl': teamImageUrl,
      'nationalityImageUrl': nationalityImageUrl,
      'positionAbb': positionAbb,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPlayerName(),
          SizedBox(height: 12),
          _buildCompletionMessage(context),
        ],
      ),
    );
  }

  // Construye el widget con el nombre del jugador
  Widget _buildPlayerName() {
    return AnimationInfo(
      delay: 0,
      child: Text(
        '${widget.player.name} ${widget.player.surname}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      animationType: AnimationType.translateY,
    );
  }

  // Construye el widget con la información del jugador
  Widget _buildPlayerInfo(BuildContext context) {
    int infoDelay = 200;

    return FutureBuilder<Map<String, String>>(
      future: _playerInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('', style: TextStyle(color: Colors.white)));
        } else {
          final playerInfo = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFlexibleInfo(
                  'Nacionalidad',
                  playerInfo['nationalityImageUrl'],
                  infoDelay: infoDelay * 2,
                  isImage: true,
                  imageSize: 50,
                ),
                _buildFlexibleInfo(
                  'Equipo',
                  playerInfo['teamImageUrl'],
                  infoDelay: infoDelay * 4,
                  isImage: true,
                  imageSize: 50,
                ),
                _buildFlexibleInfo(
                  'Posición',
                  playerInfo['positionAbb'],
                  infoDelay: infoDelay * 6,
                  textSize: 14,
                ),
                _buildFlexibleInfo(
                  'Edad',
                  AgeCalculator.calculateAge(widget.player.dateOfBirth)
                      .toString(),
                  infoDelay: infoDelay * 8,
                  textSize: 14,
                ),
                _buildFlexibleInfo(
                  'Dorsal',
                  '#${widget.player.dorsal.toString()}',
                  infoDelay: infoDelay * 10,
                  textSize: 14,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Construye un widget flexible con información sobre el jugador
  Widget _buildFlexibleInfo(String label, String? value,
      {required int infoDelay,
      bool isImage = false,
      double imageSize = 50,
      double textSize = 14}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Flexible(
        child: AnimationInfo(
          delay: infoDelay,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _buildInfo(
              label,
              value,
              isImage: isImage,
              imageSize: imageSize,
              textSize: textSize,
            ),
          ),
          animationType: AnimationType.translateY,
        ),
      ),
    );
  }

  // Muestra un mensaje de éxito o fracaso basado en la información actual
  Widget _buildCompletionMessage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_shouldShowSuccessDialog()) {
        Future.delayed(Duration(milliseconds: 2500), () {
          _showSuccessDialog(context);
        });
      } else if (_shouldShowFailureDialog()) {
        Future.delayed(Duration(milliseconds: 2500), () {
          _showFailureDialog(context);
        });
      }
    });
    return _buildPlayerInfo(context);
  }

  // Muestra un diálogo de éxito
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
    widget.gameService.completeSearchPlayerGame(true);
  }

  // Muestra un diálogo de fracaso
  void _showFailureDialog(BuildContext context) async {
    String imageUrl = await widget.storageService.getPlayerImageUrl(
        widget.randomPlayer!.name, widget.randomPlayer!.surname);

    Duration elapsedTime = DateTime.now().difference(widget.startTime);
    int attempts = widget.attempts;

    UniversalDialog.showMatchDialog(
      context: context,
      dialogType: DialogType.failure,
      imageUrl: imageUrl,
      playerName: widget.randomPlayer!.name,
      playerSurname: widget.randomPlayer!.surname,
      elapsedTime: elapsedTime,
      attempts: attempts,
    );
    widget.gameService.completeSearchPlayerGame(false);
  }

  // Construye un widget con la información del jugador (ya sea imagen o texto)
  Widget _buildInfo(String label, String? value,
      {bool isImage = false, double imageSize = 50, double textSize = 14}) {
    String playerValue = _getPlayerAttribute(widget.player, label);
    String? randomPlayerValue = widget.randomPlayer != null
        ? _getPlayerAttribute(widget.randomPlayer!, label)
        : null;

    bool valuesMatch =
        randomPlayerValue != null && playerValue == randomPlayerValue;

    bool playerValueIsHigher = false;
    bool playerValueIsLower = false;

    if (randomPlayerValue != null) {
      if (int.tryParse(playerValue) != null &&
          int.tryParse(randomPlayerValue) != null) {
        int playerNumber = int.parse(playerValue);
        int randomPlayerNumber = int.parse(randomPlayerValue);

        playerValueIsHigher = playerNumber > randomPlayerNumber;
        playerValueIsLower = playerNumber < randomPlayerNumber;
      }
    }

    bool isDorsalOrAge =
        label.toLowerCase() == 'dorsal' || label.toLowerCase() == 'edad';

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: valuesMatch ? Colors.green : Colors.blueGrey,
      ),
      padding: EdgeInsets.all(5.5),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: value != null && value.isNotEmpty
                  ? Image.network(
                      value,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.person, size: imageSize, color: Colors.white),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: textSize,
                      color: Colors.white,
                    ),
                  ),
                  if (isDorsalOrAge && playerValueIsHigher)
                    Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                  if (isDorsalOrAge && playerValueIsLower)
                    Icon(Icons.arrow_upward, color: Colors.white, size: 12),
                ],
              ),
            ),
    );
  }

  // Obtiene el atributo del jugador basado en la etiqueta
  String _getPlayerAttribute(Player player, String label) {
    switch (label) {
      case 'Nacionalidad':
        return player.nationalityId ?? '';
      case 'Equipo':
        return player.actualTeamId ?? '';
      case 'Posición':
        return player.positionId ?? '';
      case 'Edad':
        return AgeCalculator.calculateAge(player.dateOfBirth).toString();
      case 'Dorsal':
        return player.dorsal.toString();
      default:
        return '';
    }
  }

  // Determina si se debe mostrar el diálogo de éxito
  bool _shouldShowSuccessDialog() {
    return widget.randomPlayer != null &&
        widget.player.id == widget.randomPlayer!.id;
  }

  // Determina si se debe mostrar el diálogo de fracaso
  bool _shouldShowFailureDialog() {
    return widget.randomPlayer != null && widget.attempts >= 5;
  }
}
