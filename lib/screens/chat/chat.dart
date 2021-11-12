import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

Radius chatBorder = Radius.circular(20);

class Chat extends StatelessWidget {
  final Size size;
  const Chat({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExtendedImage.network(
          'https://randomuser.me/api/portraits/women/28.jpg',
          shape: BoxShape.circle,
          width: size.width / 12,
          height: size.width / 12,
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints:
                    BoxConstraints(minHeight: 40, maxWidth: size.width * 0.7),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: chatBorder,
                      bottomLeft: chatBorder,
                      bottomRight: chatBorder,
                    ),
                    color: Colors.redAccent),
                child: Text(
                    ';lkdfadklkhdfasdfasfdlghiusdahfhkjldasfjklkajdsfkljdlksjgjlkdfadklkhdfasdfasfdlghiusdahfhkjldasfjklkajdsfkljdlksjgj;ldslkjdjf'),
              ),
              Expanded(
                child: Text(
                  '오전 10:25',
                  textScaleFactor: 0.6,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
