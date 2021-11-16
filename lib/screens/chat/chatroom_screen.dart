import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/data/chat_model.dart';
import 'package:tomato_record/data/chatroom_model.dart';
import 'package:tomato_record/repo/chat_service.dart';
import 'package:tomato_record/screens/chat/chat.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;
  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatroomScreenState createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  List<ChatModel> chats = [];
  String latestMsg = "";

  @override
  Widget build(BuildContext context) {
    User _user = context.read<UserNotifier>().user!;
    return StreamProvider<ChatroomModel?>(
      create: (context) => ChatService().connectToChatroom(widget.chatroomKey),
      initialData: null,
      child: Consumer<ChatroomModel?>(
        builder: (context, chatroom, child) {
          Size _size = MediaQuery.of(context).size;

          if (chatroom != null) latestMsg = chatroom.lastMsg!;

          if (chats.isEmpty) {
            ChatService().getLatestChats(widget.chatroomKey).then((value) {
              chats.addAll(value);
              latestMsg = chats[0].msg;
              setState(() {});
            });
          } else {
            if (latestMsg != chats[0].msg) {
              ChatService()
                  .getFrontChats(chats[0].reference!, widget.chatroomKey)
                  .then((value) {
                chats.insertAll(0, value);
                latestMsg = chats[0].msg;
                setState(() {});
              });
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Seller name'),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.call_outlined))
              ],
            ),
            body: Column(
              children: [
                _buildBanner(context),
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      ChatModel chat = chats[index];
                      return Chat(chat,
                          size: _size, isMe: chat.userKey == _user.uid);
                    },
                    itemCount: chats.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                  ),
                ),
                _buildInputBar(context, chatroom)
              ],
            ),
          );
        },
      ),
    );
  }

  TextEditingController _textEditingController = TextEditingController();

  Container _buildInputBar(BuildContext context, ChatroomModel? chatroomModel) {
    return Container(
      height: 48,
      color: Colors.grey[300],
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          Expanded(
              child: TextFormField(
            controller: _textEditingController,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: '메시지를 입력하세요.',
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey)),
              fillColor: Colors.white,
              filled: true,
            ),
          )),
          IconButton(
              onPressed: () async {
                String text = _textEditingController.text;
                if (text.trim().isNotEmpty) {
                  ChatModel chat = ChatModel(
                    chatKey: '',
                    userKey: context.read<UserNotifier>().user!.uid,
                    msg: text,
                    createdDate: DateTime.now().toUtc(),
                  );
                  await ChatService().createNewChat(
                      widget.chatroomKey,
                      chatroomModel == null ? 0 : chatroomModel.numOfChats,
                      chat);
                  _textEditingController.clear();
                }
              },
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black45,
            offset: Offset.zero,
            blurRadius: 1.0,
            spreadRadius: 1.0)
      ], color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: ExtendedImage.network(
              'https://randomuser.me/api/portraits/women/11.jpg',
              fit: BoxFit.cover,
            ),
            title: RichText(
              text: TextSpan(
                text: '거래완료 ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                    text: '이케아 소르테라 분리수거함 5개',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            subtitle: RichText(
              text: TextSpan(
                text: '30,000원 ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                    text: '(가격제안불가)',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w100, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: SizedBox(
              height: 36,
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  size: 18,
                ),
                label: Text('후기 남기기'),
                style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.grey[300]!, width: 1))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
