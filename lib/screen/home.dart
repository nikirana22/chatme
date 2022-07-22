import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/User.dart';
import '../model/chatroom.dart';
import '../screen/chat.dart';
import '../screen/login.dart';
import '../screen/search.dart';

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
          },icon:const Icon(Icons.logout))
        ],
      ),

      /* todo :->  change login from here
      todo :->   this logic is looking so bad
      todo :->   how can we make this condition :->
  todo          if(currentuser.uid==sender  ||  currentuser.uid == reciver)

       */

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
              itemBuilder: (_, index) {
                Chatroom chatroom =
                    Chatroom().fromMap(querySnapshot.docs[index].data() as Map);
                String? findusertype;
                if (currentUser ==
                    chatroom.senderUid) {
                  findusertype = chatroom.reciverUid ;
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
                      }
                      else if(snap.connectionState==ConnectionState.waiting){
                        return Container(color: Colors.black12,child:const Center(
                          child: CircularProgressIndicator(),
                        ),);
                      }
                      else if(snap.hasError){
                        return  Text('error occured ${snap.error} ');

                      }
                      else {
                        return const Text('something is happining wrong');
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
            return const  Search();
          }));
        },
      ),
    );
  }
}
