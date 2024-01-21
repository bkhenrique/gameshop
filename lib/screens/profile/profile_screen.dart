import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/services/auth_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:game_shop/services/api_service.dart';
import 'dart:convert'; // Adiciona esta importação para usar json.decode
import 'package:http/http.dart' as http;
import 'package:game_shop/app/routes.dart';

// Se você tem uma classe 'Routes' com nomes de rota, certifique-se de que está corretamente importada
// import 'package:game_shop/app/routes.dart'; // Use esta importação se 'Routes' estiver definido aqui

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Esta função busca os dados do usuário a partir do token JWT
  Future<Map<String, dynamic>?> fetchUserData(String token) async {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    String userId = payload['id']; // ou a chave apropriada para o ID do usuário

    var url = Uri.parse('${ApiConfig.apiEndpoint}/usuario/$userId');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Retorna os dados do usuário
    } else {
      return null; // Retorna nulo em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context);

    // Se o usuário não estiver autenticado, exiba uma mensagem apropriada
    if (authService.token == null) {
      return const Scaffold(
        body: Center(
          child: Text('Usuário não autenticado.'),
        ),
      );
    }

    // Usamos FutureBuilder para carregar e exibir os dados do usuário
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(authService.token!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text('Erro ao carregar dados do usuário.'),
            ),
          );
        }

        // Aqui você pode acessar os dados do usuário que foram carregados
        Map<String, dynamic> userData = snapshot.data!;
        var profileData = ProfileData(
          name: userData['name'], // Substitua pelos campos corretos
          email: userData['email'], // Substitua pelos campos corretos
          userType: UserType.buyer, // Substitua pela lógica real
          visibleData: ['Name', 'E-mail', 'Type'],
          verified: userData['verified'] ?? false, // Substitua pela lógica real
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
                  child: const Text('Anuncios feitos'),
                ),
              ],
            ),
          ),
        );
      },
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
