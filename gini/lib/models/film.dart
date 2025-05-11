class Film {
  final String title;
  final int episodeId;
  final String openingCrawl;
  final String director;
  final String producer;
  final String releaseDate;
  final List<String> characters;
  final List<String> planets;
  final List<String> starships;
  final List<String> vehicles;
  final List<String> species;
  final String url;
  final String created;
  final String edited;

  Film({
    required this.title,
    required this.episodeId,
    required this.openingCrawl,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.characters,
    required this.planets,
    required this.starships,
    required this.vehicles,
    required this.species,
    required this.url,
    required this.created,
    required this.edited,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['title'] ?? '',
      episodeId: json['episode_id'] ?? 0,
      openingCrawl: json['opening_crawl'] ?? '',
      director: json['director'] ?? '',
      producer: json['producer'] ?? '',
      releaseDate: json['release_date'] ?? '',
      characters: List<String>.from(json['characters'] ?? []),
      planets: List<String>.from(json['planets'] ?? []),
      starships: List<String>.from(json['starships'] ?? []),
      vehicles: List<String>.from(json['vehicles'] ?? []),
      species: List<String>.from(json['species'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
      edited: json['edited'] ?? '',
    );
  }
}
