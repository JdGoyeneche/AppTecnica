// lib/models/meal.dart
class Meal {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;
  final String area;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
    required this.area,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      area: json['strArea'] ?? '',
    );
  }
}
