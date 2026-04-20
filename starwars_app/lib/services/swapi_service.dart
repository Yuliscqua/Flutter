import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';
import '../models/planet.dart';
import '../models/character.dart';

class SwapiService {
  static const String _baseUrl = 'https://swapi.tech/api';

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$_baseUrl/films'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['result'] as List<dynamic>;
      return results.map((e) => Film.fromJson(e)).toList()
        ..sort((a, b) => a.episodeId.compareTo(b.episodeId));
    }
    throw Exception('Impossible de charger les films (${response.statusCode})');
  }

  Future<List<Planet>> fetchPlanets({int count = 10}) async {
    final listResp =
        await http.get(Uri.parse('$_baseUrl/planets?page=1&limit=$count'));
    if (listResp.statusCode != 200) {
      throw Exception(
          'Impossible de charger les planètes (${listResp.statusCode})');
    }

    final listData = jsonDecode(listResp.body);
    final items = listData['results'] as List<dynamic>;

    final futures = items.map((item) async {
      final uid = item['uid'].toString();
      final detailResp = await http.get(Uri.parse('$_baseUrl/planets/$uid'));
      if (detailResp.statusCode == 200) {
        final detail = jsonDecode(detailResp.body);
        return Planet.fromJson(detail['result'] as Map<String, dynamic>);
      }
      return Planet.fromJson({
        'properties': <String, dynamic>{'name': item['name']}
      });
    });

    return Future.wait(futures);
  }

  Future<List<Character>> fetchCharacters({int count = 10}) async {
    final listResp =
        await http.get(Uri.parse('$_baseUrl/people?page=1&limit=$count'));
    if (listResp.statusCode != 200) {
      throw Exception(
          'Impossible de charger les personnages (${listResp.statusCode})');
    }

    final listData = jsonDecode(listResp.body);
    final items = listData['results'] as List<dynamic>;

    final futures = items.map((item) async {
      final uid = item['uid'].toString();
      final detailResp = await http.get(Uri.parse('$_baseUrl/people/$uid'));
      if (detailResp.statusCode == 200) {
        final detail = jsonDecode(detailResp.body);
        return Character.fromJson(detail['result'] as Map<String, dynamic>);
      }
      return Character.fromJson({
        'properties': <String, dynamic>{'name': item['name']}
      });
    });

    return Future.wait(futures);
  }
}