// login_register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/services/auth_service.dart';

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await authService.loginWithGoogle();
                // Após o login, você pode navegar para a próxima tela ou realizar outras ações
                // Por exemplo, redirecione para a tela de perfil após o login
                await authService.handleAuthRedirect(Uri.parse('homeScreen'));
                Navigator.pushNamed(context, '/homeScreen');
              },
              child: const Text('Login com Google'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authService.loginWithFacebook();
                // Após o login, você pode navegar para a próxima tela ou realizar outras ações
              },
              child: const Text('Login com Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
