import 'dart:isolate';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/commons/widgets/slide_fade_transition.dart';
import 'package:vierqr/commons/widgets/step_progress.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/bank_info_v2_widget.dart';
import 'package:vierqr/features/bank_card/widgets/bank_infro_widget.dart';
import 'package:vierqr/features/bank_card/widgets/build_banner_widget.dart';
import 'package:vierqr/features/bank_card/widgets/display_setting_widget.dart';
import 'package:vierqr/features/bank_card/widgets/invoice_overview_widget.dart';
import 'package:vierqr/features/bank_card/widgets/menu_bank_widget.dart';
import 'package:vierqr/features/bank_card/widgets/no_service_widget.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/features/bank_detail_new/widgets/animation_graph_widget.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/personal/views/noti_verify_email_widget.dart';
import 'package:vierqr/features/setting_bdsd/setting_bdsd_screen.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/platform_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BankStatistic extends StatefulWidget {
  final VoidCallback onStore;
  final GlobalKey textFielddKey;
  final FocusNode focusNode;
  final GlobalKey animatedKey;
  final ValueNotifier<bool> scrollNotifer;

  const BankStatistic({
    super.key,
    required this.onStore,
    required this.textFielddKey,
    required this.focusNode,
    required this.animatedKey,
    required this.scrollNotifer,
  });

  @override
  State<BankStatistic> createState() => _BankStatisticState();
}

