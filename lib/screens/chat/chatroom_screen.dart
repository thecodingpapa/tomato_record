import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;
  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatroomScreenState createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller name'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call_outlined))
        ],
      ),
      body: Column(
        children: [
          Card(
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
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
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(child: Center(child: Text(widget.chatroomKey))),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            Expanded(
                child: TextFormField(
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
            IconButton(onPressed: () {}, icon: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}
