class Character {
  final String name;
  final String birthYear;
  final String gender;
  final String height;
  final String mass;
  final String hairColor;
  final String eyeColor;
  final String skinColor;

  const Character({
    required this.name,
    required this.birthYear,
    required this.gender,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.eyeColor,
    required this.skinColor,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] as Map<String, dynamic>? ?? json;
    return Character(
      name: props['name'] ?? 'Inconnu',
      birthYear: props['birth_year'] ?? 'unknown',
      gender: props['gender'] ?? 'unknown',
      height: props['height'] ?? 'unknown',
      mass: props['mass'] ?? 'unknown',
      hairColor: props['hair_color'] ?? 'unknown',
      eyeColor: props['eye_color'] ?? 'unknown',
      skinColor: props['skin_color'] ?? 'unknown',
    );
  }

  String get genderIcon {
    switch (gender.toLowerCase()) {
      case 'male':
        return '♂';
      case 'female':
        return '♀';
      default:
        return '⬡';
    }
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}