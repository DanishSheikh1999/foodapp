import 'package:flutter/material.dart';
import 'package:foodapp/composition_root.dart';
import 'package:google_fonts/google_fonts.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  runApp(MyApp(startPage));
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp( this.startPage);
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
      home: this.startPage
    );
  }
}
