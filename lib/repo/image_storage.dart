import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tomato_record/utils/logger.dart';

class ImageStorage {
  static Future<List<String>> uploadImages(
      List<Uint8List> images, String itemKey) async {
    var metaData = SettableMetadata(contentType: 'image/jpeg');

    List<String> downloadUrls = [];

    for (int i = 0; i < images.length; i++) {
      Reference ref = FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
      if (images.isNotEmpty) {
        await ref.putData(images[i], metaData).catchError((onError) {
          logger.e(onError.toString());
        });

        downloadUrls.add(await ref.getDownloadURL());
      }
    }

    return downloadUrls;
  }
}
