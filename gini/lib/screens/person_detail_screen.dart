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
  Person? _person;
  List<Film> _films = [];
  List<Species> _species = [];
  List<Vehicle> _vehicles = [];
  List<Starship> _starships = [];
  Planet? _homeworld;

  // Loading states
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

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
    setState(() => _isLoading = true);
    try {
      _homeworld =
          await _swapiService.fetchPlanetByUrl(widget.person.homeworld);
    } catch (e) {
      print('Error loading homeworld: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFilms() async {
    if (widget.person.films.isEmpty) return;
    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSpecies() async {
    if (widget.person.species.isEmpty) return;
    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadVehicles() async {
    if (widget.person.vehicles.isEmpty) return;
    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStarships() async {
    if (widget.person.starships.isEmpty) return;
    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
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

          // Character's main information
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
    if (_isLoading && _films.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_films.isEmpty) {
      return const Center(child: Text('No films available'));
    }

    return _buildList(_films.map((film) => film.title).toList());
  }

  Widget _buildSpeciesTab() {
    if (_isLoading && _species.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_species.isEmpty) {
      return const Center(child: Text('No species available'));
    }

    return _buildList(_species.map((species) => species.name).toList());
  }

  Widget _buildVehiclesTab() {
    if (_isLoading && _vehicles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vehicles.isEmpty) {
      return const Center(child: Text('No vehicles available'));
    }

    return _buildList(_vehicles.map((vehicle) => vehicle.name).toList());
  }

  Widget _buildStarshipsTab() {
    if (_isLoading && _starships.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_starships.isEmpty) {
      return const Center(child: Text('No starships available'));
    }

    return _buildList(_starships.map((starship) => starship.name).toList());
  }

  Widget _buildHomeworldTab() {
    if (_isLoading && _homeworld == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_homeworld == null) {
      return const Center(child: Text('Planet information not available'));
    }

    return _buildList([_homeworld?.name ?? 'Unknown']);
  }

  Widget _buildList(List<String> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
                  item,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
