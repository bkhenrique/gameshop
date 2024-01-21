import 'package:flutter/material.dart';
import 'package:game_shop/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/app/routes.dart';
import 'package:game_shop/screens/auth/registerNewScreen.dart';

class LoginRegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginRegisterScreen({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    // Aqui você pode adicionar a lógica de login
    print('Login com email e senha');
  }

  Future<void> _loginWithSocial(BuildContext context, String provider) async {
    print('Login com $provider');
    // Implemente a lógica de login social
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Adiciona o SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Color(0xFFF58524),
                        Color(0XFFF92B7F),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 31, 3, 3),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => _login(context),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () => _loginWithSocial(context, 'google'),
                  icon: Image.asset('assets/google_icon.png',
                      height: 24, width: 24), // Ícone do Google
                  label: const Text('Login com Google'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _loginWithSocial(context, 'facebook'),
                  icon: Image.asset('assets/facebook_icon.png',
                      height: 24, width: 24), // Ícone do Facebook
                  label: const Text('Login com Facebook'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, registerNewScreen);
                  },
                  icon: const Icon(Icons.app_registration), // Ícone de registro
                  label: const Text('Registrar com Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
