import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? refernce;

  UserModel(
      {required this.userKey,
      required this.phoneNumber,
      required this.address,
      required this.geoFirePoint,
      required this.createdDate,
      this.refernce});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.refernce)
      : phoneNumber = json['phoneNumber'],
        address = json['address'],
        geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
            (json['geoFirePoint']['geopoint']).longitude),
        createdDate = json['createdDate'] == null
            ? DateTime.now().toUtc()
            : (json['createdDate'] as Timestamp).toDate();

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    return map;
  }
}
