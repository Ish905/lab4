import 'package:flutter/material.dart';
import 'pokemon_service.dart';

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon TCG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<dynamic>> pokemonCards;

  @override
  void initState() {
    super.initState();
    pokemonCards = PokemonService.fetchPokemonCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Cards')),
      body: FutureBuilder(
        future: pokemonCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading cards'));
          } else {
            final cards = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(card['images']['small']),
                    title: Text(card['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CardDetailScreen(card['images']['large']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CardDetailScreen extends StatelessWidget {
  final String imageUrl;
  CardDetailScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Details')),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}