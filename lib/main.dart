import 'package:chatme/provider/manage_chat.dart';
import 'package:chatme/screen/home.dart';
import 'package:chatme/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //todo manage chat logic from ManageChat provider
  runApp(ChangeNotifierProvider.value(value: ManageChat(),child:const MyApp(),));
}
//todo we are using a same method in many classes so can we put that method in different class or (that will will be static or nonstatic ??)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user=FirebaseAuth.instance.currentUser;

    return MaterialApp(
      home:user==null? Login():const Home(),
    );
  }
}