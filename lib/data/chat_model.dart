import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato_record/constants/data_keys.dart';

/// chatKey : ""
/// msg : ""
/// createdDate : ""
/// userKey : ""
/// reference : ""

class ChatModel {
  late String chatKey;
  late String msg;
  late String createdDate;
  late String userKey;
  DocumentReference? reference;

  ChatModel(
      {required this.chatKey,
      required this.msg,
      required this.createdDate,
      required this.userKey,
      this.reference});

  ChatModel.fromJson(Map<String, dynamic> json, this.chatKey, this.reference) {
    msg = json[DOC_MSG];
    createdDate = json[DOC_CREATEDDATE];
    userKey = json[DOC_USERKEY];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_MSG] = msg;
    map[DOC_CREATEDDATE] = createdDate;
    map[DOC_USERKEY] = userKey;
    return map;
  }

  ChatModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
}
