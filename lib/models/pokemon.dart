class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<String> abilities;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract types
    List<String> typesList = [];
    for (var type in json['types']) {
      typesList.add(type['type']['name']);
    }

    // Extract abilities
    List<String> abilitiesList = [];
    for (var ability in json['abilities']) {
      abilitiesList.add(ability['ability']['name']);
    }

    // Extract stats
    Map<String, int> statsMap = {};
    for (var stat in json['stats']) {
      statsMap[stat['stat']['name']] = stat['base_stat'];
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? 
                json['sprites']['front_default'],
      types: typesList,
      height: json['height'],
      weight: json['weight'],
      abilities: abilitiesList,
      stats: statsMap,
    );
  }
}