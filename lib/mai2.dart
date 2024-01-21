import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Mantenha apenas esta linha
import 'package:game_shop/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_shop/app/routes.dart';
import 'package:game_shop/screens/home/home_screen.dart';
import 'package:game_shop/screens/home/ad_details_screen.dart';
import 'package:game_shop/screens/seller/seller_area_screen.dart';
import 'package:game_shop/screens/settings/settings_screen.dart';
import 'package:game_shop/screens/reviews/reviews_screen.dart';
import 'package:game_shop/screens/favoritos/favoritos_screen.dart';
import 'package:game_shop/screens/profile/profile_screen.dart';
import 'package:game_shop/screens/auth/login_register_screen.dart';
import 'package:game_shop/services/auth_service.dart'; // Importe o serviço de autenticação

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
        Provider<AuthService>(create: (context) => AuthService()),
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
  ];

  @override
  State<GameShop> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GameShop> {
  int _currentIndex = 0;
  late AppState appState; // Adicione esta linha
  late AuthService authService; // Adicione esta linha

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    // Ajuste esta lógica para redirecionar com base na autenticação
    if (authService.currentUser == null) {
      _currentIndex = 3; // Defina o índice de login/register
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ),
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
      home: _buildHome(),
      routes: {
        adDetailsScreen: (context) => const AdDetailsScreen(),
        sellerAreaScreen: (context) => const SellerAreaScreen(),
        settingsScreen: (context) => const SettingsScreen(),
        reviewsScreen: (context) => const ReviewsScreen(),
        favoritosScreen: (context) => const FavoritosScreen(),
        profileScreen: (context) => const ProfileScreen(),
        loginRegisterScreen: (context) => LoginRegisterScreen(),
      },
    );
  }

  Widget _buildHome() {
    if (authService.currentUser == null) {
      return LoginRegisterScreen();
    } else {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: _currentIndex,
          onTap: (opccao) {
            setState(() {
              _currentIndex = opccao;
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: appState.isDarkMode
              ? const Color.fromARGB(255, 243, 5, 155)
              : Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.pageTitles[_currentIndex],
            style: TextStyle(
              color: appState.isDarkMode
                  ? const Color.fromARGB(255, 4, 36, 105)
                  : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
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
            // Página Home
            HomeScreen(),
            FavoritosScreen(),
            ProfileScreen(),
          ],
        ),
      );
    }
  }
}
