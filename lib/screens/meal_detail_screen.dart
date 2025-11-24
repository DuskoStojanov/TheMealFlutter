import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail_model.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail meal;

  const MealDetailScreen({Key? key, required this.meal}) : super(key: key);

  Future<void> _openYoutube() async {
    if (meal.youtubeUrl == null || meal.youtubeUrl!.isEmpty) return;

    final uri = Uri.parse(meal.youtubeUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(meal.thumbnail),
            ),
            const SizedBox(height: 12),


            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),


            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...meal.ingredients.map(
                  (ing) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(
                    child: Text('${ing.name} – ${ing.measure}'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),


            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              meal.instructions,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 16),

            if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _openYoutube,
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('YouTube video'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
