import 'package:flutter/material.dart';
import '../models/meal_summary_model.dart';

class MealGridItem extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const MealGridItem({
    Key? key,
    required this.meal,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    meal.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            
            Positioned(
              top: 6,
              right: 6,
              child: IconButton(
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
