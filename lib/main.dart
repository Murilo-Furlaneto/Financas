import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/data/repository/firebase/firebase_repository.dart';
import 'package:financas/data/service/firebase_service.dart';
import 'package:financas/presentation/viewmodel/monthly_expenses._viewmodel.dart';
import 'package:financas/presentation/viewmodel/user_viewmodel.dart';
import 'package:financas/presentation/view/check_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(
            FirebaseRepository(FirebaseService()),
            SharedPreferencesHelper(),
          ),
        ),
        ChangeNotifierProvider<MonthlyExpensesViewmodel>(
          create: (_) => MonthlyExpensesViewmodel(
            SharedPreferencesHelper(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: CheckPage(),
    );
  }
}
