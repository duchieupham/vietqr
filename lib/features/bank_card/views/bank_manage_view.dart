// import 'package:vierqr/commons/constants/configurations/numeral.dart';
// import 'package:vierqr/commons/constants/configurations/route.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/utils/currency_utils.dart';
// import 'package:vierqr/commons/widgets/bank_card_widget.dart';
// import 'package:vierqr/commons/widgets/button_icon_widget.dart';
// import 'package:vierqr/commons/widgets/dialog_widget.dart';
// import 'package:vierqr/commons/widgets/sub_header_widget.dart';
// import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
// import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
// import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
// import 'package:vierqr/features/personal/frames/bank_manage_frame.dart';
// import 'package:vierqr/layouts/box_layout.dart';
// import 'package:vierqr/models/bank_account_dto.dart';
// import 'package:vierqr/services/providers/bank_account_provider.dart';
// import 'package:vierqr/services/shared_references/user_information_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

// class BankManageView extends StatelessWidget {
//   const BankManageView({Key? key}) : super(key: key);

//   static late BankCardBloc _bankCardBloc;
//   static final PageController _pageController =
//       PageController(initialPage: 0, keepPage: false);
//   static final List<BankAccountDTO> _bankAccounts = [];
//   static final List<Widget> _cardWidgets = [];

