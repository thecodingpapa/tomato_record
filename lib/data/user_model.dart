import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:tomato_record/constants/data_keys.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  UserModel(
      {required this.userKey,
      required this.phoneNumber,
      required this.address,
      required this.geoFirePoint,
      required this.createdDate,
      this.reference});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference)
      : phoneNumber = json[DOC_PHONENUMBER],
        address = json[DOC_ADDRESS],
        geoFirePoint = GeoFirePoint(
            (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
            (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude),
        createdDate = json[DOC_CREATEDDATE] == null
            ? DateTime.now().toUtc()
            : (json[DOC_CREATEDDATE] as Timestamp).toDate();

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_PHONENUMBER] = phoneNumber;
    map[DOC_ADDRESS] = address;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }
}
