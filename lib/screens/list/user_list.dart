import 'package:flutter/material.dart';
import 'package:royal_app/service/user_service.dart';
import 'package:royal_app/models/user_data.dart';

class UserList extends StatelessWidget {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Registrados'),
      ),
      body: FutureBuilder<List<UserData>>(
        future: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay usuarios registrados'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.email ?? 'Sin correo'),
                  subtitle: Text(
                      'Username: ${user.username ?? 'N/A'}, Puntos: ${user.points ?? 'N/A'}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
