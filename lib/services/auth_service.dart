// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:game_shop/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  AuthService() {
    _loadToken();
  }

  String? get token => _token;

  bool get isUserLoggedIn => _token != null;

  Future<void> setUser(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
    notifyListeners(); // Notificar os ouvintes sobre a mudança
    print('dentro do auth: ${token}');

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    final googleAuthUrl = Uri.parse(ApiConfig.googleAuthRedirect);

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
    final facebookAuthUrl =
        Uri.parse('${ApiConfig.apiEndpoint}/auth/facebook/redirect');

    print("url facebook precionada");
    try {
      await launchUrl(facebookAuthUrl);
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

  Future<String?> getTokenFromRedirect(Uri redirectedUri) async {
    // Lógica para extrair o token da URL de redirecionamento
    // ...

    return token; // Substitua isso pela lógica real para obter o token
  }

  Future<UserDetails?> getCurrentUserDetails() async {
    await _loadToken();
    if (_token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.apiEndpoint}/usuarios'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return UserDetails.fromMap(userData);
      } else {
        throw 'Failed to get user details: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error getting user details: $e';
    }
  }

  // Método auxiliar para carregar o token do armazenamento seguro
  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'auth_token');
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
