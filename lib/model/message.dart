class Message {
  String? message;
  String? sender;
  DateTime dateTime=DateTime.now();
  Message({this.message, this.sender});
  Message toMap(Map map){
    return Message(message: map['message'], sender: map['sender']);
  }
  Map<String,Object> fromMap(){
    return {'message':message!,'sender':sender!,
      'date':dateTime
    };
  }
}