class _BankStatisticState extends State<BankStatistic>
    with AutomaticKeepAliveClientMixin {
  late final BankBloc _bloc = getIt.get<BankBloc>();

  bool isVerify = false;
  BankAccountDTO? bankSelect;
  List<BankAccountDTO>? listIsOwnerBank;

  final List<String> listText = [
    'Quét mã VietQR của bạn để thêm tài khoản ngân hàng!',
  ];
  @override
  void initState() {
    super.initState();
    handleMessageOnBackground();
    listIsOwnerBank = SharePrefUtils.getOwnerBanks();
    isVerify = SharePrefUtils.getProfile().verify;
  }

  void handleMessageOnBackground() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data['transactionReceiveId'] != null) {
            NavigatorUtils.navigatePage(
                context,
                TransactionDetailScreen(
                    transactionId: remoteMessage.data['transactionReceiveId']),
                routeName: TransactionDetailScreen.routeName);
          }
        }
      },
    );
  }

  void _saveImageTaskStreamReceiver(List<BankTypeDTO> list) async {
    List<BankTypeDTO> listLocal = [];
    final receivePort = ReceivePort();
    Isolate.spawn(saveImageTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is SaveImageData) {
        if (message.index != null) {
          BankTypeDTO dto = list[message.index!];

          String path = dto.imageId;
          if (!path.contains('.png')) {
            path = '$path.png';
          }

          String localPath = await saveImageToLocal(message.progress, path);
          dto.photoPath = localPath;
          listLocal.add(dto);
        }

        if (message.isDone) {
          receivePort.close();
          if (!mounted) return;
          for (int i = 0; i < listLocal.length; i++) {
            UserRepository.instance.updateBanks(listLocal[i]);
          }
          return;
        }
      }
    }
  }

  final List<String> labels = [
    "Giới thiệu",
    "Khai báo TT kinh doanh",
    "Khai báo TT kết nối dịch vụ",
    "Kết nối dịch vụ",
    "Nghiệm thu",
    "Golive"
  ];

  void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<BankTypeDTO> list = args[1];

    for (var message in list) {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}images/${message.imageId}';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      sendPort
          .send(SaveImageData(progress: bytes, index: list.indexOf(message)));
    }
    sendPort.send(SaveImageData(progress: Uint8List(0), isDone: true));
  }

  List<BankAccountDTO> get bankList => _bloc.state.listBanks;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    super.build(context);

    return BlocConsumer<BankBloc, BankState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == BankType.GET_BANK) {
          _saveImageTaskStreamReceiver(state.listBankTypeDTO);
        }

        if (state.request == BankType.ARRANGE &&
            state.status == BlocStatus.SUCCESS) {
          _bloc.add(const BankCardEventGetList(
              isGetOverview: true, isLoadInvoice: false));
          _bloc.add(GetInvoiceOverview());
        }

        if (state.request == BankType.VERIFY) {
          isVerify = SharePrefUtils.getProfile().verify;
        }
        if (state.request == BankType.BANK) {
          isVerify = SharePrefUtils.getProfile().verify;
        }
        if (state.bankSelect != null && !state.isEmpty) {
          bankSelect = state.bankSelect;
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: VietQRTheme.gradientColor.lilyLinear,
          ),
          child: Container(
            // padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: AppColor.WHITE,
              // borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bankSelect != null &&
                    !bankSelect!.isValidService &&
                    bankSelect!.isAuthenticated &&
                    bankSelect?.bankTypeStatus == 1) ...[
                  const SizedBox(height: 20),
                  SlideFadeTransition(
                    offset: 1,
                    delayStart: const Duration(milliseconds: 20),
                    direction: Direction.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NotiVerifyEmailWidget(
                        dto: bankSelect!,
                        isVerify: isVerify,
                      ),
                    ),
                  ),
                ],
                // StepProgressView(
                //   height: 220,
                //   curStep: 4,
                //   color: AppColor.BLUE_TEXT,
                //   titles: labels,
                // ),
                if (bankSelect != null &&
                    bankSelect?.bankTypeStatus == 1 &&
                    state.listBanks.isNotEmpty)
                  SlideFadeTransition(
                    offset: 1,
                    delayStart: const Duration(milliseconds: 20),
                    direction: Direction.horizontal,
                    child: BankInfroV2Widget(
                      dto: bankSelect!,
                      isLoading: state.status == BlocStatus.LOADING &&
                          state.request != BankType.GET_OVERVIEW,
                    ),
                  ),

                const SizedBox(height: 20),

                // const BuildBannerWidget(),
                const InvoiceOverviewWidget(),
                // if (bankSelect != null && bankSelect?.bankTypeStatus == 1) ...[
                //   const SizedBox(height: 20),
                //   OverviewStatistic(
                //     bankDto: bankSelect!,
                //   ),
                // ],
                if (state.listBanks.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  MenuBankWidget(
                    onStore: () {
                      widget.onStore.call();
                    },
                  ),
                ],
                // const SizedBox(height: 20),
                // _voiceWidget(),
                if (state.listBanks.isNotEmpty && bankSelect != null) ...[
                  AnimationGraphWidget(
                    margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                    dto: bankSelect!,
                    scrollNotifer: widget.scrollNotifer,
                    key: widget.animatedKey,
                    isHome: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BankCardDetailNewScreen(
                              page: 1,
                              dto: bankSelect!,
                              bankId: bankSelect!.id),
                          settings: const RouteSettings(
                            name: Routes.BANK_CARD_DETAIL_NEW,
                          ),
                        ),
                      );
                    },
                  ),
                  // LatestTransWidget(
                  //   isHome: true,
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => BankCardDetailNewScreen(
                  //             page: 1,
                  //             dto: bankSelect!,
                  //             bankId: bankSelect!.id),
                  //         settings: const RouteSettings(
                  //           name: Routes.BANK_CARD_DETAIL_NEW,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
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
                                    autoPlayInterval:
                                        const Duration(seconds: 1),
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
                if (state.listBanks.isEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, 0, 20, MediaQuery.of(context).viewInsets.bottom),
                    child: BanksView(
                      focusNode: widget.focusNode,
                      key: widget.textFielddKey,
                    ),
                  ),

                if (bankSelect != null &&
                    bankSelect?.bankTypeStatus == 1 &&
                    state.listBanks.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chia sẻ Biến động số động',
                          style: TextStyle(
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        (state.listPlaforms == null ||
                                state.listPlaforms!.isEmpty ||
                                state.listPlaforms!.length == 1)
                            ? NoServiceWidget(
                                bankSelect: state.bankSelect!,
                              )
                            : Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 12, right: 12, top: 20),
                                    // padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: StepProgressView(
                                        curStep: 1,
                                        height: state.listPlaforms!.length == 5
                                            ? 250
                                            : state.listPlaforms!.length == 4
                                                ? 200
                                                : state.listPlaforms!.length ==
                                                        3
                                                    ? 150
                                                    : 80,
                                        listItem: List.generate(
                                            state.listPlaforms!.length,
                                            (index) {
                                          return SizedBox(
                                            width: 310,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColor.BLACK
                                                              .withOpacity(0.1),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        )
                                                      ]),
                                                  child: XImage(
                                                    imagePath:
                                                        _buildIconPlatform(state
                                                            .listPlaforms![
                                                                index]
                                                            .platform),
                                                    height: 28,
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    state.listPlaforms![index]
                                                        .platformId,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                 const SizedBox(width: 10,),
                                                const Text(
                                                  'Hoạt động',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.GREEN),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                        activeColor: Colors.black),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFE1EFFF),
                                            Color(0xFFE5F9FF),
                                          ],
                                          end: Alignment.centerRight,
                                          begin: Alignment.centerLeft,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: AppColor.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Image(
                                              image: ImageUtils.instance
                                                  .getImageNetWork(
                                                      state.bankSelect!.imgId),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state.bankSelect!.bankAccount,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  state
                                                      .bankSelect!.userBankName,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              gradient: VietQRTheme
                                                  .gradientColor
                                                  .brightBlueLinear,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Kết nối mới',
                                              style: TextStyle(
                                                color: AppColor.WHITE,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                  DisplaySettingWidget(
                      listIsOwnerBank: listIsOwnerBank ?? [],
                      width: double.infinity),
                ],
                const SizedBox(height: 200),
              ],
            ),
          ),
        );
      },
    );
  }

  // List<Widget> widgetList = [
  //   ListView.builder(
  //     itemBuilder: (context, index) {
  //       Container(
  //         width: 300,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Kế toán Katinat HCM',
  //               style: TextStyle(
  //                 fontSize: 12,
  //               ),
  //             ),
  //             Text(
  //               'Hoạt động',
  //               style: TextStyle(fontSize: 12, color: AppColor.GREEN),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   )
  // ];

  String _buildIconPlatform(String platform) {
    String img = '';
    switch (platform) {
      case 'Google Chat':
        img = ImageConstant.logoGGChatHome;
        break;
      case 'Telegram':
        img = ImageConstant.logoTelegramDash;
        break;
      case 'Lark':
        img = ImageConstant.logoLarkDash;
        break;
      case 'Slack':
        img = ImageConstant.logoSlackHome;
        break;
      case 'Discord':
        img = ImageConstant.logoDiscordHome;
        break;
      case 'Google Sheet':
        img = ImageConstant.logoGGSheetHome;
        break;
      default:
    }

    return img;
  }

  Widget _voiceWidget() {
    return InkWell(
      onTap: () async {
        final list = SharePrefUtils.getOwnerBanks();
        if (list != null) {
          NavigatorUtils.navigatePage(
              context,
              SettingBDSD(
                listIsOwnerBank: list,
              ),
              routeName: SettingBDSD.routeName);
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 20, 8),
        height: 80,
        decoration: BoxDecoration(
          gradient: VietQRTheme.gradientColor.lilyLinear,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            XImage(
              imagePath: 'assets/images/ic-voice-black.png',
              color: AppColor.BLUE_TEXT,
              height: 50,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thông báo BĐSD bằng giọng nói',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tùy chỉnh thông báo giọng nói cho từng tài khoản ngân hàng đã liên kết',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: XImage(
                imagePath: 'assets/images/ic-arrow-boder-blue.png',
                width: 18,
                height: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
