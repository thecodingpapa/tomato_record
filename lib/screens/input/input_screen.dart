import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/item_model.dart';
import 'package:tomato_record/repo/image_storage.dart';
import 'package:tomato_record/repo/item_service.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/input/multi_image_select.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/states/category_notifier.dart';
import 'package:tomato_record/states/select_image_notifier.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:tomato_record/utils/logger.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  bool _suggestPriceSelected = false;

  TextEditingController _priceController = TextEditingController();
  var _border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  var _divider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[350],
    indent: common_padding,
    endIndent: common_padding,
  );

  bool isCreatingItem = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String itemKey = ItemModel.generateItemKey(userKey);

    List<Uint8List> images = context.read<SelectImageNotifier>().images;

    UserNotifier userNotifier = context.read<UserNotifier>();

    if (userNotifier.userModel == null) return;

    List<String> downloadUrls =
        await ImageStorage.uploadImages(images, itemKey);

    final num? price = num.tryParse(
        _priceController.text.replaceAll('.', '').replaceAll('원', ''));

    ItemModel itemModel = ItemModel(
      itemKey: itemKey,
      userKey: userKey,
      imageDownloadUrls: downloadUrls,
      title: _titleController.text,
      category: context.read<CategoryNotifier>().currentCategoryInEng,
      price: price ?? 0,
      negotiable: _suggestPriceSelected,
      detail: _detailController.text,
      address: userNotifier.userModel!.address,
      geoFirePoint: userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
    );

    logger.d('upload finished - ${downloadUrls.toString()}');

    await ItemService().createNewItem(itemModel.toJson(), itemKey);
    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              leading: TextButton(
                  onPressed: () {
                    context.beamBack();
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black87,
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor),
                  child: Text(
                    '뒤로',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 2),
                child: isCreatingItem
                    ? LinearProgressIndicator(
                        minHeight: 2,
                      )
                    : Container(),
              ),
              title: Text(
                '중고거래 글쓰기',
                style: Theme.of(context).textTheme.headline6,
              ),
              actions: [
                TextButton(
                    onPressed: attemptCreateItem,
                    style: TextButton.styleFrom(
                        primary: Colors.black87,
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor),
                    child: Text(
                      '완료',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
              ],
            ),
            body: ListView(
              children: [
                MultiImageSelect(),
                _divider,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      hintText: '글 제목',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border),
                ),
                _divider,
                ListTile(
                  onTap: () {
                    context.beamToNamed(
                        '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT');
                  },
                  dense: true,
                  title: Text(
                      context.watch<CategoryNotifier>().currentCategoryInKor),
                  trailing: Icon(Icons.navigate_next),
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: common_padding),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        onChanged: (value) {
                          if (value == '0원') {
                            _priceController.clear();
                          }

                          setState(() {});
                        },
                        inputFormatters: [
                          MoneyInputFormatter(
                              mantissaLength: 0, trailingSymbol: '원')
                        ],
                        decoration: InputDecoration(
                            hintText: '얼마에 파시겠어요?',
                            prefixIcon: ImageIcon(
                              ExtendedAssetImageProvider('assets/imgs/won.png'),
                              color: (_priceController.text.isEmpty)
                                  ? Colors.grey[350]
                                  : Colors.black87,
                            ),
                            prefixIconConstraints: BoxConstraints(maxWidth: 20),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: common_sm_padding),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    )),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _suggestPriceSelected = !_suggestPriceSelected;
                        });
                      },
                      icon: Icon(
                        _suggestPriceSelected
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: _suggestPriceSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      label: Text('가격제안 받기',
                          style: TextStyle(
                              color: _suggestPriceSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54)),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.black45),
                    )
                  ],
                ),
                _divider,
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: '올릴 게시글 내용을 작성해주세요.',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
