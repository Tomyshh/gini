class Planet {
  final String name;
  final String rotationPeriod;
  final String orbitalPeriod;
  final String diameter;
  final String climate;
  final String gravity;
  final String terrain;
  final String surfaceWater;
  final String population;
  final List<String> residents;
  final List<String> films;
  final String url;
  final String created;
  final String edited;

  Planet({
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.diameter,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.surfaceWater,
    required this.population,
    required this.residents,
    required this.films,
    required this.url,
    required this.created,
    required this.edited,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'] ?? '',
      rotationPeriod: json['rotation_period'] ?? '',
      orbitalPeriod: json['orbital_period'] ?? '',
      diameter: json['diameter'] ?? '',
      climate: json['climate'] ?? '',
      gravity: json['gravity'] ?? '',
      terrain: json['terrain'] ?? '',
      surfaceWater: json['surface_water'] ?? '',
      population: json['population'] ?? '',
      residents: List<String>.from(json['residents'] ?? []),
      films: List<String>.from(json['films'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
      edited: json['edited'] ?? '',
    );
  }
}
