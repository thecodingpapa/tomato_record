import 'package:cloud_firestore/cloud_firestore.dart';

/// user_key : ""
/// msg : "  "
/// msg_time : "2012-04-21T18:25:43-05:00"

class ChatModel {
  late String chatKey;
  late String userKey;
  late String msg;
  late DateTime createdDate;
  DocumentReference? reference;

  ChatModel(
      {required this.chatKey,
      required this.userKey,
      required this.msg,
      required this.createdDate,
      this.reference});

  ChatModel.fromJson(Map<String, dynamic> json, this.chatKey, this.reference) {
    userKey = json['userKey'] ?? "";
    msg = json['msg'] ?? "";
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userKey'] = userKey;
    map['msg'] = msg;
    map['createdDate'] = createdDate;
    return map;
  }

  ChatModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
}
