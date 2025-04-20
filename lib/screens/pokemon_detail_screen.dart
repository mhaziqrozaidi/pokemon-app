import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getTypeColor(pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pokemon Image
            Container(
              height: 200,
              color: _getTypeColor(pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal').withOpacity(0.3),
              child: Hero(
                tag: 'pokemon-${pokemon.id}',
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            
            // Pokemon Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pokemon ID and Types
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: pokemon.types
                            .map((type) => Chip(
                                  backgroundColor: _getTypeColor(type),
                                  label: Text(
                                    type.toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Physical Attributes
                  _buildSectionTitle('Physical Attributes'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAttributeCard('Height', '${pokemon.height / 10} m'),
                      _buildAttributeCard('Weight', '${pokemon.weight / 10} kg'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Abilities
                  _buildSectionTitle('Abilities'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pokemon.abilities
                        .map((ability) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                ability.replaceAll('-', ' '),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats
                  _buildSectionTitle('Base Stats'),
                  const SizedBox(height: 16),
                  ...pokemon.stats.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatStatName(entry.key),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  entry.value.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: entry.value / 255,
                                    color: _getStatColor(entry.value),
                                    backgroundColor: Colors.grey.shade200,
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAttributeCard(String label, String value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatName(String stat) {
    // Format stat names for better readability
    switch (stat) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Attack';
      case 'special-defense':
        return 'Sp. Defense';
      case 'speed':
        return 'Speed';
      default:
        return stat.split('-').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  Color _getStatColor(int value) {
    if (value < 50) return Colors.red;
    if (value < 90) return Colors.orange;
    if (value < 120) return Colors.yellow.shade700;
    return Colors.green;
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.grey.shade500;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow.shade700;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.orange.shade800;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.indigo.shade200;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.brown.shade300;
      case 'ghost':
        return Colors.indigo;
      case 'dragon':
        return Colors.indigo.shade700;
      case 'dark':
        return Colors.grey.shade800;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pink.shade200;
      default:
        return Colors.grey;
    }
  }
}