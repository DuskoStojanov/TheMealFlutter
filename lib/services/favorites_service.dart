import 'package:flutter/foundation.dart';
import '../models/meal_summary_model.dart';

class FavoritesService extends ChangeNotifier {
  final Map<String, MealSummary> _favorites = {};

  List<MealSummary> get favorites => _favorites.values.toList();

  bool isFavorite(String mealId) => _favorites.containsKey(mealId);

  void toggleFavorite(MealSummary meal) {
    if (isFavorite(meal.id)) {
      _favorites.remove(meal.id);
    } else {
      _favorites[meal.id] = meal;
    }
    notifyListeners();
  }
}