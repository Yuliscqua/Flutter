class Film {
  final String title;
  final int episodeId;
  final String openingCrawl;
  final String director;
  final String producer;
  final String releaseDate;

  const Film({
    required this.title,
    required this.episodeId,
    required this.openingCrawl,
    required this.director,
    required this.producer,
    required this.releaseDate,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] as Map<String, dynamic>? ?? json;
    return Film(
      title: props['title'] ?? 'Inconnu',
      episodeId: int.tryParse(props['episode_id'].toString()) ?? 0,
      openingCrawl: props['opening_crawl'] ?? '',
      director: props['director'] ?? 'Inconnu',
      producer: props['producer'] ?? 'Inconnu',
      releaseDate: props['release_date'] ?? 'Inconnu',
    );
  }

  String get episodeRoman {
    const roman = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'];
    if (episodeId >= 1 && episodeId <= roman.length) {
      return roman[episodeId - 1];
    }
    return episodeId.toString();
  }
}