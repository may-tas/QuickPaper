// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/ai_cubit.dart';
import 'cubit/article_cubit.dart';
import 'repositories/article_repository.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/gemini_service.dart';
import 'utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  final repository = ArticleRepository(
    apiService: apiService,
    prefs: prefs,
  );

  await dotenv.load(fileName: ".env");

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
    SizeConfig().init(context);
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
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
