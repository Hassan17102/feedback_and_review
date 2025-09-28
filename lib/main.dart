// lib/main.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// App files (adjust paths if your files are in subfolders)
import 'feedback_repository.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'feedback_form_screen.dart';
import 'feedback_list_screen.dart';
import 'feedback_detail_screen.dart';
import 'analytics_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCV6gtNO_AD9uLP8pvH1JtlXYpbmw3i30I",
        authDomain: "feedback-and-review-30b46.firebaseapp.com",
        projectId: "feedback-and-review-30b46",
        storageBucket: "feedback-and-review-30b46.firebasestorage.app",
        messagingSenderId: "829292336825",
        appId: "1:829292336825:web:0f1232f4c0a5b36aecad68",
        measurementId: "G-CX95LB1ZMD",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Optional: warm analytics
  try {
    FirebaseAnalytics.instance;
  } catch (_) {}

  // Ensure an authenticated user exists (anonymous sign-in)
  await _ensureSignedInAnonymously();

  runApp(const MyApp());
}

Future<void> _ensureSignedInAnonymously() async {
  final auth = FirebaseAuth.instance;
  try {
    if (auth.currentUser == null) {
      debugPrint('Signing in anonymously...');
      final cred = await auth.signInAnonymously();
      debugPrint('Signed in anonymously: uid=${cred.user?.uid}');
    } else {
      debugPrint('Already signed in: uid=${auth.currentUser!.uid}');
    }
  } on FirebaseAuthException catch (e) {
    debugPrint('FirebaseAuthException during anon sign-in: ${e.code} ${e.message}');
  } catch (e, st) {
    debugPrint('Anonymous sign-in failed: $e\n$st');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // compact text sizes (smaller than default)
    final textTheme = const TextTheme(
      headlineSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 14.0),
      bodyMedium: TextStyle(fontSize: 13.0),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.white70),
      labelLarge: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback & Review App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.blueAccent,
        ),
        textTheme: textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 13.0),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/feedbackForm': (context) => const FeedbackFormScreen(),
        '/feedbackList': (context) => const FeedbackListScreen(),
        // This route expects a FeedbackItem in the navigation arguments.
        // It shows a proper fallback page (with AppBar/back button) when no arg is provided.
        '/feedbackDetail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is FeedbackItem) {
            return FeedbackDetailScreen(feedback: args);
          }

          // Fallback page with app bar so user can navigate back
          return Scaffold(
            appBar: AppBar(
              title: const Text('Feedback Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No feedback provided', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (!Navigator.of(context).canPop()) {
                        Navigator.pushReplacementNamed(context, '/feedbackList');
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Back to list'),
                  ),
                ],
              ),
            ),
          );
        },
        '/analytics': (context) => const AnalyticsDashboardScreen(),
      },
    );
  }
}
