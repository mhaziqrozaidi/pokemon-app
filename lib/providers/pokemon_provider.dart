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
  
  // Filter states
  Set<String> _selectedTypes = {};
  double _minHeight = 0;
  double _maxHeight = 100;
  double _minWeight = 0;
  double _maxWeight = 1000;
  bool _filtersActive = false;

  List<Pokemon> get pokemonList {
    if (_searchQuery.isEmpty && !_filtersActive) {
      return _pokemonList;
    } else {
      return _filteredPokemonList;
    }
  }
  
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore && _searchQuery.isEmpty && !_filtersActive;
  String get searchQuery => _searchQuery;
  Set<String> get selectedTypes => _selectedTypes;
  bool get filtersActive => _filtersActive;
  
  // Get all unique types from the loaded Pokémon
  Set<String> get availableTypes {
    Set<String> types = {};
    for (var pokemon in _pokemonList) {
      types.addAll(pokemon.types);
    }
    return types;
  }

  Future<void> fetchPokemonList() async {
    if (_isLoading || !_hasMore || _searchQuery.isNotEmpty || _filtersActive) return;

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
    _applyFilters();
  }

  void toggleTypeFilter(String type) {
    if (_selectedTypes.contains(type)) {
      _selectedTypes.remove(type);
    } else {
      _selectedTypes.add(type);
    }
    _filtersActive = _selectedTypes.isNotEmpty || 
                     _minHeight > 0 || 
                     _maxHeight < 100 || 
                     _minWeight > 0 || 
                     _maxWeight < 1000;
    _applyFilters();
  }

  void setHeightRange(double min, double max) {
    _minHeight = min;
    _maxHeight = max;
    _filtersActive = _selectedTypes.isNotEmpty || 
                     _minHeight > 0 || 
                     _maxHeight < 100 || 
                     _minWeight > 0 || 
                     _maxWeight < 1000;
    _applyFilters();
  }

  void setWeightRange(double min, double max) {
    _minWeight = min;
    _maxWeight = max;
    _filtersActive = _selectedTypes.isNotEmpty || 
                     _minHeight > 0 || 
                     _maxHeight < 100 || 
                     _minWeight > 0 || 
                     _maxWeight < 1000;
    _applyFilters();
  }

  void clearFilters() {
    _selectedTypes = {};
    _minHeight = 0;
    _maxHeight = 100;
    _minWeight = 0;
    _maxWeight = 1000;
    _filtersActive = false;
    _applyFilters();
  }

  void _applyFilters() {
    // Start with all Pokémon
    List<Pokemon> filteredList = List.from(_pokemonList);
    
    // Apply search if active
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((pokemon) => 
              pokemon.name.toLowerCase().contains(_searchQuery) ||
              pokemon.id.toString() == _searchQuery)
          .toList();
    }
    
    // Apply type filters if any are selected
    if (_selectedTypes.isNotEmpty) {
      filteredList = filteredList
          .where((pokemon) => 
              pokemon.types.any((type) => _selectedTypes.contains(type)))
          .toList();
    }
    
    // Apply height filter
    filteredList = filteredList
        .where((pokemon) {
          final heightInMeters = pokemon.height / 10;
          return heightInMeters >= _minHeight && heightInMeters <= _maxHeight;
        })
        .toList();
    
    // Apply weight filter
    filteredList = filteredList
        .where((pokemon) {
          final weightInKg = pokemon.weight / 10;
          return weightInKg >= _minWeight && weightInKg <= _maxWeight;
        })
        .toList();
    
    _filteredPokemonList = filteredList;
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