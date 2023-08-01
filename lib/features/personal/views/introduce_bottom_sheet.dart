import 'package:clipboard/clipboard.dart';
import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class IntroduceBottomSheet extends StatefulWidget {
  final IntroduceDTO? introduceDTO;

  const IntroduceBottomSheet({super.key, this.introduceDTO});

  @override
  State<IntroduceBottomSheet> createState() => _IntroduceBottomSheetState();
}

class _IntroduceBottomSheetState extends State<IntroduceBottomSheet> {
  late BusinessInformationRepository repository;
  String userId = UserInformationHelper.instance.getUserId();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  void initData() async {
    try {} catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: AppColor.BANK_CARD_COLOR_3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.transparent,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Giới thiệu VietQR VN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width - 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildItemIntroduce('Mã giới thiệu',
                            widget.introduceDTO?.sharingCode ?? ''),
                        const SizedBox(height: 20),
                        _buildItemIntroduce('Link giới thiệu',
                            widget.introduceDTO?.sharingCodeLink ?? ''),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      SizedBox(width: 4),
                      Text(
                        'hoặc',
                        style:
                            TextStyle(fontSize: 14, color: AppColor.GREY_TEXT),
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      Share.share(
                        'Đăng ký thành viên mới của VietQR VN ngay! Cùng trải nghiệm những tiện ích và ưu đãi mà chúng tôi mang lại bằng cách nhập mã “${widget.introduceDTO?.sharingCode ?? ''}” khi đăng ký tại ${widget.introduceDTO?.sharingCodeLink ?? ''} hoặc trên ứng dụng di động.',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: AppColor.BLUE_TEXT,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: const [
                          Icon(Icons.ios_share, color: Colors.white),
                          Expanded(
                            child: Text(
                              'Chia sẻ mã giới thiệu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.WHITE,
                              ),
                            ),
                          ),
                          Icon(Icons.ios_share, color: Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Future<void> share({required QRGeneratedDTO dto}) async {
  //   await Future.delayed(const Duration(milliseconds: 200), () async {
  //     await ShareUtils.instance
  //         .shareImage(
  //           textSharing:
  //               '${dto.bankAccount} - ${dto.bankName}\nĐược tạo bởi vietqr.vn - Hotline 19006234'
  //                   .trim(),
  //         )
  //         .then((value) => _waterMarkProvider.updateWaterMark(false));
  //   });
  // }

  Widget _buildItemIntroduce(String title, String data) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: data));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColor.greyF0F0F0,
                border: Border.all(color: AppColor.grey979797, width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      data,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14, color: AppColor.GREY_TEXT),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FlutterClipboard.copy(data).then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/ic_copy.png',
                    width: 28,
                    height: 28,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
