import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<String> _selectedTypes;
  late RangeValues _heightRange;
  late RangeValues _weightRange;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    _selectedTypes = Set.from(provider.selectedTypes);

    // Initialize with default range values or provider values if available
    _heightRange = const RangeValues(0, 100);
    _weightRange = const RangeValues(0, 1000);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    final availableTypes = provider.availableTypes.toList()..sort();

    return AlertDialog(
      title: const Text('Filter Pokémon'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Types',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildTypeFilter(availableTypes),
            
            const SizedBox(height: 16),
            const Text(
              'Height (meters)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            RangeSlider(
              values: _heightRange,
              min: 0,
              max: 100,
              divisions: 100,
              labels: RangeLabels(
                _heightRange.start.toStringAsFixed(1),
                _heightRange.end.toStringAsFixed(1),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _heightRange = values;
                });
              },
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Weight (kg)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            RangeSlider(
              values: _weightRange,
              min: 0,
              max: 1000,
              divisions: 100,
              labels: RangeLabels(
                _weightRange.start.toStringAsFixed(1),
                _weightRange.end.toStringAsFixed(1),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _weightRange = values;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Clear filters
            provider.clearFilters();
            Navigator.pop(context);
          },
          child: const Text('CLEAR ALL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            // Apply filters
            for (var type in availableTypes) {
              if (_selectedTypes.contains(type) && !provider.selectedTypes.contains(type)) {
                provider.toggleTypeFilter(type);
              } else if (!_selectedTypes.contains(type) && provider.selectedTypes.contains(type)) {
                provider.toggleTypeFilter(type);
              }
            }
            
            provider.setHeightRange(_heightRange.start, _heightRange.end);
            provider.setWeightRange(_weightRange.start, _weightRange.end);
            
            Navigator.pop(context);
          },
          child: const Text('APPLY'),
        ),
      ],
    );
  }

  Widget _buildTypeFilter(List<String> types) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = _selectedTypes.contains(type);
        return FilterChip(
          label: Text(
            type[0].toUpperCase() + type.substring(1),
            style: TextStyle(
              color: isSelected ? Colors.white : null,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTypes.add(type);
              } else {
                _selectedTypes.remove(type);
              }
            });
          },
          backgroundColor: Colors.grey.shade200,
          selectedColor: _getTypeColor(type),
          checkmarkColor: Colors.white,
        );
      }).toList(),
    );
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