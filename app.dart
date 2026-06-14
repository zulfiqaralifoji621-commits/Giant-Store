import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_shell.dart';
import 'theme/app_theme.dart';

class GiantStoreApp extends StatelessWidget {
  const GiantStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'GiantStore',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData) {
              return const MainShell();
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
