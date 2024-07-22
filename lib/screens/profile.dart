import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/firebase/auth_service.dart';
import 'package:royal_app/service/game_service.dart';
import 'package:royal_app/service/user_profile_service.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isEditingName = false;
  bool _isEditingAge = false;

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);

    if (userProfileService.userProfile != null) {
      _nameController.text = userProfileService.userProfile!.name;
      _ageController.text = userProfileService.userProfile!.age.toString();
    }

    return BaseScreen(
      appBarTitle: 'Perfil',
      bodyContent: [
        _buildProfileInfo(context),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    return Center(
      child: Container(
        width: 400,
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(90), // Ancho de la columna del título
            1: FixedColumnWidth(190), // Ancho de la columna del subtítulo
            2: FixedColumnWidth(70), // Ancho de la columna del ícono
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildInfoRow(
              title: 'Nombre',
              controller: _nameController,
              isEditing: _isEditingName,
              onEditPressed: () async {
                if (_isEditingName) {
                  await _updateProfile(name: _nameController.text);
                }
                setState(() {
                  _isEditingName = !_isEditingName;
                });
              },
            ),
            _buildInfoRow(
              title: 'Email',
              subtitle: user?.email ?? 'No disponible',
              isEditing: false,
            ),
            _buildInfoRow(
              title: 'Edad',
              controller: _ageController,
              isEditing: _isEditingAge,
              keyboardType: TextInputType.number,
              onEditPressed: () async {
                if (_isEditingAge) {
                  await _updateProfile(age: int.parse(_ageController.text));
                }
                setState(() {
                  _isEditingAge = !_isEditingAge;
                });
              },
            ),
            _buildInfoRow(
              title: 'Puntos',
              subtitle:
                  Provider.of<GameService>(context).playerPoints.toString(),
              isEditing: false,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildInfoRow({
    required String title,
    String? subtitle,
    TextEditingController? controller,
    bool isEditing = false,
    VoidCallback? onEditPressed,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TableRow(
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: controller != null
              ? TextField(
                  controller: controller,
                  enabled: isEditing,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: title,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  style: TextStyle(color: Colors.white70),
                )
              : Text(
                  subtitle ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: controller != null
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.white, size: 18),
                  onPressed: onEditPressed,
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> _updateProfile({String? name, int? age}) async {
    print('Actualizando perfil: nombre=$name, edad=$age');

    // Actualiza el perfil del usuario
    await Provider.of<UserProfileService>(context, listen: false)
        .updateUserProfile(
      name ?? _nameController.text,
      age ?? int.parse(_ageController.text),
    );
  }
}
