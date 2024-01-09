import 'package:flutter/material.dart';
import 'package:game_shop/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_shop/app/routes.dart';
import 'package:game_shop/screens/home/home_screen.dart';
import 'package:game_shop/screens/home/ad_details_screen.dart';
import 'package:game_shop/screens/seller/seller_area_screen.dart';
import 'package:game_shop/screens/settings/settings_screen.dart';
import 'package:game_shop/screens/reviews/reviews_screen.dart';

void main() {
  runApp(const GameShop());
}

class GameShop extends StatelessWidget {
  const GameShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // ···
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.normal,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(title: 'Games Shop'),
      routes: {
        homeScreen: (context) => const HomeScreen(),
        adDetailsScreen: (context) => const AdDetailsScreen(),
        sellerAreaScreen: (context) => const SellerAreaScreen(),
        settingsScreen: (context) => const SettingsScreen(),
        reviewsScreen: (context) => const ReviewsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void onTap(String route) {
    Navigator.of(context).pushReplacementNamed(route);
    setState(() {
      _currentIndex = _getSelectedIndex(route);
    });
  }

  void _onTabTapped(int index) {
    // Certifique-se de que _onTabTapped aceita um int
    switch (index) {
      case 0:
        onTap(homeScreen);
        break;
      case 1:
        onTap(sellerAreaScreen);
        break;
      case 2:
        onTap(settingsScreen);
        break;
      case 3:
        onTap(reviewsScreen);
        break;
      default:
        onTap(homeScreen);
    }
  }

  int _getSelectedIndex(String route) {
    switch (route) {
      case homeScreen:
        return 0;
      case sellerAreaScreen:
        return 1;
      case settingsScreen:
        return 2;
      case reviewsScreen:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[
          // Página Home
          HomeScreen(),
          SellerAreaScreen(),
          ReviewsScreen(),
          SettingsScreen(),
          AdDetailsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
