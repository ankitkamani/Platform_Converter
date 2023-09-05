import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_converter/Providers/ContactProvider.dart';
import 'package:platform_converter/Providers/SettingProvider.dart';
import 'package:platform_converter/Providers/ThemeProvider.dart';
import 'package:platform_converter/View/IOS/IOS_HomeScreen.dart';
import 'package:provider/provider.dart';
import 'View/Home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SettingProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider())
      ],
      builder: (context, child) {
        var themeProvider = Provider.of<ThemeProvider>(context);
        return themeProvider.isIos
            ? CupertinoApp(
                debugShowCheckedModeBanner: false,
                theme: themeProvider.cupertinoThemeData,
                home: const IosHomeScreen(),
              )
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData.dark(
                  useMaterial3: true,
                ),
                themeMode: themeProvider.themeMode,
                home: const HomeScreen(),
              );
      },
    );
  }
}
