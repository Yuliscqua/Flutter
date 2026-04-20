class Planet {
  final String name;
  final String climate;
  final String terrain;
  final String population;
  final String diameter;
  final String gravity;
  final String orbitalPeriod;
  final String rotationPeriod;

  const Planet({
    required this.name,
    required this.climate,
    required this.terrain,
    required this.population,
    required this.diameter,
    required this.gravity,
    required this.orbitalPeriod,
    required this.rotationPeriod,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] as Map<String, dynamic>? ?? json;
    return Planet(
      name: props['name'] ?? 'Inconnue',
      climate: props['climate'] ?? 'unknown',
      terrain: props['terrain'] ?? 'unknown',
      population: props['population'] ?? 'unknown',
      diameter: props['diameter'] ?? 'unknown',
      gravity: props['gravity'] ?? 'unknown',
      orbitalPeriod: props['orbital_period'] ?? 'unknown',
      rotationPeriod: props['rotation_period'] ?? 'unknown',
    );
  }

  String get formattedPopulation {
    final n = int.tryParse(population);
    if (n == null) return population;
    if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)} Milliards';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)} Millions';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)} Milliers';
    return n.toString();
  }
}