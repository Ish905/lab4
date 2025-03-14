import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static Future<List<dynamic>> fetchPokemonCards() async {
    final url = 'https://api.pokemontcg.io/v2/cards';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Extract Pokémon card data
    } else {
      throw Exception('Failed to load Pokémon cards');
    }
  }
}