import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/character.dart';
import '../services/swapi_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late Future<List<Character>> _charsFuture;

  @override
  void initState() {
    super.initState();
    _charsFuture = SwapiService().fetchCharacters(count: 10);
  }

  void _reload() => setState(() {
        _charsFuture = SwapiService().fetchCharacters(count: 10);
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: _charsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SWLoadingWidget(message: 'IDENTIFICATION DES PERSONNAGES');
        }
        if (snapshot.hasError) {
          return SWErrorWidget(message: snapshot.error.toString(), onRetry: _reload);
        }
        final chars = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 1),
          itemCount: chars.length,
          itemBuilder: (ctx, i) => _CharacterCard(character: chars[i]),
        );
      },
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.character});
  final Character character;

  // Couleur de fond unique dérivée du nom — sobre, jamais vive
  Color get _headerColor {
    final colors = [
      const Color(0xFF1A1200),
      const Color(0xFF000D1A),
      const Color(0xFF0D1A00),
      const Color(0xFF1A0000),
      const Color(0xFF0A001A),
      const Color(0xFF001A1A),
      const Color(0xFF1A0A00),
    ];
    return colors[character.name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header plat avec initiales + nom
              Container(
                height: 72,
                color: _headerColor,
                width: double.infinity,
                child: Row(
                  children: [
                    // Bloc initiales
                    Container(
                      width: 72,
                      height: 72,
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            character.initials,
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFE301),
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            character.genderIcon,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Nom + naissance
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name.toUpperCase(),
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 3,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            character.birthYear,
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 11,
                              color: const Color(0xFF888888),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
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
                    _DataRow('GENRE', character.gender),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('TAILLE', '${character.height} cm'),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('MASSE', '${character.mass} kg'),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('COULEUR DES YEUX', character.eyeColor),
                    const Divider(height: 1, color: Color(0xFF1A1A1A)),
                    _DataRow('COULEUR DES CHEVEUX', character.hairColor),
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
            width: 180,
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