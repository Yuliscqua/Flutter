import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/films_screen.dart';
import 'screens/planets_screen.dart';
import 'screens/characters_screen.dart';

void main() {
  runApp(const StarWarsApp());
}

class StarWarsApp extends StatelessWidget {
  const StarWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFFFE301),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFE301),
          secondary: Color(0xFFFFFFFF),
          surface: Color(0xFF111111),
          error: Color(0xFFFF3B30),
        ),
        textTheme: GoogleFonts.barlowCondensedTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF000000),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.barlowCondensed(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFFFFFF),
            letterSpacing: 6,
          ),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: const Color(0xFFFFE301),
          unselectedLabelColor: const Color(0xFF666666),
          indicatorColor: const Color(0xFFFFE301),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: const Color(0xFF222222),
          labelStyle: GoogleFonts.barlowCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
          unselectedLabelStyle: GoogleFonts.barlowCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF111111),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFF222222), width: 1),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF222222),
          thickness: 1,
          space: 1,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STAR WARS',
          style: GoogleFonts.barlowCondensed(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 8,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              const Divider(height: 1, color: Color(0xFF222222)),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.movie_outlined, size: 16), text: 'FILMS'),
                  Tab(icon: Icon(Icons.public_outlined, size: 16), text: 'PLANÈTES'),
                  Tab(icon: Icon(Icons.person_outline, size: 16), text: 'PERSONNAGES'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FilmsScreen(),
          PlanetsScreen(),
          CharactersScreen(),
        ],
      ),
    );
  }
}