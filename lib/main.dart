import 'package:flutter/material.dart';
import 'package:foodapp/composition_root.dart';
import 'package:foodapp/pages/auth/authPage.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  CompositionRoot.configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme:GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        accentColor: Colors.amber[700],
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: CompositionRoot.composeHomeUI()
    );
  }
}
