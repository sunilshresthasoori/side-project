import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TrekkersOdysseyAppV2());
}

class TrekkersOdysseyAppV2 extends StatelessWidget {
  const TrekkersOdysseyAppV2 ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trekkers-Odyssey',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
