import 'package:flutter/material.dart';
import 'package:game_shop/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/services/api_service.dart';
import 'package:game_shop/main.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterNewScreen extends StatefulWidget {
  RegisterNewScreen({Key? key}) : super(key: key);

  @override
  _RegisterNewScreenState createState() => _RegisterNewScreenState();
}

class _RegisterNewScreenState extends State<RegisterNewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading =
      false; // Variável de estado para o indicador de carregamento
  bool _isWidgetMounted = false;

  bool _isPasswordValid(String password) {
    // Verifica se a senha tem pelo menos 8 caracteres, 2 letras e 1 caractere especial
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  @override
  void initState() {
    super.initState();
    _isWidgetMounted = true;
  }

  @override
  void dispose() {
    _isWidgetMounted = false;
    super.dispose();
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);
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
          print('Token: $token');

          // Atualizar AuthService com o token
          Provider.of<AuthService>(context, listen: false).setUser(token);
          // Redirecionar para a tela principal
          if (_isWidgetMounted) {
            // Agora é seguro usar o BuildContext
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => GameShop()),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          // Exibir alguma mensagem de erro ao usuário
          print('Erro ao registrar: ${response.body}');
          _showErrorDialog(context, 'Erro no registro: ${response.body}');
        }
      } catch (e) {
        // Tratar exceções de rede, etc.
        print('Erro de conexão: $e');
        _showErrorDialog(context, 'Erro de conexão: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Exibir o indicador de carregamento
          : Container(
              padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment(0.0, 1.15),
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: AssetImage("assets/logo.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: Container(
                        height: 56,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.3, 1.0],
                            colors: [
                              Color.fromARGB(0, 245, 134, 36),
                              Color.fromARGB(0, 249, 43, 125),
                            ],
                          ),
                          border: Border.all(
                            width: 4.0,
                            color: const Color.fromARGB(0, 255, 255, 255),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(56),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // autofocus: true,
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "E-mail"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        }
                        // Regex para validar o e-mail
                        String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Senha"),
                      validator: (value) {
                        if (value == null || !_isPasswordValid(value)) {
                          return 'A senha deve ter 8 caracteres, 2 letras e 1 caractere especial';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: "Repetir Senha"),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
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
                            "Cadastrar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 31, 3, 3),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => _register(context),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text(
                          "Cancelar",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
