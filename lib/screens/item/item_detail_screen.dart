import 'package:beamer/beamer.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/chatroom_model.dart';
import 'package:tomato_record/data/item_model.dart';
import 'package:tomato_record/data/user_model.dart';
import 'package:tomato_record/repo/chat_service.dart';
import 'package:tomato_record/repo/item_service.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/item/similar_item.dart';
import 'package:tomato_record/states/category_notifier.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/utils/time_calculation.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;
  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;
  Widget _textGap = SizedBox(
    height: common_padding,
  );
  Widget _divider = Divider(
    height: common_padding * 2 + 2,
    thickness: 2,
    color: Colors.grey[200],
  );
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null || _statusBarHeight == null) return;
      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToChatroom(ItemModel itemModel, UserModel userModel) async {
    String chatroomKey =
        ChatroomModel.generateChatRoomKey(userModel.userKey, widget.itemKey);

    ChatroomModel _chatroomModel = ChatroomModel(
        lastMsgTime: DateTime.now(),
        itemImage: itemModel.imageDownloadUrls[0],
        itemTitle: itemModel.title,
        itemKey: widget.itemKey,
        itemAddress: itemModel.address,
        itemPrice: itemModel.price,
        sellerKey: itemModel.userKey,
        buyerKey: userModel.userKey,
        sellerImage:
            "https://minimaltoolkit.com/images/randomdata/male/101.jpg",
        buyerImage:
            'https://minimaltoolkit.com/images/randomdata/female/41.jpg',
        geoFirePoint: itemModel.geoFirePoint,
        chatroomKey: chatroomKey);

    await ChatService().createNewChatroom(_chatroomModel);

    BeamState beamState = Beamer.of(context).currentConfiguration!;
    String current = beamState.uri.toString();
    String newPath =
        (current == '/') ? '/$chatroomKey' : '$current/$chatroomKey';
    context.beamToNamed(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            UserModel userModel = context.read<UserNotifier>().userModel!;
            return LayoutBuilder(
              builder: (context, constraints) {
                _size = MediaQuery.of(context).size;
                _statusBarHeight = MediaQuery.of(context).padding.top;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      bottomNavigationBar: SafeArea(
                        top: false,
                        bottom: true,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey[300]!))),
                          child: Padding(
                            padding: const EdgeInsets.all(common_sm_padding),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                  width: common_sm_padding * 2 + 1,
                                  indent: common_sm_padding,
                                  endIndent: common_sm_padding,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '4000원',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      '가격제안불가',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _goToChatroom(itemModel, userModel);
                                    },
                                    child: Text('채팅으로 거래하기'))
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          _imagesAppBar(itemModel),
                          SliverPadding(
                            padding: EdgeInsets.all(common_padding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              _userSection(userModel),
                              _divider,
                              Text(
                                itemModel.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              _textGap,
                              Row(
                                children: [
                                  Text(
                                    categoriesMapEngToKor[itemModel.category] ??
                                        "선택",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                  Text(
                                    ' · ${TimeCalculation.getTimeDiff(itemModel.createdDate)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              _textGap,
                              Text(
                                itemModel.detail,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              _textGap,
                              Text(
                                '조회 33',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              _textGap,
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '이 게시글 신고하기',
                                      ))),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                            ])),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${userModel.phoneNumber.substring(9)}님의 판매 상품',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                    width: _size!.width / 4,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '더보기',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button!
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: FutureBuilder<List<ItemModel>>(
                              future: ItemService().getUserItems(
                                  userModel.userKey,
                                  itemKey: itemModel.itemKey),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: EdgeInsets.all(common_sm_padding),
                                    child: GridView.count(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: common_sm_padding),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: common_sm_padding,
                                      crossAxisSpacing: common_sm_padding,
                                      childAspectRatio: 6 / 7,
                                      children: List.generate(
                                          snapshot.data!.length,
                                          (index) => SimilarItem(
                                              snapshot.data![index])),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Container(
                        height: kToolbarHeight + _statusBarHeight!,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.transparent
                            ])),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          shadowColor: Colors.transparent,
                          backgroundColor: isAppbarCollapsed
                              ? Colors.white
                              : Colors.transparent,
                          foregroundColor:
                              isAppbarCollapsed ? Colors.black87 : Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        });
  }

  SliverAppBar _imagesAppBar(ItemModel itemModel) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: SizedBox(
          child: SmoothPageIndicator(
              controller: _pageController, // PageController
              count: itemModel.imageDownloadUrls.length,
              effect: WormEffect(
                  dotColor: Colors.white24,
                  activeDotColor: Colors.white,
                  radius: 2,
                  dotHeight: 4,
                  dotWidth: 4), // yo// ur preferred effect
              onDotClicked: (index) {}),
        ),
        centerTitle: true,
        background: PageView.builder(
          controller: _pageController,
          allowImplicitScrolling: true,
          itemBuilder: (context, index) {
            return ExtendedImage.network(
              itemModel.imageDownloadUrls[index],
              fit: BoxFit.cover,
              scale: 0.1,
            );
          },
          itemCount: itemModel.imageDownloadUrls.length,
        ),
      ),
    );
  }

  Widget _userSection(UserModel userModel) {
    return Row(
      children: [
        ExtendedImage.network(
          'https://picsum.photos/50',
          fit: BoxFit.cover,
          width: _size!.width / 10,
          height: _size!.width / 10,
          shape: BoxShape.circle,
        ),
        SizedBox(
          width: common_sm_padding,
        ),
        SizedBox(
          height: _size!.width / 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userModel.phoneNumber.substring(9), //+821055555555
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                userModel.address,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FittedBox(
                        child: Text(
                          '37.3°C',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: LinearProgressIndicator(
                          color: Colors.blueAccent,
                          value: 0.373,
                          minHeight: 3,
                          backgroundColor: Colors.grey[200],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                ImageIcon(
                  ExtendedAssetImageProvider('assets/imgs/happiness.png'),
                  color: Colors.blueAccent,
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              '매너온도',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
      ],
    );
  }
}
