// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:research_articles_app/cubit/ai_cubit.dart';
import 'package:research_articles_app/cubit/article_cubit.dart';
import 'package:research_articles_app/repositories/article_repository.dart';
import 'package:research_articles_app/screens/home_screen.dart';
import 'package:research_articles_app/services/api_service.dart';
import 'package:research_articles_app/services/gemini_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  final repository = ArticleRepository(
    apiService: apiService,
    prefs: prefs,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ArticleRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleCubit(repository: repository),
        ),
        BlocProvider(
          create: (context) => AiCubit(geminiService: GeminiService()),
        )
      ],
      child: MaterialApp(
        title: 'Research Papers',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
