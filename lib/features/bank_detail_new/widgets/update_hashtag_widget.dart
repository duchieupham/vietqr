import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class UpdateHashtagWidget extends StatefulWidget {
  final String transType;
  const UpdateHashtagWidget({super.key, required this.transType});

  @override
  State<UpdateHashtagWidget> createState() => _UpdateHashtagWidgetState();
}

class _UpdateHashtagWidgetState extends State<UpdateHashtagWidget> {
  List<String> listCredit = [
    'thu_nhập',
    'tiết_kiệm',
    'lương',
    'thu_lãi',
    'thu_nhập_khác',
  ];

  List<String> listDebit = [
    'hoá_đơn',
    'ăn_uống',
    'gia_đình',
    'sức khoẻ',
    'di_chuyển',
    'giải_trí',
    'bảo_hiểm',
    'đầu_tư',
    'trả_lãi',
    'khác',
  ];

  String selectHashTag = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
        )),
        Positioned(
            bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Container(
              height: (widget.transType == 'D' ? 500 : 400),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
              decoration: const BoxDecoration(
                color: AppColor.WHITE,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const XImage(
                            imagePath: 'assets/images/ic-hastag.png',
                            height: 30,
                            width: 30,
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => VietQRTheme
                                .gradientColor.brightBlueLinear
                                .createShader(bounds),
                            child: const Text(
                              'Cập nhật',
                              style: TextStyle(
                                  fontSize: 20, color: AppColor.WHITE),
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const XImage(
                          imagePath: 'assets/images/ic-close-black.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => VietQRTheme
                        .gradientColor.brightBlueLinear
                        .createShader(bounds),
                    child: const Text(
                      'Hashtag giao dịch',
                      style: TextStyle(fontSize: 25, color: AppColor.WHITE),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (widget.transType == 'D') ...[
                    Expanded(
                        child: Column(
                      children: [
                        _buildItem(0, listDebit),
                        const SizedBox(height: 16),
                        _buildItem(3, listDebit),
                        const SizedBox(height: 16),
                        _buildItem(6, listDebit),
                        const SizedBox(height: 16),
                        _buildItem(9, listDebit),
                      ],
                    ))
                  ] else ...[
                    Expanded(
                        child: Column(
                      children: [
                        _buildItem(0, listCredit),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 3; i < 5; i++)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop(listCredit[i]);
                                    },
                                    child: GradientBorderButton(
                                      widget: Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const XImage(
                                              imagePath:
                                                  'assets/images/ic-hastag.png',
                                              height: 30,
                                              width: 30,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              listCredit[i],
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      borderWidth: 1,
                                      gradient: VietQRTheme
                                          .gradientColor.brightBlueLinear,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                          ],
                        )
                      ],
                    ))
                  ],
                  Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: VietQRTheme.gradientColor.lilyLinear),
                    child: const Row(
                      children: [
                        XImage(
                          imagePath: 'assets/images/ic-hashtag-3d.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          'Chúng tôi sẽ cập nhật thêm tính năng quản trị\ncác hashtag của bạn trong tương lai gần.\nCùng chờ đón nhé!!!',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildItem(int index, List<String> list) {
    return Row(
      mainAxisAlignment:
          index == 9 ? MainAxisAlignment.start : MainAxisAlignment.spaceEvenly,
      children: [
        if (index == 9)
          InkWell(
            onTap: () {
              Navigator.of(context).pop(list[index]);
            },
            child: GradientBorderButton(
              widget: Container(
                height: 40,
                width: 100,
                padding: const EdgeInsets.only(left: 4, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-hastag.png',
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      list[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1,
              gradient: VietQRTheme.gradientColor.brightBlueLinear,
            ),
          )
        else
          for (int i = index; i < (index == 2 ? index + 2 : (index + 3)); i++)
            Expanded(
              child: Row(
                children: [
                  if (index != 2)
                    if ((index == 6)
                        ? (i == 8)
                        : (index == 3 ? (i == 5) : (i == 2)))
                      const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(list[i]);
                      },
                      child: GradientBorderButton(
                        widget: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 4, right: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const XImage(
                                imagePath: 'assets/images/ic-hastag.png',
                                height: 30,
                                width: 30,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                list[i],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(50),
                        borderWidth: 1,
                        gradient: VietQRTheme.gradientColor.brightBlueLinear,
                      ),
                    ),
                  ),
                  if ((index == 6)
                      ? (i == 6)
                      : ((index == 3) ? (i == 3) : (i == 0)))
                    const SizedBox(width: 8),
                  if (index == 2) const SizedBox(width: 30)
                ],
              ),
            ),
      ],
    );
  }
}
