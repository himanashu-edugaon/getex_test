import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getex_test/views/screens/auth/google_auth.dart';
import 'package:getex_test/views/screens/home/Buttom_navation.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? currentUser = FirebaseAuth.instance.currentUser;
  Widget initialRoute;
  if (currentUser != null) {
    initialRoute = MyHomePage();
  } else {
    initialRoute = GoogleAuth();
  }

    runApp(MyApp(initialRoute: initialRoute));
  }

class MyApp extends StatelessWidget {
  final initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: initialRoute,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}
