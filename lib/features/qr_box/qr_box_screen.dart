import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/create_store/create_store_screen.dart';
import 'package:vierqr/features/qr_box/blocs/qr_box_bloc.dart';
import 'package:vierqr/features/qr_box/events/qr_box_event.dart';
import 'package:vierqr/features/qr_box/states/qr_box_state.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';
import 'package:vierqr/services/providers/qr_box_provider.dart';

import 'widgets/item_bank_widget.dart';
import 'widgets/item_merchant_widget.dart';
import 'widgets/item_terminal_widget.dart';

class QRBoxScreen extends StatelessWidget {
  final String cert;
  const QRBoxScreen({super.key, required this.cert});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRBoxBloc>(
      create: (context) => QRBoxBloc(context),
      child: _Screen(certificate: cert),
    );
  }
}

class _Screen extends StatefulWidget {
  final String certificate;
  const _Screen({super.key, required this.certificate});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  final TextEditingController controller = TextEditingController();

  PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  late QRBoxBloc _bloc;
  late QRBoxProvider _provider;
  List<BankAccountDTO> list = [];

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<QRBoxProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
  }

  initData() {
    list = Provider.of<InvoiceProvider>(context, listen: false).listBankUnAuth!;
    if (list.isNotEmpty) {
      _provider.init(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QRBoxBloc, QRBoxState>(
      listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS &&
            state.request == QR_Box.GET_TERMINALS) {
          _provider.updateTerminals(state.listTerminal!);
        } else if (state.status == BlocStatus.NONE &&
            state.request == QR_Box.GET_TERMINALS) {
          _provider.updateTerminals([]);
        }
        if (state.status == BlocStatus.SUCCESS &&
            state.request == QR_Box.GET_MERCHANTS) {
          _provider.updateMerchants(state.listMerchant!);
        } else if (state.status == BlocStatus.NONE &&
            state.request == QR_Box.GET_MERCHANTS) {
          _provider.updateMerchants([]);
        }

        if (state.request == QR_Box.ACTIVE &&
            state.status == BlocStatus.SUCCESS) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }

        if (state.request == QR_Box.ACTIVE &&
            state.status == BlocStatus.ERROR) {
          DialogWidget.instance
              .openMsgDialog(title: 'Active QR Box thất bại', msg: '');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: _bottom(),
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                leadingWidth: 100,
                leading: InkWell(
                  onTap: () {
                    if (currentPageIndex == 3) {
                      _provider.terminalSelect(null);
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    } else if (currentPageIndex == 2) {
                      _provider.terminalSelect(null);
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    } else if (currentPageIndex == 1) {
                      _provider.merchantSelect(null);
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "Trở về",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      AppImages.icLogoVietQr,
                      width: 95,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 150),
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        currentPageIndex = index;
                      });
                    },
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _selectBankWidget(),
                      _merchantWidget(state),
                      _terminalWidget(state),
                      _confirmActive(),
                      _activeSuccess(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _selectBankWidget() {
    return Consumer<QRBoxProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/box-3D-icon.png',
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Đầu tiên, chọn tài khoản\nngân hàng mà bạn muốn\nđồng bộ với QR Box',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (provider.listAuthBank.isNotEmpty)
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    padding: EdgeInsets.only(top: 0, bottom: 50),
                    itemBuilder: (context, index) {
                      return ItemBankWidget(
                        index: index,
                        onSelect: (value) {
                          provider.bankSelect(value);
                          // setState(() {});
                        },
                        dto: provider.listAuthBank[index],
                      );
                    },
                    itemCount: provider.listAuthBank.length,
                  ),
                ),
              )
            else
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Có vẻ bạn chưa liên kết\ntài khoản ngân hàng nào!',
                  style: TextStyle(fontSize: 20),
                ),
              )),
          ],
        );
      },
    );
  }

  Widget _merchantWidget(QRBoxState state) {
    return Consumer<QRBoxProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/box-3D-icon.png',
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Tiếp theo, chọn đại lý\nmà bạn muốn đồng bộ\nvới QR Box',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (state.status == BlocStatus.LOADING &&
                state.request == QR_Box.GET_MERCHANTS)
              Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              ))
            else
              value.listMerchant.isNotEmpty
                  ? Expanded(
                      child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: ListView.separated(
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            bool isSelect = value.selectMerchant ==
                                value.listMerchant[index];
                            return ItemMerchantWidget(
                                onSelect: (dto) {
                                  value.merchantSelect(dto);
                                },
                                dto: value.listMerchant[index],
                                isSelect: isSelect);
                          },
                          separatorBuilder: (context, index) =>
                              const MySeparator(
                                color: AppColor.GREY_DADADA,
                              ),
                          itemCount: value.listMerchant.length),
                    ))
                  : Expanded(
                      child: Container(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text(
                        'Có vẻ bạn chưa thêm\ndoanh nghiệp nào!',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
          ],
        );
      },
    );
  }

  Widget _terminalWidget(QRBoxState state) {
    return Consumer<QRBoxProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/box-3D-icon.png',
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Tiếp theo, chọn cửa hàng\nmà bạn muốn đồng bộ\nvới QR Box',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (provider.listTerminal.isNotEmpty) ...[
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: AppColor.GREY_DADADA, width: 0.5)),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  onChanged: (value) {
                    provider.filterTerminal(value);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      hintText: 'Tìm kiếm cửa hàng',
                      hintStyle: TextStyle(
                          fontSize: 15, color: AppColor.BLACK.withOpacity(0.5)),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      prefixIconColor: AppColor.GREY_TEXT,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppColor.GREY_TEXT,
                        ),
                        onPressed: () {
                          provider.filterTerminal('');
                          controller.clear();
                        },
                      )),
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (state.status == BlocStatus.LOADING &&
                state.request == QR_Box.GET_TERMINALS)
              Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              ))
            else
              provider.listTerminal.isNotEmpty
                  ? Expanded(
                      child: Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 50),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            bool isSelect = provider.selectTerminal ==
                                (provider.isFilter
                                    ? provider.filterTerminals[index]
                                    : provider.listTerminal[index]);
                            return ItemTerminalWidget(
                                onSelect: (dto) {
                                  provider.terminalSelect(dto);
                                },
                                dto: provider.isFilter
                                    ? provider.filterTerminals[index]
                                    : provider.listTerminal[index],
                                isSelect: isSelect);
                          },
                          padding: const EdgeInsets.only(top: 0),
                          separatorBuilder: (context, index) =>
                              const MySeparator(
                                color: AppColor.GREY_DADADA,
                              ),
                          itemCount: provider.isFilter
                              ? provider.filterTerminals.length
                              : provider.listTerminal.length),
                    ))
                  : Expanded(
                      child: Container(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Text(
                        'Có vẻ bạn chưa thêm\ncửa hàng nào!',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
          ],
        );
      },
    );
  }

  Widget _confirmActive() {
    return Consumer<QRBoxProvider>(
      builder: (context, provider, child) {
        if (provider.selectTerminal == null) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Xác nhận thông tin\nkích hoạt QR Box ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TK kích hoạt',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          style: TextStyle(fontSize: 15),
                          '${provider.selectBank!.bankShortName} - ${provider.selectBank!.bankAccount}',
                        )
                      ],
                    ),
                  ),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cửa hàng',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          provider.selectTerminal!.terminalName,
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _activeSuccess(QRBoxState state) {
    if (state.status == BlocStatus.LOADING && state.request == QR_Box.ACTIVE) {
      return const SizedBox.shrink();
    }
    return Consumer<QRBoxProvider>(
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              Image.asset(
                AppImages.icSuccessInBlue,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 4),
              Text(
                'Kích hoạt QR Box\n${state.active!.boxCode} thành công\nvới STK ${state.active!.bankCode} - ${state.active!.bankAccount}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'QR Box hỗ trợ nhận thông báo Biến động số dư ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'cho ngân hàng ',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    'MBBank',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' và ',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    'BIDV.',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottom() {
    bool isEnable = false;
    String buttonText = 'Tiếp tục';
    return Consumer<QRBoxProvider>(
      builder: (context, value, child) {
        if (currentPageIndex == 0 && value.selectBank != null) {
          isEnable = true;
        } else if (currentPageIndex == 1 && value.selectMerchant != null) {
          isEnable = true;
        } else if (currentPageIndex == 2 && value.selectTerminal != null) {
          isEnable = true;
        } else if (currentPageIndex == 3) {
          buttonText = 'Xác nhận';
          isEnable = true;
        } else if (currentPageIndex == 4) {
          buttonText = 'Hoàn thành';
          isEnable = true;
        } else {
          isEnable = false;
        }
        Color textColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
        Color iconColor = isEnable ? AppColor.WHITE : AppColor.TRANSPARENT;

        if ((currentPageIndex == 0 && value.listAuthBank.isEmpty) ||
            (currentPageIndex == 1 && value.listMerchant.isEmpty) ||
            (currentPageIndex == 2 && value.listTerminal.isEmpty)) {
          String empty = '';
          switch (currentPageIndex) {
            case 0:
              empty = 'Liên kết tài khoản ngay';
              break;
            case 1:
              empty = 'Thêm mới doanh nghiệp';
              break;
            case 2:
              empty = 'Thêm mới cửa hàng';
              break;

            default:
              empty = '';
              break;
          }

          return Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.only(top: 20),
            child: MButtonWidget(
              onTap: () async {
                switch (currentPageIndex) {
                  case 0:
                    await NavigatorUtils.navigatePage(context, AddBankScreen(),
                        routeName: AddBankScreen.routeName);
                    break;
                  case 1:
                    await NavigatorUtils.navigatePage(
                        context, CreateStoreScreen(),
                        routeName: CreateStoreScreen.routeName);
                    break;
                  case 2:
                    await NavigatorUtils.navigatePage(
                        context, CreateStoreScreen(),
                        routeName: CreateStoreScreen.routeName);
                    break;
                  default:
                }
              },
              title: '',
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: 50,
              isEnable: true,
              colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
              colorDisableBgr: AppColor.GREY_BUTTON,
              colorDisableText: AppColor.BLACK,
              radius: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_forward,
                      color: AppColor.TRANSPARENT, size: 20),
                  Text(empty,
                      style:
                          TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT)),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_forward,
                        color: AppColor.BLUE_TEXT, size: 20),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.only(top: 20),
          child: MButtonWidget(
            onTap: () {
              if (isEnable) {
                switch (currentPageIndex) {
                  case 0:
                    _bloc.add(GetMerchantEvent(bankId: value.selectBank!.id));
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                    break;
                  case 1:
                    _bloc.add(GetTerminalsEvent(
                        bankId: value.selectBank!.id,
                        merchantId: value.selectMerchant!.id));
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                    break;
                  case 2:
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                    break;
                  case 3:
                    _bloc.add(ActiveQRBoxEvent(
                      bankId: value.selectBank!.id,
                      terminalId: value.selectTerminal!.terminalId,
                      cert: widget.certificate,
                    ));
                    break;
                  case 4:
                    Navigator.of(context).pop();
                    break;
                  default:
                    break;
                }
              }
            },
            title: '',
            margin: EdgeInsets.symmetric(horizontal: 40),
            height: 50,
            isEnable: isEnable,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPageIndex == 4
                    ? Icon(Icons.arrow_forward,
                        color: isEnable
                            ? AppColor.BLUE_TEXT
                            : AppColor.TRANSPARENT,
                        size: 20)
                    : const SizedBox.shrink(),
                Text(buttonText,
                    style: TextStyle(fontSize: 15, color: textColor)),
                currentPageIndex == 4
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_forward,
                            color: iconColor, size: 20),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
