import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/person.dart';
import '../models/film.dart';
import '../models/species.dart';
import '../models/vehicle.dart';
import '../models/starship.dart';
import '../models/planet.dart';
import '../services/swapi_service.dart';
import '../constants/theme.dart';
import '../constants/text_styles.dart';

class PersonDetailScreen extends StatefulWidget {
  final Person person;

  const PersonDetailScreen({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final SwapiService _swapiService = SwapiService();

  // Data to be loaded
  Planet? _homeworld;
  final List<Film> _films = [];
  final List<Species> _species = [];
  final List<Vehicle> _vehicles = [];
  final List<Starship> _starships = [];

  // Loading states
  bool _loadingHomeworld = false;
  bool _loadingFilms = false;
  bool _loadingSpecies = false;
  bool _loadingVehicles = false;
  bool _loadingStarships = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    _loadHomeworld();
    _loadFilms();
    _loadSpecies();
    _loadVehicles();
    _loadStarships();
  }

  Future<void> _loadHomeworld() async {
    if (widget.person.homeworld.isEmpty ||
        widget.person.homeworld == 'unknown') {
      return;
    }
    setState(() => _loadingHomeworld = true);
    try {
      _homeworld =
          await _swapiService.fetchPlanetByUrl(widget.person.homeworld);
    } catch (e) {
      print('Error loading homeworld: $e');
    } finally {
      if (mounted) setState(() => _loadingHomeworld = false);
    }
  }

  Future<void> _loadFilms() async {
    if (widget.person.films.isEmpty) return;
    setState(() => _loadingFilms = true);
    try {
      for (final url in widget.person.films) {
        final film = await _swapiService.fetchFilmByUrl(url);
        if (film != null && mounted) {
          setState(() => _films.add(film));
        }
      }
    } catch (e) {
      print('Error loading films: $e');
    } finally {
      if (mounted) setState(() => _loadingFilms = false);
    }
  }

  Future<void> _loadSpecies() async {
    if (widget.person.species.isEmpty) return;
    setState(() => _loadingSpecies = true);
    try {
      for (final url in widget.person.species) {
        final species = await _swapiService.fetchSpeciesByUrl(url);
        if (species != null && mounted) {
          setState(() => _species.add(species));
        }
      }
    } catch (e) {
      print('Error loading species: $e');
    } finally {
      if (mounted) setState(() => _loadingSpecies = false);
    }
  }

  Future<void> _loadVehicles() async {
    if (widget.person.vehicles.isEmpty) return;
    setState(() => _loadingVehicles = true);
    try {
      for (final url in widget.person.vehicles) {
        final vehicle = await _swapiService.fetchVehicleByUrl(url);
        if (vehicle != null && mounted) {
          setState(() => _vehicles.add(vehicle));
        }
      }
    } catch (e) {
      print('Error loading vehicles: $e');
    } finally {
      if (mounted) setState(() => _loadingVehicles = false);
    }
  }

  Future<void> _loadStarships() async {
    if (widget.person.starships.isEmpty) return;
    setState(() => _loadingStarships = true);
    try {
      for (final url in widget.person.starships) {
        final starship = await _swapiService.fetchStarshipByUrl(url);
        if (starship != null && mounted) {
          setState(() => _starships.add(starship));
        }
      }
    } catch (e) {
      print('Error loading starships: $e');
    } finally {
      if (mounted) setState(() => _loadingStarships = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? AppTheme.tatooineGold : AppTheme.imperialBlue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.person.name,
          style: AppTextStyles.titleMedium.copyWith(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [AppTheme.tatooineGold.withOpacity(0.7), AppTheme.darkSide]
                  : [AppTheme.imperialBlue.withOpacity(0.7), Colors.white],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // TabBar for details
          TabBar(
            controller: _tabController,
            labelColor:
                isDarkMode ? AppTheme.tatooineGold : AppTheme.imperialBlue,
            unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.black54,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(icon: Icon(Icons.movie), text: 'Films'),
              Tab(icon: Icon(Icons.category), text: 'Species'),
              Tab(icon: Icon(Icons.directions_car), text: 'Vehicles'),
              Tab(icon: Icon(Icons.rocket), text: 'Starships'),
              Tab(icon: Icon(Icons.public), text: 'Planet'),
            ],
          ),

          // Informations principales du personnage
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Main Characteristics',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Height', '${widget.person.height} cm'),
                    _buildInfoRow('Weight', '${widget.person.mass} kg'),
                    _buildInfoRow('Hair color', widget.person.hairColor),
                    _buildInfoRow('Skin color', widget.person.skinColor),
                    _buildInfoRow('Eye color', widget.person.eyeColor),
                    _buildInfoRow('Birth year', widget.person.birthYear),
                    _buildInfoRow('Gender', widget.person.gender),
                    _buildInfoRow(
                        'Homeworld', _homeworld?.name ?? 'Loading...'),
                  ],
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Films
                _buildFilmsTab(),

                // Species
                _buildSpeciesTab(),

                // Vehicles
                _buildVehiclesTab(),

                // Starships
                _buildStarshipsTab(),

                // Homeworld
                _buildHomeworldTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value == 'unknown' || value.isEmpty ? 'Not available' : value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmsTab() {
    if (_loadingFilms && _films.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_films.isEmpty) {
      return const Center(child: Text('No films available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _films.length,
      itemBuilder: (context, index) {
        final film = _films[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              film.title,
              style:
                  AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Episode ${film.episodeId} • ${film.releaseDate}'),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Text(
                film.openingCrawl.replaceAll(r'\r\n', '\n'),
                style: AppTextStyles.bodyMedium
                    .copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Director', film.director),
              _buildInfoRow('Producer', film.producer),
              _buildInfoRow('Release date', film.releaseDate),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeciesTab() {
    if (_loadingSpecies && _species.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_species.isEmpty) {
      return const Center(child: Text('No species available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _species.length,
      itemBuilder: (context, index) {
        final species = _species[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                _buildInfoRow('Classification', species.classification),
                _buildInfoRow('Designation', species.designation),
                _buildInfoRow('Average height', '${species.averageHeight} cm'),
                _buildInfoRow('Skin colors', species.skinColors),
                _buildInfoRow('Hair colors', species.hairColors),
                _buildInfoRow('Eye colors', species.eyeColors),
                _buildInfoRow(
                    'Average lifespan', '${species.averageLifespan} years'),
                _buildInfoRow('Language', species.language),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehiclesTab() {
    if (_loadingVehicles && _vehicles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vehicles.isEmpty) {
      return const Center(child: Text('No vehicles available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  vehicle.model,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Divider(),
                _buildInfoRow('Manufacturer', vehicle.manufacturer),
                _buildInfoRow('Cost', '${vehicle.costInCredits} credits'),
                _buildInfoRow('Length', '${vehicle.length} m'),
                _buildInfoRow('Max speed', vehicle.maxAtmospheringSpeed),
                _buildInfoRow('Crew', vehicle.crew),
                _buildInfoRow('Passengers', vehicle.passengers),
                _buildInfoRow('Cargo capacity', vehicle.cargoCapacity),
                _buildInfoRow('Consumables', vehicle.consumables),
                _buildInfoRow('Class', vehicle.vehicleClass),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStarshipsTab() {
    if (_loadingStarships && _starships.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_starships.isEmpty) {
      return const Center(child: Text('No starships available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _starships.length,
      itemBuilder: (context, index) {
        final starship = _starships[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  starship.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  starship.model,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Divider(),
                _buildInfoRow('Manufacturer', starship.manufacturer),
                _buildInfoRow('Cost', '${starship.costInCredits} credits'),
                _buildInfoRow('Length', '${starship.length} m'),
                _buildInfoRow('Max speed', starship.maxAtmospheringSpeed),
                _buildInfoRow('Crew', starship.crew),
                _buildInfoRow('Passengers', starship.passengers),
                _buildInfoRow('Cargo capacity', starship.cargoCapacity),
                _buildInfoRow('Consumables', starship.consumables),
                _buildInfoRow('Hyperdrive', starship.hyperdriveRating),
                _buildInfoRow('MGLT', starship.mglt),
                _buildInfoRow('Class', starship.starshipClass),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeworldTab() {
    if (_loadingHomeworld && _homeworld == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_homeworld == null) {
      return const Center(child: Text('Planet information not available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _homeworld!.name,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              _buildInfoRow(
                  'Rotation period', '${_homeworld!.rotationPeriod} hours'),
              _buildInfoRow(
                  'Orbital period', '${_homeworld!.orbitalPeriod} days'),
              _buildInfoRow('Diameter', '${_homeworld!.diameter} km'),
              _buildInfoRow('Climate', _homeworld!.climate),
              _buildInfoRow('Gravity', _homeworld!.gravity),
              _buildInfoRow('Terrain', _homeworld!.terrain),
              _buildInfoRow('Surface water', '${_homeworld!.surfaceWater}%'),
              _buildInfoRow('Population', _homeworld!.population),
              const SizedBox(height: 12),
              Text(
                'Films featuring this planet',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _homeworld!.films.isEmpty
                  ? const Text('No known films')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _homeworld!.films
                          .map((url) => FutureBuilder<Film?>(
                                future: _swapiService.fetchFilmByUrl(url),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: LinearProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text('• ${snapshot.data!.title}'),
                                  );
                                },
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 12),
              Text(
                'Known residents',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _homeworld!.residents.isEmpty
                  ? const Text('No known residents')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _homeworld!.residents
                          .map((url) => FutureBuilder<Person?>(
                                future: _swapiService.fetchPersonByUrl(url),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: LinearProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text('• ${snapshot.data!.name}'),
                                  );
                                },
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
