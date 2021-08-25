import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:tomato_record/constants/common_size.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final inputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  TextEditingController _textEditingController =
      TextEditingController(text: "010");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '전화번호 로그인',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(common_padding),
            child: Column(
              children: [
                Row(
                  children: [
                    ExtendedImage.asset(
                      'assets/imgs/padlock.png',
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                    ),
                    SizedBox(
                      width: common_sm_padding,
                    ),
                    Text('''토마토마켓은 휴대폰 번호로 가입해요.
번호는 안전하게 보관 되며
어디에도 공개되지 않아요.''')
                  ],
                ),
                SizedBox(
                  height: common_padding,
                ),
                TextFormField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                  decoration: InputDecoration(
                      focusedBorder: inputBorder, border: inputBorder),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
