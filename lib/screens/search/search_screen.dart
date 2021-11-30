import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[200]!));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: Container(
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    filled: true,
                    hintText: '아이템 검색',
                    border: borderStyle,
                    focusedBorder: borderStyle),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile();
          },
          separatorBuilder: (context, index) {
            return Container();
          },
          itemCount: 30),
    );
  }
}
