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
  String? itemImage;
  String? itemTitle;
  String? itemKey;
  String? itemAddress;
  String? itemPosition;
  double? itemPrice;
  String? sellerKey;
  String? buyerKey;
  String? sellerImage;
  String? buyerImage;
  String? geoFirePoint;
  String? lastMsg;
  String? lastMsgTime;
  String? lastMsgUserKey;
  String? chatroomKey;

  ChatroomModel({
      this.itemImage, 
      this.itemTitle, 
      this.itemKey, 
      this.itemAddress, 
      this.itemPosition, 
      this.itemPrice, 
      this.sellerKey, 
      this.buyerKey, 
      this.sellerImage, 
      this.buyerImage, 
      this.geoFirePoint, 
      this.lastMsg, 
      this.lastMsgTime, 
      this.lastMsgUserKey, 
      this.chatroomKey});

  ChatroomModel.fromJson(dynamic json) {
    itemImage = json['item_image'];
    itemTitle = json['item_title'];
    itemKey = json['item_key'];
    itemAddress = json['item_address'];
    itemPosition = json['item_position'];
    itemPrice = json['item_price'];
    sellerKey = json['seller_key'];
    buyerKey = json['buyer_key'];
    sellerImage = json['seller_image'];
    buyerImage = json['buyer_image'];
    geoFirePoint = json['geo_fire_point'];
    lastMsg = json['last_msg'];
    lastMsgTime = json['last_msg_time'];
    lastMsgUserKey = json['last_msg_user_key'];
    chatroomKey = json['chatroom_key'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['item_image'] = itemImage;
    map['item_title'] = itemTitle;
    map['item_key'] = itemKey;
    map['item_address'] = itemAddress;
    map['item_position'] = itemPosition;
    map['item_price'] = itemPrice;
    map['seller_key'] = sellerKey;
    map['buyer_key'] = buyerKey;
    map['seller_image'] = sellerImage;
    map['buyer_image'] = buyerImage;
    map['geo_fire_point'] = geoFirePoint;
    map['last_msg'] = lastMsg;
    map['last_msg_time'] = lastMsgTime;
    map['last_msg_user_key'] = lastMsgUserKey;
    map['chatroom_key'] = chatroomKey;
    return map;
  }

}