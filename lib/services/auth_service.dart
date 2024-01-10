import 'dart:convert';
import 'package:http/http.dart'
    as http; // Adicione esta linha para importar a biblioteca http
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  String? _token;
  String? user; // Add this line to define the user variable

  String? get token => _token;
  String? get currentUser => _getCurrentUser();

  Future<void> loginWithGoogle() async {
    final googleAuthUrl =
        Uri.parse('http://127.0.0.1:8000/api/auth/google/redirect');
    print("url google pressionada");
    print("url google pressionada ${googleAuthUrl}");

    try {
      await launchUrl(googleAuthUrl);
    } catch (e) {
      print('Error launching Google authentication URL: $e');
      throw 'Could not launch Google authentication URL';
    }
  }

  Future<void> loginWithFacebook() async {
    final facebookAuthUrl = 'http://127.0.0.1:8000/api/auth/facebook/redirect';

    print("url facebook precionada");
    try {
      await launch(facebookAuthUrl);
    } catch (e) {
      throw 'Could not launch $facebookAuthUrl';
    }
  }

  String extractTokenFromJson(String jsonResponse) {
    final Map<String, dynamic> data = json.decode(jsonResponse);
    final String? token = data['token'];

    if (token != null) {
      _token = token;
      return token;
    } else {
      throw 'Token not found in JSON response';
    }
  }

  Future<void> handleAuthRedirect(Uri redirectedUri) async {
    final token = await getTokenFromRedirect(redirectedUri);

    if (token != null) {
      await _saveToken(token);
      _token = token;
    } else {
      throw 'Token not found in the redirected URL';
    }
  }

  Future<String?> getTokenFromRedirect(Uri redirectedUri) async {
    // Lógica para extrair o token da URL de redirecionamento
    // ...

    return 'example_token'; // Substitua isso pela lógica real para obter o token
  }

  Future<void> _saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<void> _loadToken() async {
    _token = await storage.read(key: 'auth_token');
  }

  String? _getCurrentUser() {
    return user;
  }

  Future<UserDetails?> getCurrentUserDetails() async {
    await _loadToken(); // Carrega o token ao obter detalhes do usuário

    if (_token != null) {
      try {
        final response = await http.get(
            Uri.parse('http://127.0.0.1:8000/api/usuariosS'),
            headers: {'Authorization': 'Bearer $_token'});

        if (response.statusCode == 200) {
          final Map<String, dynamic> userData = json.decode(response.body);
          return UserDetails.fromMap(userData);
        } else {
          throw 'Failed to get user details: ${response.statusCode}';
        }
      } catch (e) {
        throw 'Error getting user details: $e';
      }
    } else {
      return null;
    }
  }
}

class UserDetails {
  final String name;
  final String email;

  UserDetails({
    required this.name,
    required this.email,
  });

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
