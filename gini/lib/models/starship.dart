class Starship {
  final String name;
  final String model;
  final String manufacturer;
  final String costInCredits;
  final String length;
  final String maxAtmospheringSpeed;
  final String crew;
  final String passengers;
  final String cargoCapacity;
  final String consumables;
  final String hyperdriveRating;
  final String mglt;
  final String starshipClass;
  final List<String> pilots;
  final List<String> films;
  final String url;
  final String created;
  final String edited;

  Starship({
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.costInCredits,
    required this.length,
    required this.maxAtmospheringSpeed,
    required this.crew,
    required this.passengers,
    required this.cargoCapacity,
    required this.consumables,
    required this.hyperdriveRating,
    required this.mglt,
    required this.starshipClass,
    required this.pilots,
    required this.films,
    required this.url,
    required this.created,
    required this.edited,
  });

  factory Starship.fromJson(Map<String, dynamic> json) {
    return Starship(
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      costInCredits: json['cost_in_credits'] ?? '',
      length: json['length'] ?? '',
      maxAtmospheringSpeed: json['max_atmosphering_speed'] ?? '',
      crew: json['crew'] ?? '',
      passengers: json['passengers'] ?? '',
      cargoCapacity: json['cargo_capacity'] ?? '',
      consumables: json['consumables'] ?? '',
      hyperdriveRating: json['hyperdrive_rating'] ?? '',
      mglt: json['MGLT'] ?? '',
      starshipClass: json['starship_class'] ?? '',
      pilots: List<String>.from(json['pilots'] ?? []),
      films: List<String>.from(json['films'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
      edited: json['edited'] ?? '',
    );
  }
}
