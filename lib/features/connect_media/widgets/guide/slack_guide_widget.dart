import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class SlackGuide1Widget extends StatelessWidget {
  const SlackGuide1Widget({super.key});

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
                  text: ' Có nhóm chat Slack',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        // const SizedBox(height: 20),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/slack-intro1.png"))),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'Bước 2 -',
            style: const TextStyle(
                fontSize: 15,
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text: ' Truy cập  vào link ',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text:
                          'https://slack.com/apps/A0F7XDUAZ-incoming-webhooks',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.BLUE_TEXT),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // ignore: deprecated_member_use
                          await launch(
                            'https://slack.com/apps/A0F7XDUAZ-incoming-webhooks',
                            forceSafariVC: false,
                          );
                        },
                    )
                  ]),
            ],
          ),
        ),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/slack-intro2.png"))),
        ),
      ],
    );
  }
}

class SlackGuide2Widget extends StatelessWidget {
  const SlackGuide2Widget({super.key});

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
                  text: ' Chọn Add to Slack',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        // const SizedBox(height: 20),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/slack-intro3.png"))),
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
                text: ' Chọn “register as a developer”',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/slack-intro4.png"))),
        ),
      ],
    );
  }
}

class SlackGuide3Widget extends StatelessWidget {
  const SlackGuide3Widget({super.key});

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
                  text: ' Chọn “Create new App”',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        // const SizedBox(height: 20),
        Container(
          width: 350,
          height: 220,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/slack-intro5.png"))),
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
                text:
                    ' Chọn “From Scratch”, nhập “app name” và chọn workspace mình mong muốn. Chọn “Create App””',
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

class SlackGuide4Widget extends StatelessWidget {
  const SlackGuide4Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
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
                      ' Sau khi “Create app” thành công thì sẽ hiện màn hình như dưới và chọn “Incoming Webhook”',
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
                  image: AssetImage("assets/images/slack-intro7.png"))),
        ),
        const SizedBox(height: 10),
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
                    ' Chọn  “On” để Active và chọn “Add New Webhook To Workspace”',
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
                  image: AssetImage("assets/images/slack-intro8.png"))),
        ),
      ],
    );
  }
}

class SlackGuide5Widget extends StatelessWidget {
  const SlackGuide5Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
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
                      ' Chọn Kênh chat muốn nhận thông báo biến động số dư và chon “Allow”',
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
                  image: AssetImage("assets/images/slack-intro9.png"))),
        ),
        // const SizedBox(height: 4),
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
                    ' Sau khi chọn “Allow ” sẽ quay về màn hình dưới và chọn “Copy”. Như thế là đã lấy webhook của Slack thành công.',
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
                  image: AssetImage("assets/images/slack-intro10.png"))),
        ),
      ],
    );
  }
}
