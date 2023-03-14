import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QRInformationView extends StatelessWidget {
  final BusinessInformationBloc businessInformationBloc;

  const QRInformationView({
    Key? key,
    required this.businessInformationBloc,
  }) : super(key: key);

  //blocs
  static late BankCardBloc _bankCardBloc;
  static late QRBloc _qrBloc;

  //list
  static final List<BankAccountDTO> _bankAccounts = [];
  static final List<QRGeneratedDTO> _qrGenerateds = [];
  static final List<Widget> _cardWidgets = [];
  static final List<GlobalKey> _keys = [];
  //controller
  static final PageController _pageController =
      PageController(initialPage: 0, keepPage: false, viewportFraction: 1);
  static final CarouselController _carouselController = CarouselController();

  void initialServices(BuildContext context) {
    _bankAccounts.clear();
    _cardWidgets.clear();
    _qrGenerateds.clear();
    _bankCardBloc = BlocProvider.of(context);
    _qrBloc = BlocProvider.of(context);

    getListBank(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-qr.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(top: 0)),
          Expanded(
            child: BlocConsumer<BankCardBloc, BankCardState>(
              listener: ((context, state) {
                if (state is BankCardGetListSuccessState) {
                  resetProvider(context);
                  if (_bankAccounts.isEmpty) {
                    _bankAccounts.addAll(state.list);
                    List<QRCreateDTO> qrCreateDTOs = [];
                    if (_bankAccounts.isNotEmpty) {
                      for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                        QRCreateDTO qrCreateDTO = QRCreateDTO(
                          bankId: bankAccountDTO.id,
                          amount: '',
                          content: '',
                          branchId: '',
                          businessId: '',
                        );
                        qrCreateDTOs.add(qrCreateDTO);
                      }
                      getListQR(context, qrCreateDTOs);
                    }
                  }
                }
                if (state is BankCardRemoveSuccessState ||
                    state is BankCardInsertSuccessfulState) {
                  getListBank(context);
                }
              }),
              builder: ((context, state) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: BlocBuilder<QRBloc, QRState>(
                    builder: (context, state) {
                      if (state is QRGeneratedListSuccessfulState) {
                        _cardWidgets.clear();
                        _qrGenerateds.clear();
                        if (state.list.isNotEmpty) {
                          if (_qrGenerateds.isEmpty) {
                            _qrGenerateds.addAll(state.list);
                            if (_qrGenerateds.isNotEmpty) {
                              for (QRGeneratedDTO dto in _qrGenerateds) {
                                final Widget qrWidget = UnconstrainedBox(
                                  child: VietQRWidget(
                                    width: width - 10,
                                    qrGeneratedDTO: dto,
                                    content: '',
                                    isCopy: true,
                                    isStatistic: true,
                                  ),
                                );
                                _cardWidgets.add(qrWidget);
                              }
                            }
                          }
                        }
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 50)),
                          Expanded(
                            child: (_qrGenerateds.isEmpty)
                                ? UnconstrainedBox(
                                    child: BoxLayout(
                                      width: width - 60,
                                      // height: (width - 40) / Numeral.BANK_CARD_RATIO,
                                      borderRadius: 15,
                                      alignment: Alignment.center,
                                      bgColor: Theme.of(context).cardColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic-card.png',
                                            width: width * 0.4,
                                          ),
                                          const Text(
                                            'Chưa có tài khoản ngân hàng được liên kết.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          ButtonIconWidget(
                                            width: width,
                                            icon: Icons.credit_card_rounded,
                                            title: 'Liên kết ngay',
                                            function: () {
                                              Navigator.pushNamed(
                                                context,
                                                Routes.ADD_BANK_CARD,
                                              ).then(
                                                (value) {
                                                  Provider.of<BankAccountProvider>(
                                                          context,
                                                          listen: false)
                                                      .reset();
                                                },
                                              );
                                            },
                                            bgColor: DefaultTheme.PURPLE_NEON,
                                            textColor: DefaultTheme.WHITE,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: width,
                                    child: CarouselSlider(
                                      carouselController: _carouselController,
                                      items: _cardWidgets,
                                      options: CarouselOptions(
                                        aspectRatio: 1,
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        viewportFraction: 1,
                                        autoPlayInterval:
                                            const Duration(seconds: 5),
                                        disableCenter: true,
                                        onPageChanged: ((index, reason) {
                                          Provider.of<BankAccountProvider>(
                                                  context,
                                                  listen: false)
                                              .updateIndex(index);
                                        }),
                                      ),
                                    ),
                                  ),
                          ),
                          (_qrGenerateds.isEmpty)
                              ? const SizedBox()
                              : Container(
                                  width: width,
                                  height: 10,
                                  alignment: Alignment.center,
                                  child: Consumer<BankAccountProvider>(
                                      builder: (context, page, child) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _qrGenerateds.length,
                                        itemBuilder: ((context, index) =>
                                            _buildDot((index ==
                                                page.indexSelected))));
                                  }),
                                ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          SizedBox(
            width: width,
            height: 40,
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                ButtonIconWidget(
                  width: width / 2 - 25,
                  height: 40,
                  icon: Icons.copy_rounded,
                  title: 'Sao chép nội dung',
                  function: () async {
                    if (_bankAccounts.isNotEmpty && _qrGenerateds.isNotEmpty) {
                      int index = Provider.of<BankAccountProvider>(context,
                              listen: false)
                          .indexSelected;
                      await FlutterClipboard.copy(ShareUtils.instance
                              .getTextSharing(_qrGenerateds[index]))
                          .then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    } else {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Không thể chia sẻ',
                          msg:
                              'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                    }
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: DefaultTheme.BLUE_TEXT,
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                ButtonIconWidget(
                  width: width / 2 - 25,
                  height: 40,
                  icon: Icons.share_rounded,
                  title: 'Chia sẻ mã QR',
                  function: () {
                    if (_bankAccounts.isNotEmpty && _qrGenerateds.isNotEmpty) {
                      int index = Provider.of<BankAccountProvider>(context,
                              listen: false)
                          .indexSelected;
                      Navigator.pushNamed(context, Routes.QR_SHARE_VIEW,
                          arguments: {'qrGeneratedDTO': _qrGenerateds[index]});
                    } else {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Không thể chia sẻ',
                          msg:
                              'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                    }
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: DefaultTheme.GREEN,
                ),
                const Padding(padding: EdgeInsets.only(left: 20)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ButtonIconWidget(
            width: width - 40,
            height: 40,
            icon: Icons.add_rounded,
            title: 'Tạo QR giao dịch',
            function: () {
              if (_bankAccounts.isNotEmpty && _qrGenerateds.isNotEmpty) {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => CreateQR(
                      bankAccountDTO: _bankAccounts[
                          Provider.of<BankAccountProvider>(context,
                                  listen: false)
                              .indexSelected],
                    ),
                  ),
                )
                    .then((value) {
                  String userId = UserInformationHelper.instance.getUserId();
                  businessInformationBloc.add(
                    BusinessInformationEventGetList(userId: userId),
                  );
                });
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: 'Không thể tạo mã QR thanh toán',
                    msg: 'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
              }
            },
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.GREEN,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: (PlatformUtils.instance.isAndroidApp(context)) ? 90 : 110,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isSelected) {
    return Container(
      width: (isSelected) ? 20 : 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: (isSelected)
            ? Border.all(color: DefaultTheme.GREY_LIGHT, width: 0.5)
            : null,
        color: (isSelected) ? DefaultTheme.WHITE : DefaultTheme.GREY_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void getListBank(BuildContext context) {
    _bankAccounts.clear();
    _cardWidgets.clear();
    String userId = UserInformationHelper.instance.getUserId();
    _bankCardBloc.add(BankCardEventGetList(userId: userId));
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    _qrGenerateds.clear();
    _qrBloc.add(QREventGenerateList(list: list));
  }

  void resetProvider(BuildContext context) {
    _bankAccounts.clear();
    _cardWidgets.clear();
    _qrGenerateds.clear();
    Provider.of<BankAccountProvider>(context, listen: false).updateIndex(0);
    if (_pageController.positions.isNotEmpty) {
      _pageController.jumpToPage(0);
    }
  }
}
