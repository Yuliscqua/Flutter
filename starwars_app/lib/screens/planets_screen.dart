import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/planet.dart';
import '../services/swapi_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({super.key});

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen> {
  late Future<List<Planet>> _planetsFuture;

  @override
  void initState() {
    super.initState();
    _planetsFuture = SwapiService().fetchPlanets(count: 10);
  }

  void _reload() => setState(() {
        _planetsFuture = SwapiService().fetchPlanets(count: 10);
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Planet>>(
      future: _planetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SWLoadingWidget(message: 'SCAN DES PLANÈTES');
        }
        if (snapshot.hasError) {
          return SWErrorWidget(message: snapshot.error.toString(), onRetry: _reload);
        }
        final planets = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 1),
          itemCount: planets.length,
          itemBuilder: (ctx, i) => _PlanetCard(planet: planets[i]),
        );
      },
    );
  }
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({required this.planet});
  final Planet planet;

  Color get _accentColor {
    final t = planet.terrain.toLowerCase();
    final c = planet.climate.toLowerCase();
    if (t.contains('ocean') || t.contains('water')) return const Color(0xFF0277BD);
    if (t.contains('desert') || c.contains('arid')) return const Color(0xFFBF360C);
    if (t.contains('forest') || t.contains('jungle')) return const Color(0xFF1B5E20);
    if (t.contains('ice') || c.contains('frozen')) return const Color(0xFF006064);
    if (t.contains('mountain')) return const Color(0xFF4A148C);
    if (t.contains('city') || t.contains('urban')) return const Color(0xFF263238);
    return const Color(0xFF37474F);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau couleur plat — simule une image header
              Container(
                height: 72,
                color: accent,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Overlay dégradé noir vers la droite
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    // Nom en bas à gauche
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          planet.name.toUpperCase(),
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              const Shadow(
                                color: Colors.black,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tag terrain en haut à droite
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: Text(
                            planet.terrain.split(',').first.trim().toUpperCase(),
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 10,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tableau de données style Databank
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    _DataRow('CLIMAT', planet.climate),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('POPULATION', planet.formattedPopulation),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('DIAMÈTRE', '${planet.diameter} km'),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('GRAVITÉ', planet.gravity),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('PÉRIODE ORBITALE', '${planet.orbitalPeriod} jours'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFF333333)),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: GoogleFonts.barlowCondensed(
                fontSize: 10,
                color: const Color(0xFF666666),
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.barlowCondensed(
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}