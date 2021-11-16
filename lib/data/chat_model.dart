import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_record/constants/data_keys.dart';
import 'package:tomato_record/data/chatroom_model.dart';
import 'package:tomato_record/repo/chat_service.dart';

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
    userKey = json[DOC_USERKEY] ?? "";
    msg = json[DOC_MSG] ?? "";
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_MSG] = msg;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  ChatModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
}

class ChatsNotifier extends ChangeNotifier {
  final List<ChatModel> _chats = [];
  late ChatroomModel _chatroomModel;
  StreamSubscription? _chatroomUpdate;
  final String _chatroomKey;

  String latestMsg = "";

  ChatsNotifier(this._chatroomKey) {
    this._chatroomUpdate =
        ChatService().connectToChatroom(_chatroomKey).listen((chatroom) {
      this._chatroomModel = chatroom!;

      if (this._chats.isEmpty) {
        ChatService().getLatestChats(_chatroomKey).then((value) {
          this._chats.addAll(value);
          this.latestMsg = this._chats[0].msg;
          notifyListeners();
        });
      } else {
        if (latestMsg != this._chats[0].msg) {
          ChatService()
              .getFrontChats(this._chats[0].reference!, _chatroomKey)
              .then((value) {
            this._chats.insertAll(0, value);
            this.latestMsg = this._chats[0].msg;
            notifyListeners();
          });
        }
      }
    });
  }

  void fetchMoreChats() {
    ChatService()
        .getNextChats(this._chats.last.reference!, _chatroomKey)
        .then((value) {
      this._chats.addAll(value);
      latestMsg = this._chats[0].msg;
      notifyListeners();
    });
  }

  void addChat(ChatModel newChatModel) {
    //set on memory
    this._chats.insert(0, newChatModel);
    latestMsg = newChatModel.msg;

    //upload to firestore
    ChatService().createNewChat(_chatroomKey, newChatModel);

    notifyListeners();
  }

  ChatroomModel get chatroom => _chatroomModel;

  List<ChatModel> get chats => _chats;

  Future dispose() async {
    _chatroomUpdate!.cancel();
    _chatroomUpdate = null;
  }
}
