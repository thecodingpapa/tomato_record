import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

/// item_image : ""
/// item_title : ""
/// item_key : ""
/// item_address : ""
/// item_position : ""
/// item_price : 123.123
/// seller_key : "asdf"
/// buyer_key : "asdf"
/// seller_image : "asdf"
/// buyer_image : "asdf"
/// geo_fire_point : " "
/// last_msg : "bla bla bla"
/// last_msg_time : "2012-04-21T18:25:43-05:00"
/// last_msg_user_key : ""
/// chatroom_key : ""

class ChatroomModel {
  late String itemImage;
  late String itemTitle;
  late String itemKey;
  late String itemAddress;
  late String itemPosition;
  late num itemPrice;
  late String sellerKey;
  late String buyerKey;
  late String sellerImage;
  late String buyerImage;
  late GeoFirePoint geoFirePoint;
  late String lastMsg;
  late DateTime lastMsgTime;
  late String lastMsgUserKey;
  late String chatroomKey;
  DocumentReference? reference;

  ChatroomModel(
      {required this.itemImage,
      required this.itemTitle,
      required this.itemKey,
      required this.itemAddress,
      required this.itemPosition,
      required this.itemPrice,
      required this.sellerKey,
      required this.buyerKey,
      required this.sellerImage,
      required this.buyerImage,
      required this.geoFirePoint,
      required this.lastMsg,
      required this.lastMsgTime,
      required this.lastMsgUserKey,
      required this.chatroomKey,
      this.reference});

  ChatroomModel.fromJson(
      Map<String, dynamic> json, this.chatroomKey, this.reference) {
    itemImage = json['itemImage'] ?? "";
    itemTitle = json['itemTitle'] ?? "";
    itemKey = json['itemKey'] ?? "";
    itemAddress = json['itemAddress'] ?? "";
    itemPosition = json['itemPosition'] ?? "";
    itemPrice = json['itemPrice'] ?? 0;
    sellerKey = json['sellerKey'] ?? "";
    buyerKey = json['buyerKey'] ?? "";
    sellerImage = json['sellerImage'] ?? "";
    buyerImage = json['buyerImage'] ?? "";
    geoFirePoint = json['geoFirePoint'] == null
        ? GeoFirePoint(0, 0)
        : GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
            (json['geoFirePoint']['geopoint']).longitude);
    lastMsg = json['lastMsg'] ?? "";
    lastMsgTime = json['lastMsgTime'] == null
        ? DateTime.now().toUtc()
        : (json['lastMsgTime'] as Timestamp).toDate();
    lastMsgUserKey = json['last_msg_user_key'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['itemImage'] = itemImage;
    map['itemTitle'] = itemTitle;
    map['itemKey'] = itemKey;
    map['itemAddress'] = itemAddress;
    map['itemPosition'] = itemPosition;
    map['itemPrice'] = itemPrice;
    map['sellerKey'] = sellerKey;
    map['buyerKey'] = buyerKey;
    map['sellerImage'] = sellerImage;
    map['buyerImage'] = buyerImage;
    map['geoFirePoint'] = geoFirePoint.data;
    map['lastMsg'] = lastMsg;
    map['lastMsgTime'] = lastMsgTime;
    map['lastMsgUserKey'] = lastMsgUserKey;
    return map;
  }

  ChatroomModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatroomModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateChatRoomKey(String buyer, String itemKey) {
    return '${itemKey}_$buyer';
  }
}
