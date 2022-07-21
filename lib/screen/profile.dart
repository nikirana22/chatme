import 'dart:io';
import 'package:chatme/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? userProfile;
  String? profileUrl;
  TextEditingController userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async {
                XFile? xfile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (xfile != null) {
                  User? user = FirebaseAuth.instance.currentUser;
                  userProfile = File(xfile.path);
                  Reference f = FirebaseStorage.instance.ref();
                  UploadTask? upoladFile;
                  try {
                    upoladFile = f
                        .child('images')
                        .child(user!.uid)
                        .putFile(userProfile!);
                  } on FirebaseException catch (e) {
                    print('exception in firebase storage   ->>>>>>>>>>. $e');
                  }
                  upoladFile!.then((image) async {
                    profileUrl = await image.ref.getDownloadURL();
                    setState(() {});
                  }).onError((error, stackTrace) {
                    print(
                        'error in profile uploading page -----------------------$error');
                  });
                }
                setState(() {});
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage:
                    profileUrl != null ? NetworkImage(profileUrl!) : null,
                child: profileUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: userName,
              decoration: InputDecoration(
                  label: const Text(
                    'username',
                    style: TextStyle(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.white),
                    // borderSide:const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              if (userProfile != null && userName.text != '') {
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'image': profileUrl, 'name': userName.text}).then(
                        (value) {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (_) {
                    return const Home();
                  }));
                });
              }
            },
            style: ButtonStyle(
                side: MaterialStateProperty.all(BorderSide()),
                splashFactory: InkSplash.splashFactory,
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                fixedSize:
                    MaterialStateProperty.all(Size(width * 0.8, height * 0.07)),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            child: const Text(
              'Submit',
              style: TextStyle(
                  color: Color.fromRGBO(118, 125, 232, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
