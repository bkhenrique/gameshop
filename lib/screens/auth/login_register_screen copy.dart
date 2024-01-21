// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:game_shop/services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:game_shop/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginRegisterScreen extends StatelessWidget {
  LoginRegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _login(BuildContext context, String provider) async {
    print('clicou login');
    final redirectUri =
        Uri.parse('${ApiConfig.apiEndpoint}/auth/$provider/callback');
    final authorizationUrl = '${ApiConfig.apiEndpoint}/auth/$provider/redirect';

    try {
      final result = await FlutterWebAuth.authenticate(
        url: authorizationUrl,
        callbackUrlScheme: 'http', // Alterado para 'http'
      );
      // Restante do código...
    } catch (e) {
      // Trate erros, se necessário
      print('Erro durante a autenticação social: $e');
    }
  }

  Future<void> _register(BuildContext context) async {
    var url = Uri.parse('${ApiConfig.apiEndpoint}/auth/register');
    var response = await http.post(
      url,
      body: {
        'nome': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var token = json.decode(response.body)['token'];
      print('Response body: ${token}');

      // Atualizar AuthService com o token
      Provider.of<AuthService>(context, listen: false).setUser(token);
      navigatorKey.currentState!.pushReplacementNamed('/homeScreen');
    } else {
      print('Erro ao registrar: ${response.body}');
    }
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registro'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nome"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Registrar'),
              onPressed: () {
                _register(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _login(context, 'google'), // Login com Google
              child: const Text('Login com Google'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _login(context, 'facebook'), // Login com Facebook
              child: const Text('Login com Facebook'),
            ),
            ElevatedButton(
              onPressed: () => _showRegisterDialog(context),
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
