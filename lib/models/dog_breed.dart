class DogBreed {
  final String id;
  final String name;
  final String origin;
  final String temperament;
  final String size;
  final String lifeSpan;
  final String description;

  DogBreed({
    required this.id,
    required this.name,
    required this.origin,
    required this.temperament,
    required this.size,
    required this.lifeSpan,
    required this.description,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      origin: json['origin'] ?? '',
      temperament: json['temperament'] ?? '',
      size: json['size'] ?? '',
      lifeSpan: json['lifeSpan'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'temperament': temperament,
      'size': size,
      'lifeSpan': lifeSpan,
      'description': description,
    };
  }
}
