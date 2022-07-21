import 'package:chatme/screen/home.dart';
import 'package:chatme/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user=FirebaseAuth.instance.currentUser;

    return MaterialApp(
      home:user==null? Login():const Home(),
      // home: Main(),
    );
  }
}
//
// class Main extends StatefulWidget {
//   const Main({Key? key}) : super(key: key);
//
//   @override
//   State<Main> createState() => _MainState();
// }
//
// class _MainState extends State<Main> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey,
//       body: Login(),
//       // Profile()
//     );
//   }
// }
