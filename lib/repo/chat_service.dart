import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato_record/constants/data_keys.dart';
import 'package:tomato_record/data/chat_model.dart';
import 'package:tomato_record/data/chatroom_model.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  Future createNewChatRoom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(
            ChatroomModel.generateChatRoomKey(
                chatroomModel.buyerKey, chatroomModel.itemKey));

    chatroomDocReference.set(chatroomModel.toJson());
  }

  Future createNewChat(String chatroomKey, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> chatDocReference = FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .doc();

    chatDocReference.set(chatModel.toJson());
  }

  Future<ChatroomModel> getChatroomDetail(String chatroomKey) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await chatroomDocReference.get();
    ChatroomModel chatroomModel = ChatroomModel.fromSnapshot(documentSnapshot);
    return chatroomModel;
  }

  Stream<List<ChatModel>> connectToChat(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(100)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<ChatModel>>.fromHandlers(handleData: (snapshot, sink) async {
      List<ChatModel> chats = [];

      snapshot.docs.forEach((documentSnapshot) {
        chats.add(ChatModel.fromSnapshot(documentSnapshot));
      });

      sink.add(chats);
    }));
  }

  // Future<List<ChatroomModel>> getChatrooms() async {
  //   FirebaseFirestore.instance.collection(COL_CHATROOMS).orderBy(field)
  // }
  //
  // Future<List<ChatModel>> getLatestChat() async {
  //
  // }
}
