import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemonList(int offset, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        List<Pokemon> pokemonList = [];
        
        // Fetch details for each Pokemon
        for (var pokemon in results) {
          final pokemonUrl = pokemon['url'];
          final detailsResponse = await http.get(Uri.parse(pokemonUrl));
          
          if (detailsResponse.statusCode == 200) {
            final pokemonData = json.decode(detailsResponse.body);
            pokemonList.add(Pokemon.fromJson(pokemonData));
          }
        }
        
        return pokemonList;
      } else {
        throw Exception('Failed to load Pokemon list');
      }
    } catch (e) {
      throw Exception('Error getting Pokemon list: $e');
    }
  }

  Future<Pokemon> getPokemonDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Pokemon.fromJson(data);
      } else {
        throw Exception('Failed to load Pokemon details');
      }
    } catch (e) {
      throw Exception('Error getting Pokemon details: $e');
    }
  }
}