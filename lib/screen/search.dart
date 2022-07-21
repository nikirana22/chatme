import 'package:chatme/model/User.dart';
import 'package:chatme/model/chatroom.dart';
import 'package:chatme/screen/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchedUser = TextEditingController();
  // String? searchEmail;
  Fuser? targetUser;

  @override
  Widget build(BuildContext context) {
    String? chatroom;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
        title: TextField(
          controller: searchedUser,
          onChanged: (value){
            // FirebaseFirestore.instance.
            setState((){
              // searchEmail=value;
            });
          },
          decoration: const InputDecoration(hintText: 'enter user email'),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final a = FirebaseFirestore.instance
                    .collection('user')
                    .where('email', isEqualTo: searchedUser.text);
                QuerySnapshot getUser = await a.get();
                targetUser = Fuser()
                    .fromMap(getUser.docs[0].data() as Map<String, dynamic>);
                setState(() {});
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: FutureBuilder(future: FirebaseFirestore.instance.collection('user').where('email',isEqualTo:searchedUser.text ).get(),
        builder: (_,snapshot){
        QuerySnapshot querySnapshot=snapshot.data as QuerySnapshot;

        // print('snapshot data here----->  ${snapshot.data}');

        return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (_,index){

          return Container(
              child: targetUser != null
                  ? ListTile(
                  onTap: () async {
                    String senderuid =
                        FirebaseAuth.instance.currentUser!.uid;
                    String reciverUid = targetUser!.uid.toString();
                    String uid = senderuid + reciverUid;
                    QuerySnapshot query = await FirebaseFirestore.instance
                        .collection('chatroom')
                        .where('senderUid', isEqualTo: senderuid)
                        .where('reciverUid', isEqualTo: reciverUid)
                        .get();
                    // String checkSecondway=reciverUid+senderuid;
                    QuerySnapshot querysecond = await FirebaseFirestore
                        .instance
                        .collection('chatroom')
                        .where('senderUid', isEqualTo: reciverUid)
                        .where('reciverUid', isEqualTo: senderuid)
                        .get();

                    if (query.docs.isNotEmpty) {
                      print(
                          '(if statement ) first user uid ----------------------->>');
                      // if (mounted) {
                      chatroom = senderuid + reciverUid;
                      gotoChatPage(context, chatroom!, senderuid);
                      // }
                    } else if (querysecond.docs.isNotEmpty) {
                      print(
                          '(else if statement ) second user uid is match ----------------->>>>>>>>>>>>>>>');
                      chatroom = reciverUid + senderuid;
                      gotoChatPage(context, chatroom!, senderuid);
                    } else {
                      print(
                          'else statement UID is not present ------------------------->>>>>>>>>>>>>');
                      Chatroom chat = Chatroom(
                          senderUid: senderuid,
                          reciverUid: reciverUid,
                        // participants: {'sender':senderuid,'reciver':reciverUid},
                          message: '',
                          chatroom: uid);
                      FirebaseFirestore.instance
                          .collection('chatroom')
                          .doc(uid)
                          .set(chat.toMap());
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) {
                              return Chat(
                                  chatroom: uid,
                                  ricever: targetUser!,
                                  senderUid: senderuid);
                            }));
                      }
                    }
                  },
                  tileColor: const Color.fromRGBO(118, 125, 232, 1),
                  title: Text(targetUser!.email.toString()),
                  leading: const CircleAvatar(
                    backgroundColor: Color.fromRGBO(135, 145, 152, 0.5),
                    child: Icon(Icons.person),
                  ))
                  : const Text('No user Found'));
        });

        },
      ),
      //todo :->  Or quary in FirebaseFirestor
    );
  }
//   Center(
//   child: targetUser != null
//   ? ListTile(
//   onTap: () async {
//   String senderuid =
//       FirebaseAuth.instance.currentUser!.uid;
//   String reciverUid = targetUser!.uid.toString();
//   String uid = senderuid + reciverUid;
//   QuerySnapshot query = await FirebaseFirestore.instance
//       .collection('chatroom')
//       .where('senderUid', isEqualTo: senderuid)
//       .where('reciverUid', isEqualTo: reciverUid)
//       .get();
//   // String checkSecondway=reciverUid+senderuid;
//   QuerySnapshot querysecond = await FirebaseFirestore
//       .instance
//       .collection('chatroom')
//       .where('senderUid', isEqualTo: reciverUid)
//       .where('reciverUid', isEqualTo: senderuid)
//       .get();
//
//   if (query.docs.isNotEmpty) {
//   print(
//   '(if statement ) first user uid ----------------------->>');
//   // if (mounted) {
//   chatroom = senderuid + reciverUid;
//   gotoChatPage(context, chatroom!, senderuid);
//   // }
//   } else if (querysecond.docs.isNotEmpty) {
//   print(
//   '(else if statement ) second user uid is match ----------------->>>>>>>>>>>>>>>');
//   chatroom = reciverUid + senderuid;
//   gotoChatPage(context, chatroom!, senderuid);
//   } else {
//   print(
//   'else statement UID is not present ------------------------->>>>>>>>>>>>>');
//   Chatroom chat = Chatroom(
//   senderUid: senderuid,
//   reciverUid: reciverUid,
//   message: '',
//   chatroom: uid);
//   FirebaseFirestore.instance
//       .collection('chatroom')
//       .doc(uid)
//       .set(chat.toMap());
//   if (mounted) {
//   Navigator.of(context).pushReplacement(
//   MaterialPageRoute(builder: (_) {
//   return Chat(
//   chatroom: uid,
//   ricever: targetUser!,
//   senderUid: senderuid);
//   }));
//   }
//   }
// },
// tileColor: const Color.fromRGBO(118, 125, 232, 1),
// title: Text(targetUser!.email.toString()),
// leading: const CircleAvatar(
// backgroundColor: Color.fromRGBO(135, 145, 152, 0.5),
// child: Icon(Icons.person),
// ))
// : const Text('No user Found'))


void gotoChatPage(BuildContext context, String chatroom, String senderuid) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return Chat(
          chatroom: chatroom, ricever: targetUser!, senderUid: senderuid);
    }));
  }
}
