import 'package:flutter/material.dart';
import 'package:tomato_record/data/item_model.dart';
import 'package:tomato_record/repo/algolia_service.dart';
import 'package:beamer/beamer.dart';
import 'package:tomato_record/widgets/item_list_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[200]!));

  final TextEditingController _textEditingController = TextEditingController();

  final List<ItemModel> items = [];

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
                controller: _textEditingController,
                onFieldSubmitted: (value) async {
                  List<ItemModel> newItems =
                      await AlgoliaService().queryItems(value);
                  if (newItems.isNotEmpty) {
                    items.addAll(newItems);
                  }
                  print('${items.toString()}');
                  setState(() {});
                },
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    filled: true,
                    hintText: '아이템 검색',
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            ItemModel item = items[index];
            Size size = MediaQuery.of(context).size;
            return ItemListWidget(item, imgSize: size.width / 4);
          },
          separatorBuilder: (context, index) {
            return Container();
          },
          itemCount: items.length),
    );
  }
}
