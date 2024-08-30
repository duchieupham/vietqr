import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/scroll_indicator.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class ListBankWidget extends StatefulWidget {
  const ListBankWidget({super.key});

  @override
  State<ListBankWidget> createState() => _ListBankWidgetState();
}

class _ListBankWidgetState extends State<ListBankWidget>
    with AutomaticKeepAliveClientMixin {
  final BankBloc bankBloc = getIt.get<BankBloc>();
  late SwiperController _swiperController;
  double move = 0.0;
  double moveWidth = 0.0;

  final List<String> listText = [
    'Quét mã VietQR của bạn để thêm tài khoản ngân hàng!',
  ];

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  // bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> reset() async {
    _swiperController.move(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    super.build(context);
    return BlocConsumer<BankBloc, BankState>(
      bloc: bankBloc,
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING_PAGE &&
            state.request == BankType.BANK) {
        } else {
          Provider.of<AuthenProvider>(context, listen: false)
              .updateBanks(state.listBanks);
        }
        if (state.status == BlocStatus.LOADING_PAGE &&
            state.request == BankType.BANK) {
          move = 0.0;
          _swiperController.move(0);
        }
      },
      builder: (context, state) {
        return Container(
          decoration:
              BoxDecoration(gradient: VietQRTheme.gradientColor.lilyLinear),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Swiper(
                  controller: _swiperController,
                  onTap: (index) {
                    if (state.isEmpty) {
                      NavigatorUtils.navigatePage(
                          context, const AddBankScreen(),
                          routeName: AddBankScreen.routeName);
                    }
                    if (state.listBanks.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BankCardDetailNewScreen(
                              page: 0,
                              dto: state.listBanks[index],
                              bankId: state.listBanks[index].id),
                          settings: const RouteSettings(
                            name: Routes.BANK_CARD_DETAIL_NEW,
                          ),
                        ),
                      );
                    }
                  },
                  onIndexChanged: (value) {
                    bankBloc
                        .add(SelectBankAccount(bank: state.listBanks[value]));
                    bankBloc.add(
                        GetOverviewEvent(bankId: state.listBanks[value].id));
                    bankBloc
                        .add(GetTransEvent(bankId: state.listBanks[value].id));
                    int itemCount =
                        (state.listBanks.length); // Assuming 1-indexed itemse
                    double availableWidth = 80 - 18;
                    double moveStep = availableWidth / (itemCount - 1);
                    setState(() {
                      if (itemCount > 0) {
                        // moveWidth = (80 / itemCount);
                        move = moveStep * value;
                      } else {
                        move = 0.0;
                      }
                    });
                  },
                  viewportFraction: 0.55,
                  scale: 0.8,
                  loop: false,
                  itemHeight: 100,
                  itemWidth: 200,
                  itemCount:
                      (state.listBanks.isNotEmpty ? state.listBanks.length : 1),
                  curve: Curves.easeInOut,
                  itemBuilder: (context, index) {
                    if (state.listBanks.isEmpty) {
                      return Container(
                        width: 200,
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.WHITE.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.WHITE),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            XImage(
                              imagePath: 'assets/images/ic-bank-add.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Thêm tài khoản ngân hàng',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.WHITE.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.WHITE),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: ImageUtils.instance.getImageNetWork(
                                        state.listBanks[index].imgId),
                                  ),
                                ),
                                // child: XImage(imagePath: e.imgId),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.listBanks[index].bankAccount,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.listBanks[index].userBankName
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          if (state.listBanks.isNotEmpty &&
                              state.listBanks[index].isAuthenticated &&
                              state.listBanks[index].isOwner)
                            const Positioned(
                              right: 0,
                              top: 0,
                              child: XImage(
                                imagePath: 'assets/images/ic-isAuthen.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (state.listBanks.isNotEmpty &&
                              state.listBanks[index].isAuthenticated &&
                              !state.listBanks[index].isOwner)
                            const Positioned(
                              right: 0,
                              top: 0,
                              child: XImage(
                                imagePath: 'assets/images/ic-shared.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (state.isEmpty) ...[
                InkWell(
                  onTap: () async {
                    await NavigatorUtils.navigatePage(
                        context, const AddBankScreen(),
                        routeName: AddBankScreen.routeName);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      padding: const EdgeInsets.fromLTRB(12, 0, 22, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD8ECF8),
                                Color(0xFFFFEAD9),
                                Color(0xFFF5C9D1),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const XImage(
                            imagePath: 'assets/images/ic-suggest.png',
                            width: 30,
                          ),
                          Expanded(
                            // width: MediaQuery.of(context).size.width,
                            child: CarouselSlider(
                              items: listText.map(
                                (e) {
                                  return Center(
                                    child: Text(
                                      e,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: AppColor.BLACK,
                                        fontSize: width > 380 ? 12 : 10,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                  reverse: false,
                                  autoPlay: true,
                                  viewportFraction: 0.9,
                                  pageSnapping: false,
                                  autoPlayCurve: Curves.linear,
                                  autoPlayInterval: const Duration(seconds: 10),
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 10)),
                            ),
                          ),
                        ],
                      )),
                ),
                // Container(
                //   width: double.infinity,
                //   margin: const EdgeInsets.symmetric(horizontal: 20),
                //   child: VietQRButton.suggest(
                //       size: VietQRButtonSize.small,
                //       onPressed: () async {
                //         await NavigatorUtils.navigatePage(
                //             context, const AddBankScreen(),
                //             routeName: AddBankScreen.routeName);
                //       },
                //       text:
                //           'Quét mã VietQR của bạn để thêm tài khoản ngân hàng'),
                // ),
                const SizedBox(height: 10),
              ],
              if (state.listBanks.isNotEmpty) ...[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.WHITE,
                  ),
                  child: Stack(
                    // fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: move,
                        child: Container(
                          height: 5,
                          width: 18,
                          decoration: BoxDecoration(
                            // color: AppColor.BLUE_TEXT,
                            gradient:
                                VietQRTheme.gradientColor.brightBlueLinear,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8)
              ]
            ],
          ),
        );
      },
    );
  }
}

class BankLoading extends StatefulWidget {
  const BankLoading({super.key});

  @override
  State<BankLoading> createState() => _BankLoadingState();
}

class _BankLoadingState extends State<BankLoading> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<BankBloc, BankState, BlocStatus>(
      bloc: getIt.get<BankBloc>(),
      selector: (state) => state.status,
      builder: (context, state) {
        if (state == BlocStatus.LOADING_PAGE) {
          return Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Swiper(
              viewportFraction: 0.55,
              scale: 0.8,
              loop: false,
              itemHeight: 100,
              itemWidth: 200,
              itemCount: 3,
              onIndexChanged: (value) {
                print('index: $value');
              },
              curve: Curves.easeInOut,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.WHITE.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.WHITE),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(
                        width: 60,
                        height: 30,
                        borderRadius: 10,
                      ),
                      SizedBox(height: 10),
                      ShimmerBlock(
                        width: 120,
                        height: 12,
                        borderRadius: 10,
                      ),
                      SizedBox(height: 3),
                      ShimmerBlock(
                        width: 90,
                        height: 10,
                        borderRadius: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
