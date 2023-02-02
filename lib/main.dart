import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './models/bottomPanelModel.dart';
import './pages/splash.dart';
import 'firebase_options.dart';
import 'models/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Data(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomPanelModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sanskritive',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                centerTitle: true,
                // textTheme: TextTheme(headline3: TextStyle(color: Colors.black)),
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                color: Colors.blue[200],
                shadowColor: Colors.tealAccent[700]),
            fontFamily: "ProductSans"),
        home: Splash(),
      ),
    );
  }
}
