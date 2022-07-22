import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/chatroom.dart';

class ManageChat with ChangeNotifier {
  List<Chatroom> chatrooms = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  void getChatrooms()  {
    //todo is this approach correct
    firebaseFirestore.collection('chatroom').snapshots().listen((event) {
      chatrooms=[];
      for (QueryDocumentSnapshot element in event.docs) {
        chatrooms.add(Chatroom().fromMap(element.data()as Map));
      }
    });
    print('change chatroom as well');
    notifyListeners();
  }
  //todo how can we get message collection changes
  void getMessages(){
    firebaseFirestore.collection('chatroom').doc('VJxI8Og1TReNCpQi1Ox1GFU2fhM2WrZ6xvqfiQSKXhu3B29fk1kDCW63').collection('message').snapshots().listen((event) {
      print('change something ------------------------');
    });
  }
}
