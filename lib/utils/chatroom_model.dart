class ChatRoomModel {
  String? uid;
  String? lastMsg;
  String? message;
  DateTime? time;
  String? targetid;

  ChatRoomModel(
      {this.uid, this.message, this.time, this.lastMsg, this.targetid});
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    uid = map['id'];
    message = map['message'];
    time = map['time'];
    lastMsg = map['lastMsg'];
    targetid = map['targetid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'message': message,
      'time': time,
      'lastMsg': lastMsg,
      'targetid': targetid
    };
  }
}
