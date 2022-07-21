import 'package:chatme/screen/home.dart';
import 'package:chatme/screen/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/login.svg',
              height: height * 0.5,
              width: width,
              fit: BoxFit.cover,
            ),
            Card(
                elevation: 7,
                shadowColor: const Color.fromRGBO(118, 125, 232, 1),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      hintText: '     enter your email',
                      border: InputBorder.none),
                )),
            const Divider(
              color: Colors.black,
              height: 5,
              thickness: 1,
              endIndent: 30,
              indent: 30,
            ),
            Card(
              elevation: 7,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              shadowColor: const Color.fromRGBO(118, 125, 232, 1),
              child: TextField(
                controller: password,
                decoration: const InputDecoration(
                    hintText: 'enter your password', border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            //todo how can we check user chatroom
            TextButton(
              onPressed: () {
                if (email.text == '' && password.text == '') {
                  errorDialog(
                      'empty field', 'please enter all the details', context);
                } else {
                  loginUser(context);
                }
              },
              style: ButtonStyle(
                  splashFactory: InkSplash.splashFactory,
                  shape:
                      MaterialStateProperty.all(const RoundedRectangleBorder()),
                  fixedSize: MaterialStateProperty.all(
                      Size(width * 0.8, height * 0.07)),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(118, 125, 232, 1),
                  )),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Container(
            //   width: width,
            //   height: height * 0.07,
            //   margin: const EdgeInsets.symmetric(horizontal: 25),
            //   decoration: BoxDecoration(
            //       color: const Color.fromRGBO(118, 125, 232, 1),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: const Center(
            //       child: Text(
            //     'Login',
            //     style: TextStyle(color: Colors.white, fontSize: 25),
            //   )),
            // ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account '),
                InkWell(
                  onTap: () {
                    print('button pressed ');
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, secondAnimation) {
                          return SignUp();
                        },
                        transitionsBuilder:
                            (_, animation, secondAnimation, child) {
                          Animation<Offset> ann = Tween<Offset>(
                                  begin: const Offset(1, 0), end: Offset.zero)
                              .animate(animation);
                          return SlideTransition(
                            position: ann,
                            child: child,
                          );
                        },
                        barrierColor: const Color.fromRGBO(118, 125, 232, 1),
                        transitionDuration: const Duration(seconds: 2),
                        reverseTransitionDuration: const Duration(seconds: 2),
                        maintainState: false,
                      ),
                    );
                  },
                  child: const Text(
                    '  Sign up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(118, 125, 232, 1),
                    ),
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

  void loginUser(BuildContext context) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      errorDialog('exception occured', '$e', context);
    }if(userCredential!=null) {
      //todo what should we do here
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondAnaimtion) {
                return Home();
              },
              transitionDuration: const Duration(seconds: 2),
              transitionsBuilder: (context, animation, secondanimation, child) {
                Animation<Offset> ani =
                Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                    .animate(animation);
                return SlideTransition(
                  position: ani,
                  child: child,
                );
              }));
    }
  }
}
