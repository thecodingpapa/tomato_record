import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/data/chat_model.dart';
import 'package:tomato_record/data/chatroom_model.dart';
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
  late ChatsNotifier _chatsNotifier;

  @override
  void initState() {
    _chatsNotifier = ChatsNotifier(widget.chatroomKey);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User _user = context.read<UserNotifier>().user!;
    return ChangeNotifierProvider<ChatsNotifier>.value(
      value: _chatsNotifier,
      child: Consumer<ChatsNotifier>(
        builder: (context, chatsNotifier, child) {
          Size _size = MediaQuery.of(context).size;

          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Text('Seller name'),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.call_outlined))
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildBanner(context),
                  Expanded(
                    child: (chatsNotifier.chats.isEmpty)
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            color: Colors.white,
                            child: NotificationListener<ScrollEndNotification>(
                              onNotification: (scrollEnd) {
                                var metrics = scrollEnd.metrics;
                                if (metrics.atEdge) {
                                  if (metrics.pixels == 0)
                                    print('At top');
                                  else {
                                    chatsNotifier.fetchMoreChats();
                                  }
                                }
                                return true;
                              },
                              child: ListView.separated(
                                physics: ClampingScrollPhysics(),
                                reverse: true,
                                padding: EdgeInsets.all(16),
                                itemBuilder: (context, index) {
                                  ChatModel chat = chatsNotifier.chats[index];
                                  return Chat(chat,
                                      size: _size,
                                      isMe: chat.userKey == _user.uid);
                                },
                                itemCount: chatsNotifier.chats.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 12,
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                  _buildInputBar(context)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TextEditingController _textEditingController = TextEditingController();

  Container _buildInputBar(BuildContext context) {
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

                  _textEditingController.clear();
                  _chatsNotifier.addChat(chat);
                }
              },
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return MaterialBanner(
      leadingPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      actions: [Container()],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(right: 0, left: 16),
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
