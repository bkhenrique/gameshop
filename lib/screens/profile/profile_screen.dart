import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/main.dart';
import 'package:game_shop/app/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    // Dados fictícios do perfil
    ProfileData profileData = ProfileData(
      name: 'John Doe',
      email: 'john.doe@example.com',
      userType: UserType.buyer,
      visibleData: ['Name', 'E-mail', 'Type'],
      verified: true,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profileData.name}'),
            Text('E-mail: ${profileData.email}'),
            Text('User Type: ${profileData.userType}'),
            Text('Visible Data: ${profileData.visibleData.join(', ')}'),
            Text('Verified: ${profileData.verified ? 'Yes' : 'No'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a área do vendedor
                Navigator.pushNamed(context, sellerAreaScreen);
              },
              child: Text('Seller Area'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final UserType userType;
  final List<String> visibleData;
  final bool verified;

  ProfileData({
    required this.name,
    required this.email,
    required this.userType,
    required this.visibleData,
    required this.verified,
  });
}

enum UserType {
  buyer,
  seller,
}
