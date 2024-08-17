import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/firebase/storage_service.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/widgets/common/animation_info.dart';

class RandomInfoRow extends StatefulWidget {
  final Player? randomPlayer;
  final FirestoreService firestoreService;
  final StorageService storageService;

  // Constructor que recibe el jugador aleatorio y los servicios necesarios
  RandomInfoRow(this.randomPlayer, this.firestoreService, this.storageService);

  @override
  _RandomInfoRowState createState() => _RandomInfoRowState();
}

class _RandomInfoRowState extends State<RandomInfoRow> {
  late Future<Map<String, dynamic>> _randomPlayerCareerFuture;

  @override
  void initState() {
    super.initState();
    _randomPlayerCareerFuture = _fetchRandomPlayerCareer();
  }

  // Método para obtener los datos de carrera del jugador aleatorio
  Future<Map<String, dynamic>> _fetchRandomPlayerCareer() async {
    if (widget.randomPlayer == null) {
      return {};
    }

    final careerData =
    await widget.firestoreService.getPlayerCareer(widget.randomPlayer!.id);

    await _prepareTeamImageUrls(careerData);

    return {'career': careerData};
  }

  // Método para preparar las URL de las imágenes de los equipos
  Future<void> _prepareTeamImageUrls(Map<String, dynamic> careerData) async {
    List<Future<void>> futures = [];
    careerData.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('splits')) {
        List<dynamic> splits = value['splits'];
        splits.asMap().forEach((index, split) {
          if (split is String &&
              split.trim().isNotEmpty &&
              int.tryParse(split) != null) {
            String teamId = split.trim();
            futures.add(
              widget.storageService.getTeamImageUrl(teamId).then((imageUrl) {
                value['splits'][index] = imageUrl;
              }),
            );
          }
        });
      }
    });
    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: _randomPlayerCareerFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text(''));
            } else {
              final randomPlayerCareer =
              snapshot.data!['career'] as Map<String, dynamic>;
              return _buildCareerInfoWidgets(randomPlayerCareer);
            }
          },
        ),
      ],
    );
  }

  // Construye los widgets que muestran la información de carrera del jugador
  Widget _buildCareerInfoWidgets(Map<String, dynamic> careerData) {
    List<Widget> splitWidgets = [];

    careerData.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('splits')) {
        List<dynamic> splits = value['splits'];
        splits.asMap().forEach((index, split) {
          if (split.isNotEmpty) {
            String season = key.replaceAll("/", "/");
            splitWidgets.add(_buildSplitWidget(index + 1, split, season));
          }
        });
      }
    });

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 5,
      children: splitWidgets,
    );
  }

  // Construye un widget para cada división de la carrera del jugador
  Widget _buildSplitWidget(int position, dynamic split, String season) {
    return Column(
      children: [
        _buildInfoLabel(position, season),
        _buildInfoItem(
          split.toString(),
          isImage: split.toString().startsWith('http'),
        ),
      ],
    );
  }

  // Construye una etiqueta con el nombre de la temporada y la posición
  Widget _buildInfoLabel(int position, String season) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.colorPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            season,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Split $position',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Construye un widget para cada ítem de información, ya sea texto o imagen
  Widget _buildInfoItem(String info, {bool isImage = false}) {
    return Container(
      width: 60,
      height: 60,
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: isImage
              ? AnimationInfo(
            animationType: AnimationType.fadeIn,
            child: Image.network(
              info,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          )
              : Center(
            child: Text(
              info,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
