// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> loginWithGoogle() async {
    try {
      // Configurar a autenticação com o Google usando Firebase
      // Certifique-se de configurar corretamente as credenciais do OAuth no Console do Firebase
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithPopup(googleProvider);

      // Após o login bem-sucedido, o usuário estará disponível em userCredential.user
      print(
          'Login com Google bem-sucedido. Usuário: ${userCredential.user?.displayName}');
    } catch (e) {
      print('Erro ao fazer login com Google: $e');
      rethrow; // Reenvia a exceção para ser tratada no local de chamada, se necessário
    }
  }

  Future<void> loginWithFacebook() async {
    // Implemente a autenticação com o Facebook usando Firebase, se necessário
    // Certifique-se de configurar corretamente as credenciais no Console do Firebase
    print('Login com Facebook não implementado');
  }
}
