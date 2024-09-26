import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class SheetGuide1Widget extends StatelessWidget {
  const SheetGuide1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/sheet-intro1.png"))),
        ),
        RichText(
          text: const TextSpan(
            text: 'Bước 1 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Chọn File Google Sheet cần nhận chia sẻ biến động số dư. Chọn “Tiện ích bổ sung” -> “Tải tiện ích bổ sung”',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}

class SheetGuide2Widget extends StatelessWidget {
  const SheetGuide2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            text: 'Bước 2 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Nhập “Webhooks for Sheets” và chọn ứng dụng “Webhooks for Sheets”',
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
                  image: AssetImage("assets/images/sheet-intro2.png"))),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Bước 3 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: ' Chọn “Cài đặt”',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
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
                  image: AssetImage("assets/images/slack-intro3.png"))),
        ),
      ],
    );
  }
}

class SheetGuide3Widget extends StatelessWidget {
  const SheetGuide3Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/sheet-intro4.png"))),
        ),
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
                      ' Sau khi cài đặt xong thì sẽ có biểu tượng ở góc phải màn hình . Chọn vào biểu tượng “Webhook for sheet”.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}

class SheetGuide4Widget extends StatelessWidget {
  const SheetGuide4Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            text: 'Bước 5 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Làm theo các bước “Step ” hướng dẫn trong Biểu tượng.',
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
                  image: AssetImage("assets/images/sheet-intro5.png"))),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Bước 6 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: ' Chọn “Create”',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
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
                  image: AssetImage("assets/images/slack-intro6.png"))),
        ),
      ],
    );
  }
}

class SheetGuide5Widget extends StatelessWidget {
  const SheetGuide5Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/sheet-intro7.png"))),
        ),
        RichText(
          text: const TextSpan(
            text: 'Bước 7 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Hiện ra màn hình ở dưới và “Repeat step 2”. -> Chọn “Next” -> Reload lại trang Google Sheet.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}

class SheetGuide6Widget extends StatelessWidget {
  const SheetGuide6Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/sheet-intro8.png"))),
        ),
        RichText(
          text: const TextSpan(
            text: 'Bước 8 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Sau khi reload trang web sẽ xuất hiện biểu tượng “webhooks”, chọn “Authorized”. Chọn Ủy quyền.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Bước 9 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Sau khi ủy quyền thành công thì quay lại màn hình file Google Sheet chọn biểu tượng “webhook for google sheet”.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}

class SheetGuide7Widget extends StatelessWidget {
  const SheetGuide7Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/sheet-intro10.png"))),
        ),
        RichText(
          text: const TextSpan(
            text: 'Bước 10 -',
            style: TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' Màn hình xuất hiện URL Webhook. Như vậy là thành công lấy URL Webhook trên Google Sheet.',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}
