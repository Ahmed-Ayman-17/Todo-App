import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/providers/app_auth_provider.dart';
import 'package:todo_app/ui/home/home_screen.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:todo_app/ui/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Auto Login: نشوف لو في يوزر مسجّل دخول مسبقاً من جلسة قديمة
  // Firebase بيحتفظ بالـ session تلقائياً، لو في يوزر مش هيبقى null
  User? currentUser = FirebaseAuth.instance.currentUser;

  runApp(
    ChangeNotifierProvider(
      // نعمل الـ provider وعلى طول نحط اليوزر الحالي (لو موجود)
      create: (_) => AppAuthProvider()..firebaseUser = currentUser,
      child: MyApp(isLoggedIn: currentUser != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  // بنمرر هل في يوزر موجود مسبقاً أو لأ
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        scaffoldBackgroundColor: const Color(0xFFDFECDB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
        ),
        useMaterial3: false,
      ),
      title: 'TODO APP',
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
      // Auto Login: لو اليوزر موجود → HomeScreen مباشرة
      // لو مش موجود → LoginScreen
      initialRoute: isLoggedIn ? HomeScreen.routeName : LoginScreen.routeName,
    );
  }
}
