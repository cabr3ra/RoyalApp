import 'package:flutter/material.dart';
import 'package:royal_app/firebase/firestore_service.dart';

class UserList extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Registrados'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _firestoreService.getAllUsers(),
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
                  title: Text(user['email'] ?? 'Sin correo'),
                  subtitle: Text(
                      'Registrado el: ${user['createdAt']?.toDate().toString() ?? 'N/A'}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
