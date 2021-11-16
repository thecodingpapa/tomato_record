import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato_record/constants/data_keys.dart';
import 'package:tomato_record/data/chat_model.dart';
import 'package:tomato_record/data/chatroom_model.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  Future<bool> isChatroomExist(String chatroomKey) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    return (await chatroomDocReference.get()).exists;
  }

  Future createNewChatRoom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(
            ChatroomModel.generateChatRoomKey(
                chatroomModel.buyerKey, chatroomModel.itemKey));

    chatroomDocReference.set(chatroomModel.toJson());
  }

  Future createNewChat(
      String chatroomKey, num numOfChats, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    DocumentReference<Map<String, dynamic>> chatDocReference = FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(chatDocReference, chatModel.toJson());
      transaction.update(chatroomDocReference, {
        DOC_NUMOFCHAT: numOfChats++,
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGUSERKEY: chatModel.userKey,
        DOC_LASTMSGTIME: chatModel.createdDate
      });
    });
  }

  Future<ChatroomModel> getChatroomDetail(String chatroomKey) async {
    DocumentReference<Map<String, dynamic>> chatroomDocReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await chatroomDocReference.get();
    ChatroomModel chatroomModel = ChatroomModel.fromSnapshot(documentSnapshot);
    return chatroomModel;
  }

  Stream<ChatroomModel?> connectToChatroom(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
            ChatroomModel>.fromHandlers(handleData: (snapshot, sink) async {
      sink.add(ChatroomModel.fromSnapshot(snapshot));
    }));
  }

  Stream<List<ChatModel>> connectToChat(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
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

  Future<List<ChatModel>> getLatestChats(String chatroomKey) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel> chats = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      chats.add(ChatModel.fromSnapshot(documentSnapshot));
    });

    return chats;
  }

  Future<List<ChatModel>> getFrontChats(
      DocumentReference currentLatest, String chatroomKey) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final DocumentSnapshot currentLatestSnapshot = await currentLatest.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .endAtDocument(currentLatestSnapshot)
        .get();

    List<ChatModel> chats = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      chats.add(ChatModel.fromSnapshot(documentSnapshot));
    });

    return chats;
  }

  Future<List<ChatModel>> getNextChats(
      DocumentReference currentLast, String chatroomKey) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final DocumentSnapshot currentLastSnapshot = await currentLast.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .startAfterDocument(currentLastSnapshot)
        .limit(10)
        .get();

    List<ChatModel> chats = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      chats.add(ChatModel.fromSnapshot(documentSnapshot));
    });

    return chats;
  }

  // Future<List<ChatroomModel>> getChatrooms() async {
  //   FirebaseFirestore.instance.collection(COL_CHATROOMS).orderBy(field)
  // }
  //
  // Future<List<ChatModel>> getLatestChat() async {
  //
  // }
}
