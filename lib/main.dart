// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:game_shop/screens/auth/registerNewScreen.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_shop/screens/home/home_screen.dart';
import 'package:game_shop/screens/favoritos/favoritos_screen.dart';
import 'package:game_shop/screens/profile/profile_screen.dart';
import 'package:game_shop/screens/auth/login_register_screen.dart';
import 'package:game_shop/services/auth_service.dart';

class AppState with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: GameShop(),
    ),
  );
}

class GameShop extends StatefulWidget {
  GameShop({Key? key}) : super(key: key);
  final List<String> pageTitles = [
    'Games Shop',
    'Favoritos',
    'Perfil',
    'Login',
    'Novo Usuário',
  ];
  @override
  State<GameShop> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GameShop> {
  int _currentIndex = 0;
  late AppState appState;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    // Adicione mensagens de depuração
    print("Init State called. Current User: ${authService.token}");

    if (authService.token == null) {
      _currentIndex = 0; // Defina o índice quando não estiver logado
      print("User not logged in. Setting _currentIndex to -1");
    } else {
      _currentIndex = 0; // Defina o índice quando estiver logado
      print("User logged in. Setting _currentIndex to 0");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se o usuário está logado
    final authService = Provider.of<AuthService>(context);
    // Se não estiver logado, mostre apenas a tela de login/registrar
    if (authService.token == null) {
      return MaterialApp(
        routes: {
          '/loginRegisterNewScreen': (context) => LoginRegisterScreen(),
          '/registerNewScreen': (context) => RegisterNewScreen(),
          '/homeScreen': (context) => HomeScreen(),
        },
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Entrar'),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              LoginRegisterScreen(),
            ],
          ),
        ),
      );
    }

    return MaterialApp(
      theme: appState.isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: const Color.fromARGB(255, 121, 30, 137),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 79, 11, 91),
                brightness: Brightness.dark,
              ),
              textTheme: TextTheme(
                displayLarge: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: GoogleFonts.oswald(
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                ),
                bodyMedium: GoogleFonts.merriweather(
                  fontSize: 20,
                ),
                displaySmall: GoogleFonts.pacifico(),
              ), // Configurações de tema para dark mode
            )
          : ThemeData.light().copyWith(
              primaryColor: const Color.fromARGB(255, 39, 101, 176),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 39, 112, 176),
                brightness: Brightness.light,
              ),
              textTheme: TextTheme(
                displayLarge: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: GoogleFonts.oswald(
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                ),
                bodyMedium: const TextStyle(
                  color: Colors.black, // Cor do texto principal
                  fontSize: 20,
                ),
                displaySmall: GoogleFonts.pacifico(),
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  color: appState.isDarkMode ? Colors.white : Colors.black,
                ),
                // no modo claro (light mode)
                hintStyle: appState.isDarkMode
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colors.black),
                fillColor: appState.isDarkMode ? Colors.black : Colors.white,
                errorStyle: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: _currentIndex,
          onTap: (opcao) {
            setState(() {
              _currentIndex = opcao;
            });
          },
        ),
        appBar: AppBar(
          title: Text(
            widget.pageTitles[_currentIndex],
          ),
          actions: [
            IconButton(
              icon: Icon(
                appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                appState.toggleDarkMode();
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            HomeScreen(),
            FavoritosScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
