import 'package:chatme/model/User.dart';
import 'package:chatme/model/chatroom.dart';
import 'package:chatme/screen/chat.dart';
import 'package:chatme/screen/login.dart';
import 'package:chatme/screen/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
        title: const Text('Chatme'),
        actions: [
          IconButton(onPressed:(){
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
              return Login();
            }));
          },icon: Icon(Icons.logout))
        ],
      ),
      //todo change login from here

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .snapshots(),
        builder: (_, chatroomsnapshot) {
          if (chatroomsnapshot.hasData) {
            QuerySnapshot querySnapshot =
                chatroomsnapshot.data as QuerySnapshot;

            return ListView.builder(
              itemCount: querySnapshot.size,
              itemBuilder: (_, item) {
                Chatroom chatroom =
                    Chatroom().fromMap(querySnapshot.docs[item].data() as Map);
                // DocumentSnapshot<Map<String, dynamic>>;
                String? findusertype;
                if (currentUser ==
                    chatroom.senderUid) {
                  findusertype = chatroom.reciverUid as String;
                } else if(currentUser==chatroom.reciverUid){
                  findusertype = chatroom.senderUid;
                }
                return findusertype!=null? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(findusertype)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snap) {
                      if (snap.hasData) {
                        DocumentSnapshot query = snap.data as DocumentSnapshot;
                        Fuser user = Fuser().fromMap(query.data() as Map);
                        return ListTile(
                          title: Text(user.name.toString()),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            backgroundImage:
                                NetworkImage(user.image.toString()),
                            child: const Icon(Icons.person),
                          ),
                          onTap: () {
                            // Chatroom chatroom=Chatroom().fromMap(querySnapshot.docs[item].data()as Map);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return Chat(
                                  ricever: user,
                                  senderUid: currentUser,
                                  chatroom: chatroom.chatroom!);
                            }));
                          },
                        );
                      } else {
                        return const Text('No friend Found ');
                      }
                    }):Card();
              },
            );
          } else {
            return const Text('No Friend Found');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return Search();
          }));
        },
      ),
    );
  }
}
