import 'dart:async';
import 'dart:isolate';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'widgets/card_widget.dart';
import 'widgets/custom_dot_paint.dart';
import 'package:http/http.dart' as http;

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

  String userId = UserHelper.instance.getUserId();

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
    _subscription = eventBus.on<GetListBankScreen>().listen((_) {
      _bloc.add(BankCardEventGetList());
    });
  }

  void handleMessageOnBackground() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data['transactionReceiveId'] != null) {
            Navigator.pushNamed(
              NavigationService.navigatorKey.currentContext!,
              Routes.TRANSACTION_DETAIL,
              arguments: {
                'transactionId': remoteMessage.data['transactionReceiveId'],
              },
            );
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
          dto.fileImage = localPath;
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
          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
        }
      },
      builder: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: [
                    if (state.listBanks.isNotEmpty) ...[
                      Text(
                        'Danh sách tài khoản',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: (state.listBanks.length * 120) -
                            state.listBanks.length * 12 -
                            (state.listBanks.length - 1) * 8,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: state.listBanks.map((e) {
                            int index = state.listBanks.indexOf(e);
                            return Positioned(
                              top: index * 100,
                              left: 0,
                              right: 0,
                              child: CardWidget(
                                listBanks: state.listBanks,
                                index: index,
                                onLinked: () =>
                                    onLinked(context, state.listBanks[index]),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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
                  if (QRScannerHelper.instance.getQrIntro()) {
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
            CustomPaint(painter: DottedLinePainter(isSmall ? 1.8 : 1.9)),
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
            CustomPaint(painter: DottedLinePainter(isSmall ? 1.8 : 1.9)),
            Expanded(
              child: _buildSection(
                pathIcon: 'assets/images/ic-share-bdsd.png',
                radiusLeft: 0,
                onTap: () async {
                  // await Navigator.pushNamed(context, Routes.ADD_BANK_CARD);
                  // getListBank(context);
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
            Text(
              'Thêm tài khoản ngân hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                            image: data.file != null
                                ? DecorationImage(image: FileImage(data.file!))
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
