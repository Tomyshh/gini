class Person {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String homeworld;
  final List<String> films;
  final List<String> species;
  final List<String> vehicles;
  final List<String> starships;
  final String url;
  final String created;
  final String edited;
  bool isFavorite;

  Person({
    required this.name,
    required this.height,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.homeworld,
    required this.films,
    required this.species,
    required this.vehicles,
    required this.starships,
    required this.url,
    required this.created,
    required this.edited,
    required this.mass,
    this.isFavorite = false,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] ?? '',
      height: json['height'] ?? '',
      mass: json['mass'] ?? '',
      hairColor: json['hair_color'] ?? '',
      skinColor: json['skin_color'] ?? '',
      eyeColor: json['eye_color'] ?? '',
      birthYear: json['birth_year'] ?? '',
      gender: json['gender'] ?? '',
      homeworld: json['homeworld'] ?? '',
      films: List<String>.from(json['films'] ?? []),
      species: List<String>.from(json['species'] ?? []),
      vehicles: List<String>.from(json['vehicles'] ?? []),
      starships: List<String>.from(json['starships'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
      edited: json['edited'] ?? '',
    );
  }

  int get heightValue {
    if (height == 'unknown' || height.isEmpty) {
      return 0;
    }
    return int.tryParse(height) ?? 0;
  }
}
