import 'dart:async';
import 'dart:isolate';

import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/context_extensions.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/bank_appbar_widget.dart';
import 'package:vierqr/features/bank_card/widgets/bank_statistic.dart';
import 'package:vierqr/features/bank_card/widgets/list_bank.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/personal/views/noti_verify_email_widget.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/share_bdsd/share_bdsd_screen.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:rive/rive.dart' as rive;
import '../../services/providers/maintain_charge_provider.dart';
import 'widgets/card_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
part './widgets/banks.dart';
part './widgets/banks_authenticated.dart';
part './widgets/banks_un_authenticated.dart';
part './widgets/bottom_section.dart';
part './widgets/extend_annual_fee.dart';

class BankScreen extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onStore;

  const BankScreen({
    super.key,
    required this.onStore,
    required this.scrollController,
  });

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final List<Widget> cardWidgets = [];
  // final scrollController = ScrollController();
  final carouselController = CarouselController();
  rive.StateMachineController? _riveController;
  late rive.SMITrigger _action;

  final ValueNotifier<double> _opacityNotifier = ValueNotifier<double>(0.0);

  late final BankBloc _bloc = getIt.get<BankBloc>();

  String userId = SharePrefUtils.getProfile().userId;

  initData({bool isRefresh = false}) {
    widget.scrollController.addListener(
      () {
        _opacityNotifier.value =
            widget.scrollController.offset > 100 ? 1.0 : 0.0;
      },
    );
    if (isRefresh) {
      getIt.get<DashBoardBloc>().add(GetPointEvent());
    }

    _bloc.add(LoadDataBankEvent());
    _bloc.add(GetInvoiceOverview());
    _bloc.add(const BankCardEventGetList(isGetOverview: true));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void getListBank(BuildContext context) {
    _bloc.add(BankCardEventGetList());
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    _bloc.add(QREventGenerateList(list: list));
  }

  Future<void> _refresh() async {
    _bloc.add(const BankCardEventGetList(isGetOverview: true));
    _bloc.add(GetInvoiceOverview());
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(
      () {},
    );
  }

  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, Stringify.SUCCESS_ANI_STATE_MACHINE)!;
    artboard.addController(_riveController!);
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action =
        _riveController!.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_INIT)
            as rive.SMITrigger;
    _action.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              BankAppbarWidget(
                notifier: _opacityNotifier,
              ),
              CupertinoSliverRefreshControl(
                builder: (context, refreshState, pulledExtent,
                    refreshTriggerPullDistance, refreshIndicatorExtent) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 25,
                    height: 25,
                    child: rive.RiveAnimation.asset(
                      'assets/rives/loading_ani',
                      fit: BoxFit.contain,
                      antialiasing: false,
                      animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
                      onInit: _onRiveInit,
                    ),
                  );
                },
                onRefresh: () => _refresh(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ListBankWidget(),
                    BankStatistic(
                      onStore: () {
                        widget.onStore.call();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // Expanded(
        //   child: RefreshIndicator(
        //     onRefresh: _refresh,
        //     child: ListView(
        //       padding:
        //           const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        //       children: [
        //         const SizedBox(height: 20),
        //         NotiVerifyEmailWidget(
        //           isVerify: isVerify,
        //         ),
        //         const SizedBox(height: 20),
        //         const ExtendAnnualFee(),
        //         const BanksAuthenticated(),
        //         const BanksUnAuthenticated(),
        //         _loading(),
        //         const BanksView(),
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 4),
        // const BottomSection(),
      ],
    );
  }

  Widget _loading() {
    return BlocSelector<BankBloc, BankState, BlocStatus>(
      bloc: _bloc,
      selector: (state) => state.status,
      builder: (context, state) {
        if (state == BlocStatus.LOADING) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
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
}
