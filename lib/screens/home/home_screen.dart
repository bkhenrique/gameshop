// home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Filtro e Modo de Exibição
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Adicione seu widget de filtro aqui
                ElevatedButton(
                  onPressed: () {
                    // Adicione a lógica do filtro aqui
                  },
                  child: const Text('Filtrar'),
                ),

                // Adicione seu widget de modo de exibição aqui
                ElevatedButton(
                  onPressed: () {
                    // Adicione a lógica do modo de exibição aqui
                  },
                  child: const Text('Modo de Exibição'),
                ),
              ],
            ),
          ),

          // Anúncios Mais Recentes com Paginação
          // Adicione seu widget de anúncios mais recentes com paginação aqui

          // Container com Grid ou Lista de Anúncios
          // Adicione seu widget de grid ou lista de anúncios aqui

          // Container com Vendedores de Maior Reputação
          // Adicione seu widget de vendedores com maior reputação aqui
        ],
      ),
    );
  }
}
