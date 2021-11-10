/// user_key : ""
/// msg : "  "
/// msg_time : "2012-04-21T18:25:43-05:00"

class ChatModel {
  String? userKey;
  String? msg;
  String? msgTime;

  ChatModel({
      this.userKey, 
      this.msg, 
      this.msgTime});

  ChatModel.fromJson(dynamic json) {
    userKey = json['user_key'];
    msg = json['msg'];
    msgTime = json['msg_time'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['user_key'] = userKey;
    map['msg'] = msg;
    map['msg_time'] = msgTime;
    return map;
  }

}