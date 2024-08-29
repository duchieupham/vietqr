import 'dart:isolate';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/commons/widgets/slide_fade_transition.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/bank_infro_widget.dart';
import 'package:vierqr/features/bank_card/widgets/build_banner_widget.dart';
import 'package:vierqr/features/bank_card/widgets/invoice_overview_widget.dart';
import 'package:vierqr/features/bank_card/widgets/latest_trans_widget.dart';
import 'package:vierqr/features/bank_card/widgets/menu_bank_widget.dart';
import 'package:vierqr/features/bank_card/widgets/overview_statistic.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/personal/views/noti_verify_email_widget.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/features/verify_email/widgets/popup_key_free.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BankStatistic extends StatefulWidget {
  final VoidCallback onStore;
  final GlobalKey textFielddKey;
  final FocusNode focusNode;
  const BankStatistic({
    super.key,
    required this.onStore,
    required this.textFielddKey,
    required this.focusNode,
  });

  @override
  State<BankStatistic> createState() => _BankStatisticState();
}

class _BankStatisticState extends State<BankStatistic>
    with AutomaticKeepAliveClientMixin {
  late final BankBloc _bloc = getIt.get<BankBloc>();

  bool isVerify = false;
  BankAccountDTO? bankSelect;

  @override
  void initState() {
    super.initState();
    handleMessageOnBackground();
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
            decoration: BoxDecoration(
                color: AppColor.WHITE.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                if (state.status == BlocStatus.LOADING &&
                    state.request != BankType.GET_OVERVIEW)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.BLACK.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: const Row(
                      children: [
                        ShimmerBlock(height: 30, width: 30, borderRadius: 100),
                        SizedBox(width: 6),
                        ShimmerBlock(height: 14, width: 80, borderRadius: 10),
                        Spacer(),
                        ShimmerBlock(height: 12, width: 120, borderRadius: 10),
                      ],
                    ),
                  )
                else if (bankSelect != null && bankSelect?.bankTypeStatus == 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: BankInfroWidget(dto: bankSelect!),
                  ),
                if (bankSelect != null &&
                    !bankSelect!.isValidService! &&
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
                const BuildBannerWidget(),
                const InvoiceOverviewWidget(),
                if (bankSelect != null && bankSelect?.bankTypeStatus == 1) ...[
                  const SizedBox(height: 20),
                  OverviewStatistic(
                    bankDto: bankSelect!,
                  ),
                ],
                if (state.listBanks.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  MenuBankWidget(
                    onStore: () {
                      widget.onStore.call();
                    },
                  ),
                ],
                if (state.listBanks.isNotEmpty && bankSelect != null) ...[
                  LatestTransWidget(
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
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
