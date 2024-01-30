import 'package:bcsports_mobile/routes/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCSports',
      theme: ThemeData(
        fontFamily: 'HN',
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
