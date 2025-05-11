import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/people_provider.dart';
import 'screens/home_screen.dart';
import 'constants/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force dark mode for better Star Wars experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Allow both orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
      ],
      child: MaterialApp(
        title: 'Star Wars Characters',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const StarWarsApp(),
      ),
    );
  }
}

class StarWarsApp extends StatefulWidget {
  const StarWarsApp({super.key});

  @override
  State<StarWarsApp> createState() => _StarWarsAppState();
}

class _StarWarsAppState extends State<StarWarsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PeopleProvider>(context, listen: false).fetchPeople();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data if app is resumed after being paused
      final provider = Provider.of<PeopleProvider>(context, listen: false);
      if (provider.people.isEmpty) {
        provider.fetchPeople();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
