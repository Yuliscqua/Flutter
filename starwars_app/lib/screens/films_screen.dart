import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/film.dart';
import '../services/swapi_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class FilmsScreen extends StatefulWidget {
  const FilmsScreen({super.key});

  @override
  State<FilmsScreen> createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> {
  late Future<List<Film>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = SwapiService().fetchFilms();
  }

  void _reload() => setState(() {
        _filmsFuture = SwapiService().fetchFilms();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Film>>(
      future: _filmsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SWLoadingWidget(message: 'CHARGEMENT DES FILMS');
        }
        if (snapshot.hasError) {
          return SWErrorWidget(message: snapshot.error.toString(), onRetry: _reload);
        }
        final films = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 1),
          itemCount: films.length,
          itemBuilder: (ctx, i) => _FilmCard(film: films[i]),
        );
      },
    );
  }
}

class _FilmCard extends StatefulWidget {
  const _FilmCard({required this.film});
  final Film film;

  @override
  State<_FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<_FilmCard> {
  bool _expanded = false;

  // Couleur de fond par trilogie
  Color get _trilogyColor {
    final ep = widget.film.episodeId;
    if (ep <= 3) return const Color(0xFF1A0A00); // prélogie — orangé sombre
    if (ep <= 6) return const Color(0xFF000D1A); // trilogie originale — bleu sombre
    return const Color(0xFF0A001A);              // suite — violet sombre
  }

  String get _trilogyLabel {
    final ep = widget.film.episodeId;
    if (ep <= 3) return 'PRÉLOGIE';
    if (ep <= 6) return 'TRILOGIE ORIGINALE';
    return 'SUITE';
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bande de couleur trilogie (simule une image header)
                Container(
                  height: 6,
                  color: _trilogyColor == const Color(0xFF1A0A00)
                      ? const Color(0xFFE65100)
                      : _trilogyColor == const Color(0xFF000D1A)
                          ? const Color(0xFF0277BD)
                          : const Color(0xFF6A1B9A),
                ),
                // Contenu principal
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge épisode — rectangle jaune plat
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        color: const Color(0xFFFFE301),
                        child: Text(
                          'EP. ${film.episodeRoman}',
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film.title.toUpperCase(),
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _trilogyLabel,
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 11,
                                color: const Color(0xFF666666),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF666666),
                        size: 20,
                      ),
                    ],
                  ),
                ),
                // Infos compactes toujours visibles
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      _MetaChip('RÉAL.', film.director),
                      const SizedBox(width: 24),
                      _MetaChip('SORTIE', film.releaseDate),
                    ],
                  ),
                ),
                // Section expandable : crawl
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: Color(0xFF222222)),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DataRow('PRODUCTEUR', film.producer),
                            const SizedBox(height: 16),
                            Text(
                              'OUVERTURE',
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 10,
                                color: const Color(0xFFFFE301),
                                letterSpacing: 3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              film.openingCrawl
                                  .replaceAll('\r\n', ' ')
                                  .trim(),
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 15,
                                color: const Color(0xFFAAAAAA),
                                height: 1.7,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFF222222)),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: GoogleFonts.barlowCondensed(
            fontSize: 10,
            color: const Color(0xFF666666),
            letterSpacing: 1.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            fontSize: 12,
            color: const Color(0xFFAAAAAA),
            letterSpacing: 0.5,
          ),
        ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.barlowCondensed(
              fontSize: 10,
              color: const Color(0xFF666666),
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.barlowCondensed(
              fontSize: 13,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}