import 'package:flutter/material.dart';

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
                title: Text(categoriesKor[index]),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[300],
              );
            },
            itemCount: categoriesKor.length));
  }
}

const List<String> categoriesKor = [
  '선택',
  '가구',
  '전자기기',
  '유아동',
  '스포츠',
  '여성',
  '남성',
  '메이크업',
];