//   void initialServices(BuildContext context) {
//     String userId = UserInformationHelper.instance.getUserId();
//     _bankCardBloc = BlocProvider.of(context);
//     _bankAccounts.clear();
//     _cardWidgets.clear();
//     _bankCardBloc.add(BankCardEventGetList(userId: userId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     initialServices(context);
//     return Scaffold(
//       appBar: AppBar(toolbarHeight: 0),
//       body: BlocConsumer<BankCardBloc, BankCardState>(
//         listener: ((context, state) {
//           if (state is BankCardGetListSuccessState) {
//             Provider.of<BankAccountProvider>(context, listen: false)
//                 .updateIndex(0);
//             _bankAccounts.clear();
//             _cardWidgets.clear();
//             if (_bankAccounts.isEmpty && state.list.isNotEmpty) {
//               _bankAccounts.addAll(state.list);
//               for (BankAccountDTO bankAccountDTO in _bankAccounts) {
//                 BankCardWidget cardWidget = BankCardWidget(
//                   dto: bankAccountDTO,
//                   width: width - 40,
//                 );
//                 _cardWidgets.add(cardWidget);
//               }
//             }
//           }
//           if (state is BankCardGetListFailedState) {
//             DialogWidget.instance.openMsgDialog(
//                 title: 'Không thể tải danh sách',
//                 msg:
//                     'Không thể tải danh sách tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
//           }
//           if (state is BankCardRemoveSuccessState) {
//             getListBank(context);
//           }
//           if (state is BankCardRemoveFailedState) {
//             DialogWidget.instance.openMsgDialog(
//               title: 'Không thể huỷ liên kết',
//               msg: state.message,
//             );
//           }
//         }),
//         builder: ((context, state) {
//           if (state is BankCardGetListSuccessState) {
//             if (state.list.isEmpty) {
//               _bankAccounts.clear();
//               _cardWidgets.clear();
//             }
//           }
//           return BankManageFrame(
//             width: width,
//             mobileChilren: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SubHeader(
//                     title: 'Tài khoản ngân hàng',
//                     function: () {
//                       Provider.of<BankAccountProvider>(context, listen: false)
//                           .reset();
//                       Navigator.of(context).pop();
//                     }),
//                 (_bankAccounts.isEmpty && state is BankCardGetListSuccessState)
//                     ? BoxLayout(
//                         width: width - 40,
//                         // height: (width - 40) / Numeral.BANK_CARD_RATIO,
//                         borderRadius: 15,
//                         alignment: Alignment.center,
//                         bgColor: Theme.of(context).cardColor,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/ic-card.png',
//                               width: width * 0.4,
//                             ),
//                             const Text(
//                               'Chưa có tài khoản ngân hàng được liên kết.',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             const Padding(padding: EdgeInsets.only(top: 10)),
//                             ButtonIconWidget(
//                               width: width,
//                               icon: Icons.credit_card_rounded,
//                               title: 'Liên kết ngay',
//                               function: () {
//                                 Navigator.pushNamed(
//                                   context,
//                                   Routes.ADD_BANK_CARD,
//                                 ).then(
//                                   (value) => Provider.of<BankAccountProvider>(
//                                           context,
//                                           listen: false)
//                                       .reset(),
//                                 );
//                               },
//                               bgColor: DefaultTheme.PURPLE_NEON,
//                               textColor: DefaultTheme.WHITE,
//                             ),
//                             const Padding(padding: EdgeInsets.only(top: 10)),
//                           ],
//                         ),
//                       )
//                     : (_bankAccounts.isEmpty)
//                         ? const SizedBox()
//                         : Expanded(
//                             child: ListView(
//                               children: [
//                                 SizedBox(
//                                   width: width,
//                                   // height: 300,
//                                   child: Consumer<BankAccountProvider>(
//                                       builder: (context, provider, child) {
//                                     return Column(
//                                       children: [
//                                         (_bankAccounts.isEmpty)
//                                             ? const SizedBox()
//                                             : SizedBox(
//                                                 width: width,
//                                                 height: width /
//                                                     Numeral.BANK_CARD_RATIO,
//                                                 child: PageView(
//                                                   key: const PageStorageKey(
//                                                       'CARD_PAGE_VIEW'),
//                                                   controller: _pageController,
//                                                   onPageChanged: (index) {
//                                                     Provider.of<BankAccountProvider>(
//                                                             context,
//                                                             listen: false)
//                                                         .updateIndex(index);
//                                                   },
//                                                   children: _cardWidgets,
//                                                 ),
//                                               ),
//                                         const Padding(
//                                           padding: EdgeInsets.only(top: 10),
//                                         ),
//                                         (_bankAccounts.isEmpty)
//                                             ? const SizedBox()
//                                             : Container(
//                                                 width: width,
//                                                 height: 10,
//                                                 alignment: Alignment.center,
//                                                 child: ListView.builder(
//                                                   shrinkWrap: true,
//                                                   scrollDirection:
//                                                       Axis.horizontal,
//                                                   physics:
//                                                       const NeverScrollableScrollPhysics(),
//                                                   itemCount:
//                                                       _bankAccounts.length,
//                                                   itemBuilder:
//                                                       ((context, index) =>
//                                                           _buildDot(
//                                                             (index ==
//                                                                 provider
//                                                                     .indexSelected),
//                                                           )),
//                                                 ),
//                                               ),
//                                       ],
//                                     );
//                                   }),
//                                 ),
//                                 const Padding(
//                                     padding: EdgeInsets.only(top: 20)),
//                                 BoxLayout(
//                                   width: width,
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 20, horizontal: 20),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Số dư',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           // color: DefaultTheme.GREY_TEXT,
//                                         ),
//                                       ),
//                                       const Padding(
//                                           padding: EdgeInsets.only(top: 5)),
//                                       RichText(
//                                         textAlign: TextAlign.left,
//                                         text: TextSpan(
//                                             style: const TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: DefaultTheme.GREEN,
//                                             ),
//                                             children: [
//                                               TextSpan(
//                                                 text: CurrencyUtils.instance
//                                                     .getCurrencyFormatted('0'),
//                                               ),
//                                               TextSpan(
//                                                 text: ' VND',
//                                                 style: TextStyle(
//                                                   color: Theme.of(context)
//                                                       .hintColor,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.normal,
//                                                 ),
//                                               ),
//                                             ]),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Padding(
//                                     padding: EdgeInsets.only(top: 10)),
//                                 _buildButtonIcon(
//                                   context: context,
//                                   width: width,
//                                   icon: Icons.manage_search_rounded,
//                                   color: DefaultTheme.BLUE_TEXT,
//                                   text: 'Truy vấn lịch sử giao dịch',
//                                   function: () {},
//                                 ),
//                                 const Padding(
//                                     padding: EdgeInsets.only(top: 10)),
//                                 _buildButtonIcon(
//                                   context: context,
//                                   width: width,
//                                   icon: Icons.credit_card_rounded,
//                                   color: DefaultTheme.PURPLE_NEON,
//                                   text: 'Liên kết tài khoản ngân hàng',
//                                   function: () {
//                                     Navigator.pushNamed(
//                                       context,
//                                       Routes.ADD_BANK_CARD,
//                                     ).then(
//                                       (value) =>
//                                           Provider.of<BankAccountProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .reset(),
//                                     );
//                                   },
//                                 ),
//                                 const Padding(
//                                     padding: EdgeInsets.only(top: 10)),
//                                 _buildButtonIcon(
//                                   context: context,
//                                   width: width,
//                                   icon: Icons.person_rounded,
//                                   color: DefaultTheme.GREEN,
//                                   text: 'Quản lý thành viên',
//                                   function: () {
//                                     Navigator.of(context).pushNamed(
//                                       Routes.BANK_MEMBER_VIEW,
//                                       arguments: {
//                                         'bankAccountDTO': _bankAccounts[
//                                             Provider.of<BankAccountProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .indexSelected]
//                                       },
//                                     );
//                                   },
//                                 ),
//                                 const Padding(
//                                     padding: EdgeInsets.only(top: 10)),
//                                 _buildButtonIcon(
//                                   context: context,
//                                   width: width,
//                                   icon: Icons.delete_rounded,
//                                   color: DefaultTheme.RED_TEXT,
//                                   text: 'Huỷ liên kết tài khoản',
//                                   function: () {
//                                     DialogWidget.instance.openRemoveBankCard(
//                                       bankAccountDTO: _bankAccounts[
//                                           Provider.of<BankAccountProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .indexSelected],
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                 const Padding(padding: EdgeInsets.only(bottom: 20))
//               ],
//             ),
//             menu: const SizedBox(),
//             webChildren: const SizedBox(),
//           );
//         }),
//       ),
//     );
//   }

//   void getListBank(BuildContext context) {
//     _bankAccounts.clear();
//     _cardWidgets.clear();
//     String userId = UserInformationHelper.instance.getUserId();
//     _bankCardBloc.add(BankCardEventGetList(userId: userId));
//   }

//   Widget _buildButtonIcon({
//     required BuildContext context,
//     required double width,
//     required IconData icon,
//     required Color color,
//     required String text,
//     required VoidCallback function,
//   }) {
//     return InkWell(
//       onTap: function,
//       child: BoxLayout(
//         width: width,
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: color,
//             ),
//             const Padding(padding: EdgeInsets.only(left: 10)),
//             Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 15,
//               ),
//             ),
//             const Spacer(),
//             const Icon(
//               Icons.navigate_next_rounded,
//               size: 15,
//               color: DefaultTheme.GREY_TEXT,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDot(bool isSelected) {
//     return Container(
//       width: (isSelected) ? 20 : 10,
//       height: 10,
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         border: (isSelected)
//             ? Border.all(color: DefaultTheme.GREY_LIGHT, width: 0.5)
//             : null,
//         color: (isSelected) ? DefaultTheme.WHITE : DefaultTheme.GREY_LIGHT,
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }
