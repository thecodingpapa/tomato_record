import 'package:flutter/material.dart';
import 'package:tomato_record/states/category_notifier.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

class CategoryInputScreen extends StatelessWidget {
  const CategoryInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '카테고리 선택',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  context.read<CategoryNotifier>().setNewCategoryWithKor(
                      categoriesMapEngToKor.values.elementAt(index));
                  Beamer.of(context).beamBack();
                },
                title: Text(
                  categoriesMapEngToKor.values.elementAt(index),
                  style: TextStyle(
                      color: context
                                  .read<CategoryNotifier>()
                                  .currentCategoryInKor ==
                              categoriesMapEngToKor.values.elementAt(index)
                          ? Theme.of(context).primaryColor
                          : Colors.black87),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[300],
              );
            },
            itemCount: categoriesMapEngToKor.length));
  }
}
