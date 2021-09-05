import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/constants/common_size.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return ListView.separated(
          padding: EdgeInsets.all(common_padding),
          separatorBuilder: (context, index) {
            return Divider(
              height: common_padding * 2 + 1,
              thickness: 1,
              color: Colors.grey[200],
              indent: common_sm_padding,
              endIndent: common_sm_padding,
            );
          },
          itemBuilder: (context, index) {
            return SizedBox(
              height: imgSize,
              child: Row(
                children: [
                  SizedBox(
                      height: imgSize,
                      width: imgSize,
                      child: ExtendedImage.network(
                        'https://picsum.photos/100',
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      )),
                  SizedBox(
                    width: common_sm_padding,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'work',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        '53일전',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text('5000원'),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 14,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.chat_bubble_2,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '23',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(
                                    CupertinoIcons.heart,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '30',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            );
          },
          itemCount: 10,
        );
      },
    );
  }
}
