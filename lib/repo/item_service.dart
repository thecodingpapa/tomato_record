import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:latlng/latlng.dart';
import 'package:tomato_record/constants/data_keys.dart';
import 'package:tomato_record/data/item_model.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();
  factory ItemService() => _itemService;
  ItemService._internal();

  Future createNewItem(
      ItemModel itemModel, String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> itemDocReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userKey)
            .collection(COL_USER_ITEMS)
            .doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemDocReference.get();

    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(itemDocReference, itemModel.toJson());
        transaction.set(userItemDocReference, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getItems() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots =
        await collectionReference.get();

    List<ItemModel> items = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemModel);
    }

    return items;
  }

  Future<List<ItemModel>> getUserItems(String userKey,
      {String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userKey)
            .collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots =
        await collectionReference.get();

    List<ItemModel> items = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(itemKey != null && itemKey == itemModel.itemKey))
        items.add(itemModel);
    }

    return items;
  }

  Future<List<ItemModel>> getNearByItems(String userKey, LatLng latLng) async {
    final geo = Geoflutterfire();
    final itemCol = FirebaseFirestore.instance.collection(COL_ITEMS);

    GeoFirePoint center = GeoFirePoint(latLng.latitude, latLng.longitude);
    double radius = 1.5;
    var field = 'geoFirePoint';

    List<ItemModel> items = [];
    List<DocumentSnapshot<Map<String, dynamic>>> snapshots = await geo
        .collection(collectionRef: itemCol)
        .within(center: center, radius: radius, field: field)
        .first;

    for (int i = 0; i < snapshots.length; i++) {
      ItemModel itemModel = ItemModel.fromSnapshot(snapshots[i]);
      //todo: remove my own item
      items.add(itemModel);
    }

    return items;
  }
}
