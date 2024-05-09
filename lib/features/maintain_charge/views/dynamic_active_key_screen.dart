import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/route.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../models/bank_account_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';
import '../states/maintain_charge_state.dart';

class DynamicActiveKeyScreen extends StatelessWidget {
  final String activeKey;
  const DynamicActiveKeyScreen({super.key, required this.activeKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintainChargeBloc>(
      create: (context) => MaintainChargeBloc(context),
      child: Screen(
        keyActice: activeKey,
      ),
    );
  }
}

class Screen extends StatefulWidget {
  final String keyActice;
  const Screen({super.key, required this.keyActice});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late MaintainChargeBloc _bloc;

  // PageController? _pageController = PageController(initialPage: 0);
  // int? currentPageIndex = 0;
  BankAccountDTO? selectedBank;

  @override
  void initState() {
    super.initState();
    _bloc = MaintainChargeBloc(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isCurrentRouteFirst(BuildContext context) {
    return !Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaintainChargeBloc, MaintainChargeState>(
      listener: (context, state) {},
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
                  onTap: () async {
                    if (isCurrentRouteFirst(context)) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.DASHBOARD, (route) => false);
                    } else {
                      Navigator.of(context).pop();
                      // if (currentPageIndex! > 0) {
                      //   _pageController?.previousPage(
                      //     duration: Duration(milliseconds: 200),
                      //     curve: Curves.easeInOut,
                      //   );
                      // } else {
                      //   Navigator.of(context).pop();
                      // }
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // child: PageView(
                  //   onPageChanged: (value) {
                  //     setState(() {
                  //       currentPageIndex = value;
                  //     });
                  //   },
                  //   controller: _pageController,
                  //   children: [
                  //     _welcomeWidget(),
                  //     _listBankWidget(),
                  //   ],
                  // ),
                  child: Consumer<InvoiceProvider>(
                    builder: (context, value, child) {
                      return value.listBank!.isNotEmpty
                          ? _listBankWidget(value)
                          : _welcomeWidget();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _welcomeWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 90, 30, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, \nvui lòng chọn tài khoản\nngân hàng để kích hoạt\ndịch vụ phần mềm VietQR',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 100),
          Center(
            child: Image.asset(
              "assets/images/logo-linked-bank.png",
              width: 130,
              // height: 62,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 49),
          Center(
            child: Text(
              'Có vẻ bạn chưa liên kết\ntài khoản ngân hàng nào!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listBankWidget(InvoiceProvider value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 90, 30, 0),
            child: Text(
              'Xin chào, \nvui lòng chọn tài khoản\nngân hàng để kích hoạt\ndịch vụ phần mềm VietQR',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: MediaQuery.of(context).size.height * 0.52,
            child: ListView.separated(
                padding: const EdgeInsets.only(top: 0),
                itemBuilder: (context, index) {
                  bool isSelect = selectedBank == value.listBank![index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBank = value.listBank![index];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: isSelect
                          ? AppColor.BLUE_TEXT.withOpacity(0.2)
                          : AppColor.TRANSPARENT,
                      child: Row(
                        children: [
                          Container(
                            width: 75,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                    value.listBank![index].imgId),
                              ),
                            ),
                            // Placeholder for bank logo
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(value.listBank![index].bankAccount,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(value.listBank![index].userBankName,
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    MySeparator(color: AppColor.GREY_DADADA),
                itemCount: value.listBank!.length),
          )
        ],
      ),
    );
  }

  Widget _bottom() {
    return Consumer<InvoiceProvider>(
      builder: (context, value, child) {
        return value.listBank!.isEmpty
            ? InkWell(
                onTap: () {
                  if (isCurrentRouteFirst(context)) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.DASHBOARD, (route) => false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 75, left: 30, right: 30),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_forward,
                          color: AppColor.TRANSPARENT, size: 20),
                      Text(
                        'Liên kết tài khoản ngay',
                        style:
                            TextStyle(fontSize: 13, color: AppColor.BLUE_TEXT),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_forward,
                            color: AppColor.BLUE_TEXT, size: 20),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  if (selectedBank != null) {
                    Navigator.pushNamed(context, Routes.MAINTAIN_CHARGE_SCREEN,
                        arguments: {
                          'activeKey': widget.keyActice,
                          'type': 0,
                          'bankId': selectedBank?.id,
                          'bankCode': selectedBank?.bankCode,
                          'bankName': selectedBank?.bankName,
                          'bankAccount': selectedBank?.bankAccount,
                          'userBankName': selectedBank?.userBankName,
                        });
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 75, left: 30, right: 30),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selectedBank != null
                        ? AppColor.BLUE_TEXT
                        : AppColor.GREY_DADADA,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_forward,
                          color: AppColor.TRANSPARENT, size: 20),
                      Text(
                        'Tiếp tục',
                        style: TextStyle(
                            fontSize: 13,
                            color: selectedBank != null
                                ? AppColor.WHITE
                                : AppColor.BLACK),
                      ),
                      Icon(Icons.arrow_forward,
                          color: selectedBank != null
                              ? AppColor.WHITE
                              : AppColor.BLACK,
                          size: 20),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
