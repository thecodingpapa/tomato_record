import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:tomato_record/data/chatroom_model.dart';
import 'package:tomato_record/repo/chat_service.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:beamer/beamer.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String _getOthersName(String myKey, ChatroomModel chatroomModel) {
    if (chatroomModel.buyerKey == myKey)
      return chatroomModel.sellerKey;
    else
      return chatroomModel.buyerKey;
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = context.read<UserNotifier>();
    return Scaffold(
      body: FutureBuilder<List<ChatroomModel>>(
          future: ChatService().getChatrooms(userNotifier.user!.uid),
          builder: (context, snapshot) {
            return ListView.separated(
              itemCount: snapshot.hasData ? snapshot.data!.length : 0,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                  indent: 4,
                  endIndent: 4,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                ChatroomModel chatroomModel = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    context.beamToNamed(
                        '/$LOCATION_CHATROOM/${chatroomModel.chatroomKey}');
                  },
                  leading: ExtendedImage.network(
                    'https://randomuser.me/api/portraits/women/13.jpg',
                    fit: BoxFit.cover,
                    shape: BoxShape.circle,
                  ),
                  trailing: ExtendedImage.network(
                    chatroomModel.itemImage ?? 'https://picsum.photos/50',
                    fit: BoxFit.cover,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text:
                          _getOthersName(userNotifier.user!.uid, chatroomModel),
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        TextSpan(
                            text: ' 대방동·11월6일',
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                  ),
                  subtitle: Text(
                    chatroomModel.lastMsg ?? "",
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          }),
    );
  }
}
