import 'package:chatme/provider/manage_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/User.dart';
import '../model/chatroom.dart';
import '../screen/chat.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchedUser = TextEditingController();
  List<QueryDocumentSnapshot> targetUsersList = [];
  Fuser? targetUser;

  @override
  Widget build(BuildContext context) {
    User? senderuid = FirebaseAuth.instance.currentUser;

    String? chatroom;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
          title: TextField(
            controller: searchedUser,
            onChanged: (value) {
              // FirebaseFirestore.instance.
              // setState((){
              //   // searchEmail=value;
              // });
            },
            decoration: const InputDecoration(hintText: 'enter user email'),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  QuerySnapshot getUser = await FirebaseFirestore.instance
                      .collection('user')
                      .where('email', isEqualTo: searchedUser.text)
                      .where('email',isNotEqualTo:senderuid!.email )
                      .get();
                  targetUsersList = getUser.docs;
                  // Map mp=Map.from(getUser.docs[0].data()as Map);
                  // print(mp.runtimeType);
                  // targetUser = Fuser()
                  //     .fromMap(getUser.docs[0].data() as Map<String, dynamic>);
                  setState(() {});
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: ListView.builder(
            itemCount: targetUsersList.length,
            itemBuilder: (_, index) {
              targetUser =
                  Fuser().fromMap(targetUsersList[index].data() as Map);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ListTile(
                    onTap: () async {
                      String reciverUid = targetUser!.uid.toString();
                      NavigatorState navigatorState=Navigator.of(context);
                      //todo bad logic [how can we change this]
                      String uid = senderuid!.uid + reciverUid;
                      QuerySnapshot query = await FirebaseFirestore.instance
                          .collection('chatroom')
                          .where('senderUid', isEqualTo: senderuid.uid)
                          .where('reciverUid', isEqualTo: reciverUid)
                          .get();
                      QuerySnapshot querysecond = await FirebaseFirestore
                          .instance
                          .collection('chatroom')
                          .where('senderUid', isEqualTo: reciverUid)
                          .where('reciverUid', isEqualTo: senderuid.uid)
                          .get();

                      if (query.docs.isNotEmpty) {
                        print(
                            '(if statement ) first user uid ----------------------->>');
                        chatroom = senderuid.uid + reciverUid;
                        gotoChatPage(navigatorState, chatroom!, senderuid.uid);
                      } else if (querysecond.docs.isNotEmpty) {
                        print(
                            '(else if statement ) second user uid is match ----------------->>>>>>>>>>>>>>>');
                        chatroom = reciverUid + senderuid.uid;
                        gotoChatPage(navigatorState, chatroom!, senderuid.uid);
                      } else {
                        print(
                            'else statement UID is not present ------------------------->>>>>>>>>>>>>');
                        Chatroom chat = Chatroom(
                            senderUid: senderuid.uid,
                            reciverUid: reciverUid,
                            // participants: {'sender':senderuid,'reciver':reciverUid},
                            message: '',
                            chatroom: uid);
                        FirebaseFirestore.instance
                            .collection('chatroom')
                            .doc(uid)
                            .set(chat.toMap());
                        if (mounted) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (_) {
                            return Chat(
                                chatroom: uid,
                                ricever: targetUser!,
                                senderUid: senderuid.uid);
                          }));
                        }
                      }
                    },
                    tileColor: const Color.fromRGBO(118, 125, 232, 1),
                    title: Text(targetUser!.name.toString()),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(targetUser!.image.toString()),
                      backgroundColor:const Color.fromRGBO(135, 145, 152, 0.5),
                      child: Icon(Icons.person),
                    )),
              );
              // : const Text('No user Found');
            })
        //todo :->  Or quary in FirebaseFirestor
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Provider.of<ManageChat>(context,listen: false)..getChatrooms()..getMessages();
        },
      ),
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

  void gotoChatPage(NavigatorState navigatorState, String chatroom, String senderuid) {
    navigatorState.pushReplacement(MaterialPageRoute(builder: (_) {
      return Chat(
          chatroom: chatroom, ricever: targetUser!, senderUid: senderuid);
    }));
  }
}
