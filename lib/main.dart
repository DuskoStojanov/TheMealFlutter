import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/api_service.dart';
import 'services/favorites_service.dart';
import 'services/notification_service.dart';

import 'screens/category_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<FavoritesService>(create: (_) => FavoritesService()),
      ],
      child: MaterialApp(
        title: 'TheMealDB + Firebase',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const CategoryListScreen(),
      ),
    );
  }
}
