import 'package:dog_breeds_catalog/models/dog_breed.dart';

class DogService {
  static final List<DogBreed> _mockBreeds = [
    DogBreed(
      id: '1',
      name: 'Labrador Retriever',
      origin: 'Canada',
      temperament: 'Friendly, Outgoing, Even Tempered',
      size: 'Large',
      lifeSpan: '10-12 years',
      description: 'El Labrador Retriever es una raza grande y atlética, conocida por su carácter amigable y leal. Son excelentes como mascotas familiares y perros de servicio.',
    ),
    DogBreed(
      id: '2',
      name: 'German Shepherd',
      origin: 'Germany',
      temperament: 'Confident, Courageous, Smart',
      size: 'Large',
      lifeSpan: '9-13 years',
      description: 'Perro inteligente y versátil, ampliamente utilizado como perro de trabajo, policía y servicio. Son leales y protectores con su familia.',
    ),
    DogBreed(
      id: '3',
      name: 'Golden Retriever',
      origin: 'Scotland',
      temperament: 'Intelligent, Friendly, Devoted',
      size: 'Large',
      lifeSpan: '10-11 years',
      description: 'Raza popular por su carácter amable y su inteligencia. Excelentes como mascotas familiares y perros de terapia.',
    ),
    DogBreed(
      id: '4',
      name: 'French Bulldog',
      origin: 'France',
      temperament: 'Playful, Affectionate, Lively',
      size: 'Small',
      lifeSpan: '10-12 years',
      description: 'Pequeño y compacto, conocido por su personalidad divertida. Perfectos para departamentos y espacios reducidos.',
    ),
    DogBreed(
      id: '5',
      name: 'Husky Siberiano',
      origin: 'Russia',
      temperament: 'Friendly, Energetic, Mischievous',
      size: 'Large',
      lifeSpan: '12-14 years',
      description: 'Perro hermoso con ojos azules característicos. Requieren mucho ejercicio y son muy energéticos.',
    ),
    DogBreed(
      id: '6',
      name: 'Bulldog Inglés',
      origin: 'England',
      temperament: 'Dignified, Affectionate, Brave',
      size: 'Medium',
      lifeSpan: '8-10 years',
      description: 'Raza robusta con una apariencia distintiva. Son cariñosos y leales, aunque pueden ser testarudos.',
    ),
  ];

  Future<List<DogBreed>> getBreeds() async {
    // Simular una llamada a API
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBreeds;
  }

  Future<DogBreed?> getBreedById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockBreeds.firstWhere((breed) => breed.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<DogBreed>> searchBreeds(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBreeds
        .where((breed) =>
            breed.name.toLowerCase().contains(query.toLowerCase()) ||
            breed.temperament.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<DogBreed> createBreed(DogBreed breed) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newBreed = DogBreed(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: breed.name,
      origin: breed.origin,
      temperament: breed.temperament,
      size: breed.size,
      lifeSpan: breed.lifeSpan,
      description: breed.description,
    );
    _mockBreeds.add(newBreed);
    return newBreed;
  }

  Future<bool> updateBreed(String id, DogBreed breed) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final index = _mockBreeds.indexWhere((b) => b.id == id);
      if (index >= 0) {
        _mockBreeds[index] = DogBreed(
          id: id,
          name: breed.name,
          origin: breed.origin,
          temperament: breed.temperament,
          size: breed.size,
          lifeSpan: breed.lifeSpan,
          description: breed.description,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBreed(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      _mockBreeds.removeWhere((breed) => breed.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
