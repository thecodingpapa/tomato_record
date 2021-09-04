import 'package:dio/dio.dart';
import 'package:tomato_record/constants/keys.dart';
import 'package:tomato_record/data/address_model.dart';
import 'package:tomato_record/data/address_model2.dart';
import 'package:tomato_record/utils/logger.dart';

class AddressService {
  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'type': 'ADDRESS',
      'category': 'ROAD',
      'query': text,
      'size': 30,
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      logger.e(e.message);
    });

    AddressModel addressModel =
        AddressModel.fromJson(response.data["response"]);
    logger.d(addressModel);
    return addressModel;
  }

  Future<List<AddressModel2>> findAddressByCoordinate(
      {required double log, required double lat}) async {
    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>>[];

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log,$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '${log - 0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '${log + 0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log,${lat - 0.01}',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log,${lat + 0.01}',
    });

    List<AddressModel2> addresses = [];

    for (Map<String, dynamic> formData in formDatas) {
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        logger.e(e.message);
      });

      AddressModel2 addressModel =
          AddressModel2.fromJson(response.data["response"]);

      if (response.data['response']['status'] == 'OK')
        addresses.add(addressModel);
    }

    logger.d(addresses);
    return addresses;
  }
}
