class Fuser {
  String? name;
  String? uid;
  String? email;
  String? image;

  Fuser({this.email, this.uid, this.name, this.image});

  Map<String, Object> toMap() {
    return {'name': name!, 'uid': uid!, 'email': email!, 'image': image!};
  }
  Fuser fromMap(Map map){
    return Fuser(email: map['email'],name: map['name'],uid: map['uid'],image: map['image']);
  }
}
