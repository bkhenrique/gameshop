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

class AppState with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
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

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

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
        routes: {
          homeScreen: (context) => HomeScreen(),
          adDetailsScreen: (context) => AdDetailsScreen(),
          sellerAreaScreen: (context) => SellerAreaScreen(),
          settingsScreen: (context) => SettingsScreen(),
          reviewsScreen: (context) => ReviewsScreen(),
          favoritosScreen: (context) => FavoritosScreen(),
          profileScreen: (context) => ProfileScreen(),
        },
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBarWidget(
              currentIndex: _currentIndex,
              onTap: (opccao) {
                setState(() {
                  _currentIndex = opccao;
                });
                _currentIndex = opccao;
              }),
          appBar: AppBar(
            backgroundColor: appState.isDarkMode
                ? Color.fromARGB(255, 243, 5, 155)
                : Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              widget.pageTitles[_currentIndex],
              style: TextStyle(
                color: appState.isDarkMode
                    ? Color.fromARGB(255, 4, 36, 105)
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
              ReviewsScreen(),
              SettingsScreen(),
            ],
          ),
        ));
  }
}
