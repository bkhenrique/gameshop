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
    String userId = payload['sub']; // Ajuste para o campo correto do seu JWT

    var url = Uri.parse('${ApiConfig.apiEndpoint}/usuarios/$userId');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      return null;
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
        var name = userData['nome'] ?? 'Nome não disponível';
        var email = userData['email'] ?? 'Email não disponível';
        var userType = userData['tipo_usuario'] ?? 'Tipo não disponível';
        var verified = userData['verificado'] == 1;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${userData['id']}'),
                Text('Nome: ${userData['nome']}'),
                Text('Email: ${userData['email']}'),
                if (userData['idade'] != null)
                  Text('Idade: ${userData['idade']}'),
                if (userData['data_nascimento'] != null)
                  Text('Data de Nascimento: ${userData['data_nascimento']}'),
                Text('Tipo de Usuário: ${userData['tipo_usuario']}'),
                if (userData['avatar'] != null)
                  Text('Avatar: ${userData['avatar']}'),
                Text(
                    'Verificado: ${userData['verificado'] == 1 ? 'Sim' : 'Não'}'),
                if (userData['whatsapp'] != null)
                  Text('WhatsApp: ${userData['whatsapp']}'),
                if (userData['line'] != null) Text('Line: ${userData['line']}'),
                if (userData['telegram'] != null)
                  Text('Telegram: ${userData['telegram']}'),
                if (userData['apelido'] != null)
                  Text('Apelido: ${userData['apelido']}'),
                if (userData['nome_revenda'] != null)
                  Text('Nome Revenda: ${userData['nome_revenda']}'),
                Text('Conta Criada em: ${userData['created_at']}'),
                Text('Última Atualização: ${userData['updated_at']}'),
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
