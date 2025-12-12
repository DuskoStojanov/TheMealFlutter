  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../models/category_model.dart';
  import '../models/meal_detail_model.dart';
  import '../services/api_service.dart';
  import '../widgets/category_card.dart';
  import 'favorites_screen.dart';
  import 'meals_by_category_screen.dart';
  import 'meal_detail_screen.dart';

  class CategoryListScreen extends StatefulWidget {
    const CategoryListScreen({Key? key}) : super(key: key);

    @override
    State<CategoryListScreen> createState() => _CategoryListScreenState();
  }

  class _CategoryListScreenState extends State<CategoryListScreen> {
    List<MealCategory> _allCategories = [];
    List<MealCategory> _filteredCategories = [];
    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      _loadCategories();
    }

    Future<void> _loadCategories() async {
      try {
        final api = context.read<ApiService>();
        final categories = await api.fetchCategories();

        setState(() {
          _allCategories = categories;
          _filteredCategories = categories;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Грешка: $e')),
        );
      }
    }

    void _filterCategories(String query) {
      setState(() {
        if (query.trim().isEmpty) {
          _filteredCategories = _allCategories;
        } else {
          _filteredCategories = _allCategories
              .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    }

    Future<void> _showRandomMeal() async {
      try {
        final api = context.read<ApiService>();
        final MealDetail randomMeal = await api.fetchRandomMeal();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(meal: randomMeal),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Грешка при вчитување рандом рецепт: $e')),
        );
      }
    }

    void _openFavorites() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Категории на рецепти'),
          actions: [
            IconButton(
              onPressed: _showRandomMeal,
              icon: const Icon(Icons.shuffle),
              tooltip: 'Рандом рецепт на денот',
            ),
            IconButton(
              onPressed: _openFavorites,
              icon: const Icon(Icons.favorite),
              tooltip: 'Омилени',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Пребарувај категории...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _filterCategories,
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealsByCategoryScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
