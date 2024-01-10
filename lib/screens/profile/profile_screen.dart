import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/main.dart';
import 'package:game_shop/app/routes.dart';
import 'package:game_shop/services/auth_service.dart'; // Importe o serviço de autenticação

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var authService = Provider.of<AuthService>(context);

    // Obtenha os dados do usuário autenticado
    var user = authService.currentUser;

    if (user == null) {
      // Se o usuário não estiver autenticado, você pode lidar com isso da maneira apropriada
      // ...
      return Scaffold(
        body: Center(
          child: Text('Usuário não autenticado.'),
        ),
      );
    }
    ProfileData profileData = ProfileData(
      name: user,
      email: user,
      userType: UserType.buyer, // Substitua por sua lógica real
      visibleData: ['Name', 'E-mail', 'Type'],
      verified: true, // Substitua por sua lógica real
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profileData.name}'),
            Text('E-mail: ${profileData.email}'),
            Text('User Type: ${profileData.userType}'),
            Text('Visible Data: ${profileData.visibleData.join(', ')}'),
            Text('Verified: ${profileData.verified ? 'Yes' : 'No'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a área do vendedor
                Navigator.pushNamed(context, sellerAreaScreen);
              },
              child: const Text('Seller Area'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final UserType userType;
  final List<String> visibleData;
  final bool verified;

  ProfileData({
    required this.name,
    required this.email,
    required this.userType,
    required this.visibleData,
    required this.verified,
  });
}

enum UserType {
  buyer,
  seller,
}
