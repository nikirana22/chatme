import 'package:chatme/model/User.dart';
import 'package:chatme/screen/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confPassword = TextEditingController();
  bool hidePassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      // appBar: AppBar(),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
        SvgPicture.asset(
          'assets/images/signup.svg',
          height: height * 0.47,
          width: width,
          fit: BoxFit.fitWidth,
        ),            IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon:const Icon(Icons.arrow_back,color: Colors.white,))

            ],),

            Card(
                elevation: 7,
                shadowColor: const Color.fromRGBO(118, 125, 232, 1),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                            label: Text(
                              'enter your email',
                              style: TextStyle(color: Colors.black54),
                            ),
                            border: InputBorder.none),
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                      TextField(
                        // obscureText: true,
                        controller: password,
                        decoration: const InputDecoration(
                            label: Text(
                              'enter your password',
                              style: TextStyle(color: Colors.black54),
                            ),
                            border: InputBorder.none),
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                      TextField(
                        // obscureText: true,
                        controller: confPassword,
                        //todo should we make this class as Statefull only for password -> obscureText or we can apply some other method
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                hidePassword = !hidePassword;
                              },
                            ),
                            label: const Text(
                              'conform password',
                              style: TextStyle(color: Colors.black54),
                            ),
                            border: InputBorder.none),
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: height * 0.08,
            ),
            InkWell(
              onTap: () {
                if (email.text == '' ||
                    password.text == '' ||
                    confPassword.text == '') {
                  errorDialog(
                      'error occured', 'Please fill all the details', context);
                } else if (password.text != confPassword.text) {
                  errorDialog(
                      'something is wrong with your password',
                      'Make sure you are using same password in both field',
                      context);
                } else {
                  createUser(context);
                }
              },
              child: Container(
                width: width,
                height: height * 0.07,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(118, 125, 232, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Text(
                  'Signup',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
              ),
            ),
            SizedBox(
              height: height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Already have an account '),
                Text(
                  '  Login up',
                  style: TextStyle(
                    fontSize: 20,
                    color:
                    Color.fromRGBO(118, 125, 232, 1),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  void errorDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(content),
            title: Text(title),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }

  void createUser(BuildContext context) async {
    //todo which one is better way
    // todo :->  1. should we put these all three varialbe in method parameter
    //todo :->  2. or this is correct here
    String userEmail = email.text.trim();
    String userPassword = password.text.trim();
    UserCredential? userCredential;
    // try {
    //   userCredential = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(
    //           email: userEmail, password: userPassword);
    // } on FirebaseAuthException catch (e) {
    //   log('error in userCredential $e');
    // }//todo how can we change this
    try {
      userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
    }on FirebaseAuthException catch (e){
      errorDialog('error occure in auth ', '$e', context);
    }
    if (userCredential != null) {
      Fuser user=Fuser(email: userCredential.user!.email,uid: userCredential.user!.uid,name: '',image: 'x`');
      FirebaseFirestore.instance.collection('user').doc(user.uid).set(user.toMap());
         goToLogin(context);
    }
    else{
      print('come in else statement  -------------------------------- ${userCredential!.user! .email}');
    }
  }

  goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
      return Profile();
    }));

  }
}
