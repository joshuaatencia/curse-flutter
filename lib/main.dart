import 'package:curse_flutter/pages/home.dart';
import 'package:curse_flutter/pages/status.dart';
import 'package:curse_flutter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Services())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        initialRoute: 'home',
        // home: Home(),
        routes: {'status': (_) => StatusPage(), 'home': (_) => Home()},
      ),
    );
  }
}
