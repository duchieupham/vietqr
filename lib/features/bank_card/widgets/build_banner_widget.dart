import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BuildBannerWidget extends StatefulWidget {
  const BuildBannerWidget({super.key});

  @override
  State<BuildBannerWidget> createState() => _BuildBannerWidgetState();
}

class _BuildBannerWidgetState extends State<BuildBannerWidget>
    with AutomaticKeepAliveClientMixin {
  final SwiperController _swiperController = SwiperController();
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
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                controller: _swiperController,
                viewportFraction: 0.9,

                // scale: 1.0,
                onIndexChanged: (value) async {
                  setState(() {
                    _index = value;
                  });
                  if (value == 1) {
                    await Future.delayed(const Duration(milliseconds: 5000));
                    _swiperController.previous();
                  }
                },
                loop: false,
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
                                    imagePath: 'assets/images/vietqr-image.png',
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
                            Positioned(
                              top: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  List<int> list = List.from(state.listBanner);
                                  list.removeAt(index);
                                  getIt
                                      .get<BankBloc>()
                                      .add(CloseBannerEvent(listBanner: list));
                                },
                                child: const XImage(
                                  imagePath: 'assets/images/ic-close-black.png',
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
                                  imagePath: 'assets/images/ic-bidv-white.png',
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
                          if (state.bankSelect != null &&
                              state.bankSelect!.mmsActive)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  List<int> list = List.from(state.listBanner);
                                  list.removeAt(index);
                                  getIt
                                      .get<BankBloc>()
                                      .add(CloseBannerEvent(listBanner: list));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                state.listBanner.length,
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
        );
      },
    );
  }
}
