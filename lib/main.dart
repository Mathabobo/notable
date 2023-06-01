import 'package:flutter/material.dart';
import 'package:notable/constants.dart';
import 'package:notable/pages/login.dart';
import 'package:notable/pages/notes.dart';
import 'package:notable/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notable/pages/note_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notable/pages/app_settings.dart';
import 'package:notable/pages/trash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.indigo,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,

        scheme: FlexScheme.indigo,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the Playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthService().handleAuthState(),
        NoteScreen.routeName: (context) => const NoteScreen(),
        Trash.routeName: (context) => const Trash(),
        AppSettings.routeName: (context) => const AppSettings(),
        Notes.routeName: (context) => const Notes(),
        Login.routeName: (context) => const Login(),
      },
    );
  }
}

















// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   FirebaseUIAuth.configureProviders([
//     GoogleProvider(clientId: 539143914184-3ju0621e0q200j1rgq7bc8688kchf4d7.apps.googleusercontent.com),
//   ]);
// }