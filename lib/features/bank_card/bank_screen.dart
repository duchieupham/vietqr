import 'dart:async';
import 'dart:isolate';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/share_bdsd/share_bdsd_screen.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../services/providers/maintain_charge_provider.dart';
import 'widgets/card_widget.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankBloc>(
      create: (BuildContext context) => BankBloc(context),
      child: const _BankScreen(),
    );
  }
}

class _BankScreen extends StatefulWidget {
  const _BankScreen();

  @override
  State<_BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<_BankScreen>
    with AutomaticKeepAliveClientMixin {
  final List<Widget> cardWidgets = [];
  final scrollController = ScrollController();
  final carouselController = CarouselController();

  late BankBloc _bloc;

  String userId = SharePrefUtils.getProfile().userId;

  StreamSubscription? _subscription;

  initialServices(BuildContext context) {
    _bloc = BlocProvider.of(context);
  }

  initData({bool isRefresh = false}) {
    if (isRefresh) {
      context.read<DashBoardBloc>().add(GetPointEvent());
    }
    _bloc.add(BankCardEventGetList());
    _bloc.add(LoadDataBankEvent());
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    handleMessageOnBackground();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    // _subscription = eventBus.on<GetListBankScreen>().listen((_) {
    //   _bloc.add(BankCardEventGetList());
    // });
  }

  void onActiveKey({
    required String bankId,
    required String bankCode,
    required String bankName,
    required String bankAccount,
    required String userBankName,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: MediaQuery.of(context).size.height * 0.38,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    "Thanh toán phí \ndịch vụ phần mềm VietQR",
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.MAINTAIN_CHARGE_SCREEN,
                        arguments: {
                          'type': 0,
                          'bankId': bankId,
                          'bankCode': bankCode,
                          'bankName': bankName,
                          'bankAccount': bankAccount,
                          'userBankName': userBankName,
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text("Kích hoạt bằng mã"),
                            ),
                            const SizedBox(height: 3),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              child: Text(
                                  "Sử dụng mã để kích hoạt \ndịch vụ nhận biến động số dư."),
                            )
                          ],
                        ),
                        Image.asset(
                          AppImages.icPassUnlock,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.MAINTAIN_CHARGE_SCREEN,
                        arguments: {
                          'type': 1,
                          'bankId': bankId,
                          'bankCode': bankCode,
                          'bankName': bankName,
                          'bankAccount': bankAccount,
                          'userBankName': userBankName,
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text("Quét mã VietQR"),
                            ),
                            const SizedBox(height: 3),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              child: Text(
                                  "Quét mã VietQR để thanh toán \nphí dịch vụ."),
                            )
                          ],
                        ),
                        Image.asset(
                          AppImages.icVietQrSemiSmall,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void getListBank(BuildContext context) {
    _bloc.add(BankCardEventGetList());
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    _bloc.add(QREventGenerateList(list: list));
  }

  Future<void> _refresh() async {
    initData();
  }

  static void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<BankTypeDTO> list = args[1];

    for (var message in list) {
      String url = '${EnvConfig.getBaseUrl()}images/${message.imageId}';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      sendPort
          .send(SaveImageData(progress: bytes, index: list.indexOf(message)));
    }
    sendPort.send(SaveImageData(progress: Uint8List(0), isDone: true));
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
            path = path + '.png';
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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<BankBloc, BankState>(
      listener: (context, state) async {
        if (state.request == BankType.GET_BANK) {
          _saveImageTaskStreamReceiver(state.listBankTypeDTO);
        }

        if (state.request == BankType.BANK) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateBanks(state.listBanks);

          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
        }
      },
      builder: (context, state) {
        List<BankAccountDTO> extendAnnualFeeList = [];
        DateTime now = DateTime.now();
        DateTime sevenDaysFromNow = now.add(Duration(days: 7));
        int sevenDaysFromNowTimestamp =
            sevenDaysFromNow.millisecondsSinceEpoch ~/ 1000;
        extendAnnualFeeList = state.listBanks
            .where((element) =>
                element.isValidService == true &&
                element.validFeeTo! - sevenDaysFromNowTimestamp <= 7)
            .toList();
        List<BankAccountDTO> listAuthenticated = state.listBanks
            .where((element) => element.isAuthenticated == true)
            .toList();

        List<BankAccountDTO> listUnAuthenticated = state.listBanks
            .where((element) => element.isAuthenticated == false)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  children: [
                    if (extendAnnualFeeList.isNotEmpty) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: (extendAnnualFeeList.length *
                                (extendAnnualFeeList.length != 1 ? 120 : 135)) -
                            extendAnnualFeeList.length * 12 -
                            (extendAnnualFeeList.length - 1) * 8,
                        child: Stack(
                          children: [
                            Container(
                              height: 90,
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF3DF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Gia hạn dịch vụ phần mềm VietQR",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Container(
                                height: (extendAnnualFeeList.length * 100) -
                                    extendAnnualFeeList.length * 12 -
                                    (extendAnnualFeeList.length - 1) * 8,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    ...extendAnnualFeeList.map((e) {
                                      int index =
                                          extendAnnualFeeList.indexOf(e);
                                      return Positioned(
                                        top: index * 65,
                                        left: 0,
                                        right: 0,
                                        child: CardWidget(
                                          isExtend: true,
                                          isAuthen: false,
                                          listBanks: extendAnnualFeeList,
                                          index: index,
                                          onLinked: () => onLinked(context,
                                              extendAnnualFeeList[index]),
                                          onActive: () {
                                            Provider.of<MaintainChargeProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedBank(
                                                    extendAnnualFeeList[index]
                                                        .bankAccount,
                                                    extendAnnualFeeList[index]
                                                        .bankShortName);
                                            onActiveKey(
                                              bankId:
                                                  extendAnnualFeeList[index].id,
                                              bankCode:
                                                  extendAnnualFeeList[index]
                                                      .bankCode,
                                              bankName:
                                                  extendAnnualFeeList[index]
                                                      .bankName,
                                              bankAccount:
                                                  extendAnnualFeeList[index]
                                                      .bankAccount,
                                              userBankName:
                                                  extendAnnualFeeList[index]
                                                      .userBankName,
                                            );
                                          },
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (listAuthenticated.isNotEmpty) ...[
                      // const SizedBox(height: 12),
                      Text(
                        'Tài khoản liên kết',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: (listAuthenticated.length * 160) -
                            listAuthenticated.length * 12 -
                            (listAuthenticated.length - 1) * 8,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: listAuthenticated.map((e) {
                            int index = listAuthenticated.indexOf(e);
                            return Positioned(
                              top: index * 140,
                              left: 0,
                              right: 0,
                              child: CardWidget(
                                isExtend: false,
                                isAuthen:
                                    listAuthenticated[index].isAuthenticated,
                                listBanks: listAuthenticated,
                                index: index,
                                onLinked: () =>
                                    onLinked(context, listAuthenticated[index]),
                                onActive: () {
                                  Provider.of<MaintainChargeProvider>(context,
                                          listen: false)
                                      .selectedBank(
                                          listAuthenticated[index].bankAccount,
                                          listAuthenticated[index]
                                              .bankShortName);
                                  onActiveKey(
                                    bankId: listAuthenticated[index].id,
                                    bankCode: listAuthenticated[index].bankCode,
                                    bankName: listAuthenticated[index].bankName,
                                    bankAccount:
                                        listAuthenticated[index].bankAccount,
                                    userBankName:
                                        listAuthenticated[index].userBankName,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (listUnAuthenticated.isNotEmpty) ...[
                      Text(
                        'Tài khoản lưu trữ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const SizedBox(height: 12),
                      SizedBox(
                        height: (listUnAuthenticated.length * 126) -
                            listUnAuthenticated.length * 12 -
                            (listUnAuthenticated.length - 1) * 8,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: listUnAuthenticated.map((e) {
                            int index = listUnAuthenticated.indexOf(e);
                            return Positioned(
                              top: index * 106,
                              left: 0,
                              right: 0,
                              child: CardWidget(
                                isExtend: false,
                                isAuthen:
                                    listUnAuthenticated[index].isAuthenticated,
                                listBanks: listUnAuthenticated,
                                index: index,
                                onLinked: () => onLinked(
                                    context, listUnAuthenticated[index]),
                                onActive: () {
                                  Provider.of<MaintainChargeProvider>(context,
                                          listen: false)
                                      .selectedBank(
                                          listUnAuthenticated[index]
                                              .bankAccount,
                                          listUnAuthenticated[index]
                                              .bankShortName);
                                  onActiveKey(
                                    bankId: listUnAuthenticated[index].id,
                                    bankCode:
                                        listUnAuthenticated[index].bankCode,
                                    bankName:
                                        listUnAuthenticated[index].bankName,
                                    bankAccount:
                                        listUnAuthenticated[index].bankAccount,
                                    userBankName:
                                        listUnAuthenticated[index].userBankName,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else if (state.status == BlocStatus.LOADING)
                      Container(
                        height: 120,
                        child: const Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                          ),
                        ),
                      ),
                    _buildListBankType(
                      isEmpty: state.isEmpty,
                      list: state.listBankTypeDTO,
                      listBanks: state.listBanks,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            _buildListSection(),
          ],
        );
      },
    );
  }

  void onLinked(BuildContext context, BankAccountDTO dto) async {
    BankTypeDTO bankTypeDTO = BankTypeDTO(
      id: dto.bankTypeId,
      bankCode: dto.bankCode,
      bankName: dto.bankName,
      imageId: dto.imgId,
      bankShortName: dto.bankCode,
      status: dto.bankTypeStatus,
      caiValue: dto.caiValue,
      bankId: dto.id,
      bankAccount: dto.bankAccount,
      userBankName: dto.userBankName,
    );
    await NavigatorUtils.navigatePage(
        context, AddBankScreen(bankTypeDTO: bankTypeDTO),
        routeName: AddBankScreen.routeName);
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }

  Widget _buildListSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildSection(
                pathIcon: 'assets/images/ic-copy-qr.png',
                radiusRight: 0,
                onTap: () async {
                  if (SharePrefUtils.getQrIntro()) {
                    startBarcodeScanStream();
                  } else {
                    await DialogWidget.instance.showFullModalBottomContent(
                      widget: const QRScanWidget(),
                      color: AppColor.BLACK,
                    );
                    if (!mounted) return;
                    startBarcodeScanStream();
                  }
                },
                title: 'Copy QR',
              ),
            ),
            Container(
              height: isSmall ? 40 : 60,
              child: VerticalDashedLine(),
            ),
            Expanded(
              child: _buildSection(
                pathIcon: 'assets/images/ic-add-bank.png',
                radiusRight: 0,
                radiusLeft: 0,
                onTap: () async {
                  await NavigatorUtils.navigatePage(context, AddBankScreen(),
                      routeName: AddBankScreen.routeName);
                },
                title: 'Thêm Tài khoản',
              ),
            ),
            Container(
              height: isSmall ? 40 : 60,
              child: VerticalDashedLine(),
            ),
            Expanded(
              child: _buildSection(
                pathIcon: 'assets/images/ic-share-bdsd.png',
                radiusLeft: 0,
                onTap: () async {
                  NavigatorUtils.navigatePage(context, ShareBDSDScreen(),
                      routeName: 'share_bdsd_screen');
                },
                title: 'Chia sẻ BĐSD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListBankType({
    bool isEmpty = false,
    List<BankTypeDTO> list = const [],
    List<BankAccountDTO> listBanks = const [],
  }) {
    if (isEmpty || listBanks.length <= 5) {
      final height = MediaQuery.of(context).size.height;
      return Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Thêm tài khoản ngân hàng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 2,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var data = list[index];
                  return GestureDetector(
                    onTap: () async {
                      await NavigatorUtils.navigatePage(
                          context, AddBankScreen(bankTypeDTO: data),
                          routeName: AddBankScreen.routeName);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.WHITE,
                            image: data.fileBank != null
                                ? DecorationImage(
                                    image: FileImage(data.fileBank!))
                                : DecorationImage(
                                    image: ImageUtils.instance
                                        .getImageNetWork(data.imageId)),
                          ),
                          margin: EdgeInsets.all(4),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: data.linkType == LinkBankType.LINK
                              ? Image.asset(
                                  'assets/images/ic-authenticated-bank.png',
                                  width: 20)
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  bool get isSmall => MediaQuery.of(context).size.height < 800;

  Widget _buildSection({
    required String pathIcon,
    required GestureTapCallback? onTap,
    String title = '',
    double? radiusLeft,
    double? radiusRight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isSmall ? 6 : 8, horizontal: isSmall ? 6 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(radiusLeft ?? 8),
            right: Radius.circular(radiusRight ?? 8),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Image.asset(
              pathIcon,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
