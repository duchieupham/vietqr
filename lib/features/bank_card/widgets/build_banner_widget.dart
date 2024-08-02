import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BuildBannerWidget extends StatefulWidget {
  const BuildBannerWidget({super.key});

  @override
  State<BuildBannerWidget> createState() => _BuildBannerWidgetState();
}

class _BuildBannerWidgetState extends State<BuildBannerWidget>
    with AutomaticKeepAliveClientMixin {
  bool get isOpenBanner => SharePrefUtils.getBanner();
  int _index = 0;
  List<int> list = [0, 1];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return list.isNotEmpty
        ? Column(
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  viewportFraction: 0.9,
                  onIndexChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                  loop: false,
                  itemCount: list.length,
                  curve: Curves.easeInOut,
                  allowImplicitScrolling: true,
                  itemBuilder: (context, index) {
                    int bannerIndex = list[index];
                    if (bannerIndex == 1) {
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.BLACK.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(19),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Trải nghiệm',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'dịch vụ ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    VietQRTheme
                                                        .gradientColor.vietQrPro
                                                        .createShader(bounds),
                                                child: const Text(
                                                  'VietQR Pro',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: AppColor.WHITE,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Text(
                                            'Giải pháp tối ưu cho doanh nghiệp của bạn.',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const XImage(
                                      imagePath:
                                          'assets/images/vietqr-image.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      list.removeAt(index);
                                    });
                                  },
                                  child: const XImage(
                                    imagePath:
                                        'assets/images/ic-close-black.png',
                                    width: 30,
                                    height: 30,
                                    color: AppColor.BLACK,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/bidv-img.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 20,
                              top: 20,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  XImage(
                                    imagePath:
                                        'assets/images/ic-bidv-white.png',
                                    width: 60,
                                    height: 20,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Mở tài khoản BIDV',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.WHITE,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Miễn phí toàn bộ phí chuyển tiền\ntrong nước trên Smartbanking.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.WHITE,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    list.removeAt(index);
                                  });
                                },
                                child: const XImage(
                                  imagePath: 'assets/images/ic-close-black.png',
                                  width: 30,
                                  height: 30,
                                  color: AppColor.WHITE,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  list.length,
                  (index) {
                    bool isIndex = _index == index;
                    return Container(
                      margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                      height: 10,
                      width: isIndex ? 30 : 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: isIndex
                              ? VietQRTheme.gradientColor.brightBlueLinear
                              : VietQRTheme.gradientColor.lilyLinear),
                    );
                  },
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
