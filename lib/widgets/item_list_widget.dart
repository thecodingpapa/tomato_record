import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/item_model.dart';
import 'package:tomato_record/router/locations.dart';

class ItemListWidget extends StatelessWidget {
  final ItemModel item;
  double? imgSize;
  ItemListWidget(this.item, {Key? key, this.imgSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imgSize == null) {
      Size size = MediaQuery.of(context).size;
      imgSize = size.width / 4;
    }

    return InkWell(
      onTap: () {
        BeamState beamState = Beamer.of(context).currentConfiguration!;
        String current = beamState.uri.toString();
        String newPath = (current == '/')
            ? '/$LOCATION_ITEM/${item.itemKey}'
            : '$current/${item.itemKey}';

        context.beamToNamed(newPath);
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [
            SizedBox(
                height: imgSize,
                width: imgSize,
                child: ExtendedImage.network(
                  item.imageDownloadUrls[0],
                  fit: BoxFit.cover,
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
                  item.title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  '53일전',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text('${item.price.toString()}원'),
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
      ),
    );
  }
}
