import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/favorites_service.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();
    final api = context.read<ApiService>();

    final favs = favoritesService.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Омилени рецепти')),
      body: favs.isEmpty
          ? const Center(child: Text('Немаш додадено омилени рецепти.'))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: favs.length,
        itemBuilder: (context, index) {
          final meal = favs[index];

          return MealGridItem(
            meal: meal,
            onTap: () async {
              final detail = await api.fetchMealDetail(meal.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: detail),
                ),
              );
            },
            isFavorite: favoritesService.isFavorite(meal.id),
            onFavoriteTap: () => favoritesService.toggleFavorite(meal),
          );
        },
      ),
    );
  }
}
