import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBc0h-IfjUzmFMnRhaUh1scs1sARe2ass4",
        appId: "1:25445840435:android:d038827e6b48fa4af5d546",
        messagingSenderId: "25445840435",
        databaseURL: "https://flowfinance-cf09d-default-rtdb.firebaseio.com/",
        projectId: "flowfinance-cf09d",
        storageBucket: "flowfinance-cf09d.appspot.com/images",
      ),
    );
  }

  runApp(
    OverlaySupport.global(
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: RouteManager.splash,
    );
  }
}
