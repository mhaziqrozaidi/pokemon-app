import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class PokemonProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  String _searchQuery = '';

  List<Pokemon> get pokemonList => _searchQuery.isEmpty 
                                  ? _pokemonList 
                                  : _filteredPokemonList;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore && _searchQuery.isEmpty;
  String get searchQuery => _searchQuery;

  Future<void> fetchPokemonList() async {
    if (_isLoading || !_hasMore || _searchQuery.isNotEmpty) return;

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

  void searchPokemon(String query) {
    _searchQuery = query.toLowerCase().trim();
    
    if (_searchQuery.isEmpty) {
      _filteredPokemonList = [];
    } else {
      _filteredPokemonList = _pokemonList
          .where((pokemon) => 
              pokemon.name.toLowerCase().contains(_searchQuery) ||
              pokemon.id.toString() == _searchQuery)
          .toList();
    }
    
    notifyListeners();
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