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
      appBar: AppBar(),
      body: Container(child: Center(child: Text(widget.chatroomKey))),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            Expanded(child: TextFormField()),
            IconButton(onPressed: () {}, icon: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}
