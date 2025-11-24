import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/meal_summary_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final MealCategory category;

  const MealsByCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService _apiService = ApiService();
  List<MealSummary> _meals = [];
  List<MealSummary> _displayedMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final meals =
      await _apiService.fetchMealsByCategory(widget.category.name);
      setState(() {
        _meals = meals;
        _displayedMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Грешка: $e')),
      );
    }
  }

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        _displayedMeals = _meals;
      });
      return;
    }

    try {
      final results = await _apiService.searchMealsByName(query);
            setState(() {
        _displayedMeals = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Грешка при пребарување: $e')),
      );
    }
  }

  Future<void> _openMealDetail(MealSummary meal) async {
    try {
      final detail = await _apiService.fetchMealDetail(meal.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(meal: detail),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Грешка при вчитување детали: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категорија: ${widget.category.name}'),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Пребарувај јадења...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchMeals,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: _displayedMeals.length,
              itemBuilder: (context, index) {
                final meal = _displayedMeals[index];
                return MealGridItem(
                  meal: meal,
                  onTap: () => _openMealDetail(meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
