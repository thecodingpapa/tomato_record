import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 10,
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
          return ListTile(
            leading: ExtendedImage.network(
              'https://randomuser.me/api/portraits/women/13.jpg',
              fit: BoxFit.cover,
              shape: BoxShape.circle,
            ),
            trailing: ExtendedImage.network(
              'https://picsum.photos/50',
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
            ),
            title: RichText(
              text: TextSpan(
                text: '바나나챠챠',
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                      text: ' 대방동·11월6일',
                      style: Theme.of(context).textTheme.bodyText2)
                ],
              ),
            ),
            subtitle: Text(
              '양원준님이 유재님의 ㅌ은행에 이체하였습니다!!',
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}
