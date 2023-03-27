import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_theme_provider.dart';
import 'translation_screen.dart';
import 'utils/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppThemeProvider(),
      child: Consumer<AppThemeProvider>(builder: (context, a, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme:
              a.isDarkMode ? CustomTheme().darkTheme : CustomTheme().lightTheme,
          home: const MyHomePage(),
        );
      }),
    );
  }
}
