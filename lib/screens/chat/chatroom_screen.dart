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
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.yellowAccent,
            )),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey,
                    )),
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                      hintText: '메세지를 입력하세요.',
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          print('icon clicked');
                        },
                        child: Icon(Icons.emoji_emotions_outlined,
                            color: Colors.grey),
                      ),
                      suffixIconConstraints: BoxConstraints.tight(Size(40, 40)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey))),
                )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: Colors.grey,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
