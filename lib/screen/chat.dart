import 'package:chatme/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/User.dart';

Uuid uuid =  Uuid();

class Chat extends StatelessWidget {
  Fuser ricever;
  String senderUid;
  String chatroom;
  TextEditingController message = TextEditingController();

  Chat(
      {required this.ricever,
      required this.senderUid,
      required this.chatroom,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(118, 125, 232, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(78, 85, 194, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(ricever.image.toString()),),
            const SizedBox(width: 15,),
            Text(ricever.name.toString()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(chatroom)
                    .collection('message').orderBy('date',descending: true)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    // Message me=Message().toMap(snapshot.data as Map);
                    QuerySnapshot a = snapshot.data as QuerySnapshot;
                    return Container(
                      // color:         const Color.fromRGBO(118, 125, 232, 1),
                      height: height * 0.79,
                      // color: Colors.yellowAccent,
                      child: ListView.builder(
                          reverse: true,
                          itemCount: a.size,
                          itemBuilder: (_, index) {
                            Message me =
                                Message().toMap(a.docs[index].data() as Map);
                            return Align(
                                alignment: me.sender == senderUid
                                    ? Alignment.bottomRight
                                    : Alignment.bottomLeft,
                                child: Container(
                                    constraints:
                                        BoxConstraints(maxWidth: width * 0.8),
                                    margin: const EdgeInsets.all(8),
                                    padding:const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: me.sender == senderUid
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    child: Text(me.message.toString())));
                          }),
                    );
                  } else if (!snapshot.hasData) {
                    print(
                        'else statement in Chat class-------------------------->');
                    return const Text('say hiii to your friend');
                  }
                  return Text('');
                }),
            Container(
              // color: Colors.black,
              height: height * 0.1,
              padding:const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: width * 0.75,
                    height: height * 0.07,
                    // margin:const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      // readOnly: true,
                      controller: message,
                      // controller: ,
                      decoration: const InputDecoration(
                          hintText: 'enter your message',
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                      iconSize: 50,
                      onPressed: () {
                        Message ms =
                            Message(message: message.text, sender: senderUid);
                        message.text = '';
                        FirebaseFirestore.instance
                            .collection('chatroom')
                            .doc(chatroom)
                            .collection('message')
                            .doc(uuid.v1())
                            .set(ms.fromMap());
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Color.fromRGBO(77, 84, 194, 1.0),
                        radius: 40,
                        child: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
            // Container(
            //   child: ,
            // )
          ],
        ),
      ),
    );
  }
}
