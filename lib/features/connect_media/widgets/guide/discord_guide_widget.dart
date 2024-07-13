import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class DiscordGuide1Widget extends StatelessWidget {
  const DiscordGuide1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        RichText(
          text: const TextSpan(
            text: 'Bước 1 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text: ' Tạo Nhóm Discord',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        // const SizedBox(height: 20),
        Container(
          width: 350,
          height: 250,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/discord-intro1.png"))),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Bước 2 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text: ' Vào phần chỉnh sửa kênh',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        Container(
          width: 350,
          height: 250,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/discord-intro2.png"))),
        ),
      ],
    );
  }
}

class DiscordGuide2Widget extends StatelessWidget {
  const DiscordGuide2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            text: 'Bước 3 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text: ' Vào Tích Hợp và tạo Webhook',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/discord-intro3.png"))),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Bước 4 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Đặt tên  bot và chọn Kênh cần nhận biến động thông báo số dư. Cuối cùng là sao chép webhook.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/discord-intro4.png"))),
        ),
      ],
    );
  }
}
