import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class PokemonProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchPokemonList() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPokemonList = await _apiService.getPokemonList(_offset, _limit);
      if (newPokemonList.isEmpty) {
        _hasMore = false;
      } else {
        _pokemonList.addAll(newPokemonList);
        _offset += _limit;
      }
    } catch (e) {
      debugPrint('Error fetching Pokemon: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Pokemon?> getPokemonDetails(int id) async {
    try {
      return await _apiService.getPokemonDetails(id);
    } catch (e) {
      debugPrint('Error fetching Pokemon details: $e');
      return null;
    }
  }
}