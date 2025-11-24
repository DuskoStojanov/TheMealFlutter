import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_summary_model.dart';
import '../models/meal_detail_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List categoriesJson = data['categories'] ?? [];
      return categoriesJson
          .map((json) => MealCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Не можам да ги вчитам категориите');
    }
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      return mealsJson.map((json) => MealSummary.fromJson(json)).toList();
    } else {
      throw Exception('Не можам да ги вчитам јадењата за категорија $category');
    }
  }


  Future<List<MealSummary>> searchMealsByName(String query) async {
    final response =
    await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List? mealsJson = data['meals'];
      if (mealsJson == null) return [];
      return mealsJson.map((json) => MealSummary.fromJson(json)).toList();
    } else {
      throw Exception('Грешка при пребарување на јадења');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final response =
    await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      if (mealsJson.isEmpty) {
        throw Exception('Нема детали за ова јадење');
      }
      return MealDetail.fromJson(mealsJson.first);
    } else {
      throw Exception('Грешка при вчитување детали за јадење');
    }
  }

  Future<MealDetail> fetchRandomMeal() async {
    final response =
    await http.get(Uri.parse('$baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      if (mealsJson.isEmpty) {
        throw Exception('Нема рандом рецепт');
      }
      return MealDetail.fromJson(mealsJson.first);
    } else {
      throw Exception('Грешка при вчитување рандом рецепт');
    }
  }
}
