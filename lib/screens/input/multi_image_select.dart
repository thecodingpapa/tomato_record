import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomato_record/constants/common_size.dart';

class MultiImageSelect extends StatefulWidget {
  MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size _size = MediaQuery.of(context).size;
        var imageSize = (_size.width / 3) - common_padding * 2;
        var imageCorner = 16.0;
        return SizedBox(
          height: _size.width / 3,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(common_padding),
                child: InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage();
                    if (images != null && images.isNotEmpty) {
                      _images.clear();
                      _images.addAll(images);
                      setState(() {});
                    }
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey,
                        ),
                        Text(
                          '0/10',
                          style: Theme.of(context).textTheme.subtitle2,
                        )
                      ],
                    ),
                    width: imageSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageCorner),
                        border: Border.all(color: Colors.grey, width: 1)),
                  ),
                ),
              ),
              ...List.generate(
                  _images.length,
                  (index) => Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: common_padding,
                                top: common_padding,
                                bottom: common_padding),
                            child: FutureBuilder<Uint8List>(
                                future: _images[index].readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ExtendedImage.memory(
                                      snapshot.data!,
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                      loadStateChanged: (state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            return Container(
                                                width: imageSize,
                                                height: imageSize,
                                                padding: EdgeInsets.all(
                                                    imageSize / 3),
                                                child:
                                                    CircularProgressIndicator());
                                          case LoadState.completed:
                                            return null;
                                          case LoadState.failed:
                                            return Icon(Icons.cancel);
                                        }
                                      },
                                      borderRadius:
                                          BorderRadius.circular(imageCorner),
                                      shape: BoxShape.rectangle,
                                    );
                                  } else {
                                    return Container(
                                        width: imageSize,
                                        height: imageSize,
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            width: 40,
                            height: 40,
                            child: IconButton(
                              padding: EdgeInsets.all(8),
                              onPressed: () {},
                              icon: Icon(Icons.remove_circle),
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ))
            ],
          ),
        );
      },
    );
  }
}
