import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/widgets/common/profile_info.dart';
import 'package:royal_app/service/user_service.dart';
import 'package:royal_app/widgets/common/base_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingName = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userService = Provider.of<UserService>(context, listen: false);
    nameController.text = userService.userData?.username ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return BaseScreen(
      appBarTitle: 'Perfil',
      bodyContent: [
        SizedBox(height: 50),
        _buildProfileInfo(userService),
      ],
    );
  }

  Widget _buildProfileInfo(UserService userService) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.colorPrimary, AppColors.colorSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: -4,
              blurRadius: 6,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfo(
              title: 'Usuario',
              value: userService.userData?.username ?? 'Usuario',
              isEditing: isEditingName,
              onEditPressed: () => _toggleEditName(userService),
              controller: nameController,
            ),
            _buildGradientDivider(),
            ProfileInfo(
              title: 'Email',
              value: userService.userData?.email ?? 'No disponible',
              isEditing: false,
              controller: TextEditingController(),
            ),
            _buildGradientDivider(),
            ProfileInfo(
              title: 'Puntos',
              value: userService.userData?.points.toString() ?? '0',
              isEditing: false,
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorCrown2, AppColors.colorCrown.withOpacity(0.7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  void _toggleEditName(UserService userService) {
    if (isEditingName) {
      // Save the new name
      userService.updateUserName(nameController.text).then((_) {
        // Optional: Show a success message or handle the update feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre actualizado exitosamente')),
        );
      }).catchError((error) {
        // Optional: Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el nombre')),
        );
      });
    }
    setState(() {
      isEditingName = !isEditingName;
    });
  }
}
