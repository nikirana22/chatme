class Chatroom {
  String? senderUid;
  String? reciverUid;
  String? message;
  String? chatroom;

  Chatroom({this.senderUid, this.reciverUid, this.message,  this.chatroom});

  Map<String, Object> toMap() {
    return {
      'senderUid': senderUid!,
      'reciverUid': reciverUid!,
      'message': message!,
      'chatroom': chatroom!
    };
  }

  Chatroom fromMap(Map map) {
    return Chatroom(
        senderUid: map['senderUid'],
        reciverUid: map['reciverUid'],
        message: map['message'],chatroom: map['chatroom']);
  }
}
