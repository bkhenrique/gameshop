import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_shop/main.dart'; // Substitua pelo caminho real para o seu AppState

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);
  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late List<Anuncio> todosFavoritos;
  late List<Anuncio> favoritos;

  TextEditingController valorMinimoController = TextEditingController();
  TextEditingController valorMaximoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    todosFavoritos = [
      Anuncio(titulo: 'Anúncio 1', preco: 50, favorito: 1),
      Anuncio(titulo: 'Anúncio 2', preco: 30, favorito: 1),
      Anuncio(titulo: 'Anúncio 3', preco: 23, favorito: 1),
      Anuncio(titulo: 'Anúncio 4', preco: 30, favorito: 1),
      Anuncio(titulo: 'Anúncio 5', preco: 320, favorito: 1),
      Anuncio(titulo: 'Anúncio 6', preco: 30, favorito: 1),
      Anuncio(titulo: 'Anúncio 7', preco: 3000, favorito: 1),
      Anuncio(titulo: 'Anúncio 8', preco: 300000, favorito: 1),
      Anuncio(titulo: 'Anúncio 9', preco: 30898, favorito: 1),
      Anuncio(titulo: 'Anúncio 10', preco: 88989, favorito: 1),
      Anuncio(titulo: 'Anúncio 11', preco: 98989, favorito: 1),
      Anuncio(titulo: 'Anúncio 12', preco: 39898, favorito: 1),
      Anuncio(titulo: 'Anúncio 13', preco: 30898, favorito: 1),
      Anuncio(titulo: 'Anúncio 14', preco: 89898, favorito: 1),
      Anuncio(titulo: 'Anúncio 15', preco: 89898, favorito: 1),
      Anuncio(titulo: 'Anúncio 16', preco: 59898, favorito: 1),
      Anuncio(titulo: 'Anúncio 17', preco: 9898, favorito: 1),
      // ... outros anúncios ...
    ];
    favoritos = List.from(todosFavoritos);
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: valorMinimoController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Valor Mínimo'),
                    style: TextStyle(
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: valorMaximoController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Valor Máximo'),
                    style: TextStyle(
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Lógica de filtragem melhorada
                double? valorMinimo =
                    double.tryParse(valorMinimoController.text);
                double? valorMaximo =
                    double.tryParse(valorMaximoController.text);

                setState(() {
                  // Restaure a lista original antes de aplicar o filtro
                  favoritos = List.from(todosFavoritos);

                  // Aplique o filtro se os valores forem válidos
                  if (valorMinimo != null) {
                    favoritos = favoritos
                        .where((anuncio) => anuncio.preco >= valorMinimo)
                        .toList();
                  }
                  if (valorMaximo != null) {
                    favoritos = favoritos
                        .where((anuncio) => anuncio.preco <= valorMaximo)
                        .toList();
                  }
                });
              },
              child: const Text('Aplicar Filtro'),
            ),
            ElevatedButton(
              onPressed: () {
                // Função para limpar o filtro
                _limparFiltro();
              },
              child: const Text('Limpar Filtro'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: favoritos.length,
                itemBuilder: (context, index) {
                  final anuncio = favoritos[index];

                  return ListTile(
                    title: Text(
                        '${anuncio.titulo}, favorito: ${anuncio.favorito}'),
                    subtitle: Text('Preço: \$${anuncio.preco}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para limpar o filtro
  void _limparFiltro() {
    setState(() {
      // Restaure a lista original
      favoritos = List.from(todosFavoritos);

      // Limpe os controladores de texto
      valorMinimoController.clear();
      valorMaximoController.clear();
    });
  }
}

class Anuncio {
  final String titulo;
  final double preco;
  final num favorito;

  Anuncio({required this.titulo, required this.preco, required this.favorito});
}
