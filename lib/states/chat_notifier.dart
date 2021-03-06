import 'package:flutter/foundation.dart';
import 'package:tomato_record/data/chat_model.dart';
import 'package:tomato_record/data/chatroom_model.dart';
import 'package:tomato_record/repo/chat_service.dart';

class ChatNotifier extends ChangeNotifier {
  ChatroomModel? _chatroomModel;
  List<ChatModel> _chatList = [];
  final String _chatroomKey;

  ChatNotifier(this._chatroomKey) {
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      this._chatroomModel = chatroomModel;

      if (this._chatList.isEmpty) {
        ChatService().getChatList(_chatroomKey).then((chatList) {
          _chatList.addAll(chatList);
          notifyListeners();
        });
      } else {
        if (this._chatList[0].reference == null) this._chatList.removeAt(0);
        ChatService()
            .getLatestChats(_chatroomKey, this._chatList[0].reference!)
            .then((latestChats) {
          this._chatList.insertAll(0, latestChats);
          notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel chatModel) {
    _chatList.insert(0, chatModel);
    notifyListeners();

    ChatService().createNewChat(_chatroomKey, chatModel);
  }

  List<ChatModel> get chatList => _chatList;

  ChatroomModel? get chatroomModel => _chatroomModel;

  String get chatroomKey => _chatroomKey;
}
