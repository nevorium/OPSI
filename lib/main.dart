import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/habit/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const QuranicHabitApp());
}

class QuranicHabitApp extends StatelessWidget {
  const QuranicHabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Tambahkan provider di sini
      ],
      child: MaterialApp(
        title: 'Quranic Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
