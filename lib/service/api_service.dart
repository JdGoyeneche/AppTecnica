// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  /// 🔹 Buscar recetas por nombre
  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search.php?s=$query"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((mealJson) => Meal.fromJson(mealJson))
            .toList();
      } else {
        return []; // No encontró nada
      }
    } else {
      throw Exception("Error al cargar recetas");
    }
  }

  
  static Future<Meal> getRandomMeal() async {
    final response = await http.get(Uri.parse("$baseUrl/random.php"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception("Error al cargar receta aleatoria");
    }
  }
}
