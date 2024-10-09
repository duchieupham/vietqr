import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class BuildBannerWidget extends StatefulWidget {
  const BuildBannerWidget({super.key});

  @override
  State<BuildBannerWidget> createState() => _BuildBannerWidgetState();
}

class _BuildBannerWidgetState extends State<BuildBannerWidget>
    with AutomaticKeepAliveClientMixin {
  final SwiperController _swiperController = SwiperController();
  // ignore: unused_field
  int _index = 0;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<BankBloc, BankState>(
      bloc: getIt.get<BankBloc>(),
      builder: (context, state) {
        if (state.listBanner.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          // margin: const EdgeInsets.only(top: 10),
          // padding: const EdgeInsets.fromLTRB(0, 010, 0, 0),
          height: MediaQuery.of(context).size.width * (550 / 2000),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: VietQRTheme.gradientColor.lilyLinear,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Swiper(
                  controller: _swiperController,
                  viewportFraction: 1.0,

                  // scale: 1.0,
                  onIndexChanged: (value) async {
                    setState(() {
                      _index = value;
                    });
                    // if (value == 1) {
                    //   await Future.delayed(const Duration(milliseconds: 5000));
                    //   _swiperController.previous();
                    // }
                  },
                  loop: true,
                  autoplay: true,
                  autoplayDelay: 5000,
                  itemCount: state.listBanner.length,
                  curve: Curves.easeInOut,

                  // allowImplicitScrolling: true,
                  itemBuilder: (context, index) {
                    int bannerIndex = state.listBanner[index];
                    if (bannerIndex == 1) {
                      return InkWell(
                        child: Container(
                          // margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: AppColor.BLACK.withOpacity(0.1),
                            //     spreadRadius: 1,
                            //     blurRadius: 10,
                            //     offset: const Offset(0, 1),
                            //   )
                            // ],
                          ),
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
                              // if (state.bankSelect != null &&
                              //     state.bankSelect!.mmsActive)
                              //   Positioned(
                              //     top: 10,
                              //     right: 10,
                              //     child: InkWell(
                              //       onTap: () {
                              //         // List<int> list =
                              //         //     List.from(state.listBanner);
                              //         // list.removeAt(index);
                              //         getIt.get<BankBloc>().add(
                              //             const CloseBannerEvent(
                              //                 listBanner: []));
                              //       },
                              //       child: const XImage(
                              //         imagePath:
                              //             'assets/images/ic-close-black.png',
                              //         width: 30,
                              //         height: 30,
                              //         color: AppColor.BLACK,
                              //       ),
                              //     ),
                              //   )
                            ],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        String url =
                            "https://omni.bidv.com.vn/static/bidv/share/gioi-thieu-ban-thuong-vo-han.html?data=aH0RHc6MyLk9Cbi5Wa2R2ch1nciRWYr5Wan5nLuZ2LiVlTBRGTS1VbuVVeYZEZo4";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        // margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/bidv-img.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: XImage(
                                          imagePath:
                                              'assets/images/ic-bidv-white.png',
                                          width: 40,
                                          height: 20,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Mở tài khoản BIDV',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.WHITE,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Nhận ngay ưu đãi miễn phí 2 tháng sử dụng\nMiễn phí mở tài khoản số đẹp.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: '0948885828',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      }
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 12,
                                          color: AppColor.WHITE,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '094.888.5828',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.WHITE,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // if (state.bankSelect != null &&
                            //     state.bankSelect!.mmsActive)
                            //   Positioned(
                            //     top: 10,
                            //     right: 10,
                            //     child: InkWell(
                            //       onTap: () {
                            //         // List<int> list = List.from(state.listBanner);
                            //         // list.removeAt(index);
                            //         getIt.get<BankBloc>().add(
                            //             const CloseBannerEvent(listBanner: []));
                            //       },
                            //       child: const XImage(
                            //         imagePath:
                            //             'assets/images/ic-close-black.png',
                            //         width: 30,
                            //         height: 30,
                            //         color: AppColor.WHITE,
                            //       ),
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 10,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: List.generate(
              //       state.listBanner.length,
              //       (index) {
              //         bool isIndex = _index == index;
              //         return Container(
              //           margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
              //           height: 10,
              //           width: isIndex ? 30 : 10,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(100),
              //               gradient: isIndex
              //                   ? VietQRTheme.gradientColor.brightBlueLinear
              //                   : VietQRTheme.gradientColor.lilyLinear),
              //         );
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }
}
