import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:test_bloc/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:test_bloc/injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Number Trivia',
        theme: ThemeData(
          primaryColor: Colors.green.shade800,
          colorScheme: const ColorScheme.light()
              .copyWith(secondary: Colors.green.shade900),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
          ),
        ),
        home: const NumberTriviaPage(),
      ),
    );
  }
}
