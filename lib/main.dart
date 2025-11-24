import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMealDB',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const CategoryListScreen(),
    );
  }
}
