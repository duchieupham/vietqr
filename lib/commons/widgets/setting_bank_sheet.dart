import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/bank_information_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/dot_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_card/views/add_members_card_widget.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/features/bank_card/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features/personal/events/bank_manage_event.dart';
import 'package:vierqr/features/bank_card/states/bank_manage_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/providers/memeber_manage_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingBankSheet {
  const SettingBankSheet._privateConsrtructor();

  static const SettingBankSheet _instance =
      SettingBankSheet._privateConsrtructor();
  static SettingBankSheet get instance => _instance;

  Future<void> openChosingBankToCreateQR() {
    final String userId = UserInformationHelper.instance.getUserId();
    final double width =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
            .size
            .width;
    final double height =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
            .size
            .height;
    final List<Widget> cardWidgets = [];
    final List<BankAccountDTO> bankAccounts = [];
    final BankManageBloc bankManageBloc =
        BlocProvider.of(NavigationService.navigatorKey.currentContext!);
    bankManageBloc.add(BankManageEventGetList(userId: userId));
    return showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                  ),
                  width: width - 10,
                  height: height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: BlocConsumer<BankManageBloc, BankManageState>(
                      listener: (context, state) {
                    if (state is BankManageListSuccessState) {
                      Provider.of<BankAccountProvider>(context, listen: false)
                          .updateIndex(0);
                      bankAccounts.clear();
                      cardWidgets.clear();
                      if (bankAccounts.isEmpty && state.list.isNotEmpty) {
                        bankAccounts.addAll(state.list);
                        for (BankAccountDTO bankAccountDTO in bankAccounts) {
                          BankInformationWidget cardWidget =
                              BankInformationWidget(
                            width: width,
                            height: 80,
                            bankAccountDTO: bankAccountDTO,
                            icon: Icons.navigate_next_rounded,
                          );
                          cardWidgets.add(cardWidget);
                        }
                      }
                    }
                  }, builder: (context, state) {
                    return Column(
                      children: [
                        const Text(
                          'Chọn ngân hàng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        (state is BankManageLoadingListState)
                            ? SizedBox(
                                width: width,
                                height: 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: DefaultTheme.GREEN,
                                  ),
                                ),
                              )
                            : (bankAccounts.isEmpty)
                                ? const SizedBox()
                                : Expanded(
                                    child: ListView.separated(
                                      itemCount: cardWidgets.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => CreateQR(
                                                  bankAccountDTO:
                                                      bankAccounts[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: cardWidgets[index],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return DividerWidget(
                                          width: width - 60,
                                        );
                                      },
                                    ),
                                  ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        });
  }

  // Future<void> openChosingBank() {
  //   final String userId = UserInformationHelper.instance.getUserId();
  //   final PageController pageController =
  //       PageController(initialPage: 0, keepPage: false);
  //   final double width =
  //       MediaQuery.of(NavigationService.navigatorKey.currentContext!)
  //           .size
  //           .width;
  //   final List<BankCardWidgetOld> cardWidgets = [];
  //   final List<BankAccountDTO> bankAccounts = [];
  //   final BankManageBloc bankManageBloc =
  //       BlocProvider.of(NavigationService.navigatorKey.currentContext!);
  //   bankManageBloc.add(BankManageEventGetList(userId: userId));
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: NavigationService.navigatorKey.currentContext!,
  //       backgroundColor: DefaultTheme.TRANSPARENT,
  //       builder: (context) {
  //         return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //           child: ClipRRect(
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
  //               child: Container(
  //                 padding: const EdgeInsets.only(
  //                   left: 10,
  //                   right: 10,
  //                   top: 20,
  //                 ),
  //                 width: MediaQuery.of(context).size.width - 10,
  //                 height: 350,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Theme.of(context).cardColor,
  //                 ),
  //                 child: BlocConsumer<BankManageBloc, BankManageState>(
  //                   listener: (context, state) {
  //                     if (state is BankManageListSuccessState) {
  //                       Provider.of<BankAccountProvider>(context, listen: false)
  //                           .updateIndex(0);
  //                       bankAccounts.clear();
  //                       cardWidgets.clear();
  //                       if (bankAccounts.isEmpty &&
  //                           (state.list.isNotEmpty ||
  //                               state.listOther.isNotEmpty)) {
  //                         if (state.list.isNotEmpty) {
  //                           bankAccounts.addAll(state.list);
  //                         }
  //                         if (state.listOther.isNotEmpty) {
  //                           bankAccounts.addAll(state.listOther);
  //                         }
  //                         for (BankAccountDTO bankAccountDTO in bankAccounts) {
  //                           BankCardWidgetOld cardWidget = BankCardWidgetOld(
  //                             key: PageStorageKey(bankAccountDTO.bankCode),
  //                             width: width - 40,
  //                             bankAccountDTO: bankAccountDTO,
  //                             isMenuShow: false,
  //                             isDelete: false,
  //                             roleInsert: 'MANAGER',
  //                           );
  //                           cardWidgets.add(cardWidget);
  //                         }
  //                       }
  //                     }
  //                   },
  //                   builder: (context, state) {
  //                     return Consumer<BankAccountProvider>(
  //                         builder: (context, provider, child) {
  //                       return Column(
  //                         children: [
  //                           const Text(
  //                             'Chọn ngân hàng',
  //                             style: TextStyle(
  //                                 fontSize: 20, fontWeight: FontWeight.bold),
  //                           ),
  //                           const Padding(
  //                             padding: EdgeInsets.only(top: 10),
  //                           ),
  //                           (state is BankManageLoadingListState)
  //                               ? SizedBox(
  //                                   width: width,
  //                                   height: 200,
  //                                   child: const Center(
  //                                     child: CircularProgressIndicator(
  //                                       color: DefaultTheme.GREEN,
  //                                     ),
  //                                   ),
  //                                 )
  //                               : (bankAccounts.isEmpty)
  //                                   ? const SizedBox()
  //                                   : SizedBox(
  //                                       width: width,
  //                                       height: 200,
  //                                       child: PageView(
  //                                         key: const PageStorageKey(
  //                                             'CARD_PAGE_VIEW'),
  //                                         controller: pageController,
  //                                         onPageChanged: (index) {
  //                                           Provider.of<BankAccountProvider>(
  //                                                   context,
  //                                                   listen: false)
  //                                               .updateIndex(index);
  //                                         },
  //                                         children: cardWidgets,
  //                                       ),
  //                                     ),
  //                           (bankAccounts.isEmpty)
  //                               ? const SizedBox()
  //                               : Container(
  //                                   width: width,
  //                                   height: 10,
  //                                   alignment: Alignment.center,
  //                                   child: ListView.builder(
  //                                     shrinkWrap: true,
  //                                     scrollDirection: Axis.horizontal,
  //                                     physics:
  //                                         const NeverScrollableScrollPhysics(),
  //                                     itemCount: bankAccounts.length,
  //                                     itemBuilder: (context, index) =>
  //                                         DotWidget(
  //                                       isSelected:
  //                                           (index == provider.indexSelected),
  //                                     ),
  //                                   ),
  //                                 ),
  //                           const Padding(
  //                             padding: EdgeInsets.only(top: 20),
  //                           ),
  //                           (bankAccounts.isNotEmpty)
  //                               ? ButtonWidget(
  //                                   width: width - 80,
  //                                   text: 'Chọn',
  //                                   textColor: DefaultTheme.WHITE,
  //                                   bgColor: DefaultTheme.GREEN,
  //                                   function: () async {
  //                                     Navigator.of(context).pop();
  //                                     await openAddMemberIntoBank(
  //                                       bankId:
  //                                           bankAccounts[provider.indexSelected]
  //                                               .id,
  //                                       roleInsert:
  //                                           cardWidgets[provider.indexSelected]
  //                                               .roleInsert!,
  //                                     );
  //                                   },
  //                                 )
  //                               : const SizedBox(),
  //                         ],
  //                       );
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future<void> openAddingFormCard(
      List<String> banks,
      TextEditingController bankAccountController,
      TextEditingController bankAccountNameController) {
    final double width = MediaQuery.of(
      NavigationService.navigatorKey.currentContext!,
    ).size.width;
    final BankManageBloc bankManageBloc = BlocProvider.of(
      NavigationService.navigatorKey.currentContext!,
    );
    String bankSelected = banks.first;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Consumer<BankSelectProvider>(
                    builder: ((context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          const Text(
                            'Thêm tài khoản ngân hàng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankSelectErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              value: bankSelected,
                              icon: Image.asset(
                                'assets/images/ic-dropdown.png',
                                width: 30,
                                height: 30,
                              ),
                              elevation: 0,
                              style: const TextStyle(fontSize: 15),
                              underline: const SizedBox(
                                height: 0,
                              ),
                              onChanged: (String? selected) {
                                if (selected == null) {
                                  bankSelected = banks.first;
                                  //    value.updateBankSelected(banks.first);
                                } else {
                                  bankSelected = selected;
                                  value.updateBankSelected(selected);
                                  value.updateErrs(
                                    (value.bankSelected == 'Chọn ngân hàng'),
                                    value.bankAccountErr,
                                    value.bankAccountNameErr,
                                  );
                                }
                              },
                              items: banks.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                    width: width - 120,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: value.bankSelectErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Vui lòng chọn Ngân hàng.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankAccountErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFieldWidget(
                                width: width,
                                hintText: 'Số tài khoản',
                                controller: bankAccountController,
                                keyboardAction: TextInputAction.next,
                                onChange: (value) {},
                                inputType: TextInputType.number,
                                isObscureText: false),
                          ),
                          Visibility(
                            visible: value.bankAccountErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Số tài khoản không đúng định dạng.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankAccountNameErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFieldWidget(
                                width: width,
                                hintText: 'Tên tài khoản',
                                controller: bankAccountNameController,
                                keyboardAction: TextInputAction.done,
                                onChange: (value) {},
                                inputType: TextInputType.text,
                                isObscureText: false),
                          ),
                          Visibility(
                            visible: value.bankAccountNameErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Tên tài khoản không được để trống.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Spacer(),
                          ButtonWidget(
                            width: width - 40,
                            text: 'Thêm tài khoản ngân hàng',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              value.updateErrs(
                                  (value.bankSelected == 'Chọn ngân hàng'),
                                  (bankAccountController.text.isEmpty ||
                                      !StringUtils.instance.isNumeric(
                                          bankAccountController.text)),
                                  (bankAccountNameController.text.isEmpty));
                              if (!value.bankSelectErr &&
                                  !value.bankAccountErr &&
                                  !value.bankAccountNameErr) {
                                if (bankSelected != 'Chọn ngân hàng') {
                                  const Uuid uuid = Uuid();
                                  BankAccountDTO dto = BankAccountDTO(
                                    id: uuid.v1(),
                                    bankAccount: bankAccountController.text,
                                    userBankName:
                                        bankAccountNameController.text,
                                    bankCode: bankSelected.split('-')[0].trim(),
                                    bankName: BankInformationUtil.instance
                                        .getBankNameFromSelectBox(bankSelected),
                                    userId: UserInformationHelper.instance
                                        .getUserId(),
                                    bankStatus: 0,
                                    role: 0,
                                    imgId: '',
                                  );
                                  bankManageBloc.add(
                                    BankManageEventAddDTO(
                                      userId: UserInformationHelper.instance
                                          .getUserId(),
                                      dto: dto,
                                      phoneNo: UserInformationHelper.instance
                                          .getPhoneNo(),
                                    ),
                                  );
                                }
                              } else {
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể thêm tài khoản',
                                    msg:
                                        'Không thể thêm tài khoản ngân hàng. Vui lòng nhập đầy đủ và chính xác thông tin tài khoản ngân hàng.');
                              }
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // Future<void> openAddingFormCard(
  //     List<String> banks,
  //     TextEditingController bankAccountController,
  //     TextEditingController bankAccountNameController) {
  //   final double width = MediaQuery.of(
  //     NavigationService.navigatorKey.currentContext!,
  //   ).size.width;
  //   final BankManageBloc bankManageBloc = BlocProvider.of(
  //     NavigationService.navigatorKey.currentContext!,
  //   );
  //   final BankTypeBloc bankTypeBloc = BlocProvider.of(
  //     NavigationService.navigatorKey.currentContext!,
  //   );
  //   bankTypeBloc.add(const BankTypeEventGetList());
  //   final List<BankTypeDTO> bankTypes = [];
  //   BankTypeDTO bankTypeSelected =
  //       const BankTypeDTO(id: '', bankCode: '', bankName: '', imageId: '');
  //   String bankSelected = banks.first;
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: NavigationService.navigatorKey.currentContext!,
  //       backgroundColor: DefaultTheme.TRANSPARENT,
  //       builder: (context) {
  //         return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //           child: ClipRRect(
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
  //               child: Container(
  //                 padding: const EdgeInsets.only(
  //                   left: 20,
  //                   right: 20,
  //                   top: 10,
  //                 ),
  //                 width: MediaQuery.of(context).size.width - 10,
  //                 height: MediaQuery.of(context).size.height * 0.8,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Theme.of(context).cardColor,
  //                 ),
  //                 child: Consumer<BankSelectProvider>(
  //                   builder: ((context, value, child) {
  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Padding(padding: EdgeInsets.only(top: 20)),
  //                         const Text(
  //                           'Thêm tài khoản ngân hàng',
  //                           style: TextStyle(
  //                               fontSize: 20, fontWeight: FontWeight.w500),
  //                         ),
  //                         const Padding(padding: EdgeInsets.only(top: 15)),
  //                         Container(
  //                           width: width,
  //                           padding: const EdgeInsets.symmetric(
  //                               vertical: 10, horizontal: 20),
  //                           decoration: BoxDecoration(
  //                             color: (value.bankSelectErr)
  //                                 ? DefaultTheme.RED_TEXT.withOpacity(0.2)
  //                                 : Theme.of(context).canvasColor,
  //                             borderRadius: BorderRadius.circular(15),
  //                           ),
  //                           child: BlocBuilder<BankTypeBloc, BankTypeState>(
  //                             builder: (context, state) {
  //                               if (state is BankTypeGetListSuccessfulState) {
  //                                 if (state.list.isNotEmpty) {
  //                                   bankTypeSelected = state.list.first;
  //                                   bankTypes.addAll(state.list);
  //                                 }
  //                                 return Visibility(
  //                                   visible: bankTypes.isNotEmpty,
  //                                   child: DropdownButton<BankTypeDTO>(
  //                                     value: bankTypeSelected,
  //                                     icon: Image.asset(
  //                                       'assets/images/ic-dropdown.png',
  //                                       width: 30,
  //                                       height: 30,
  //                                     ),
  //                                     elevation: 0,
  //                                     style: const TextStyle(fontSize: 15),
  //                                     underline: const SizedBox(
  //                                       height: 0,
  //                                     ),
  //                                     onChanged: (BankTypeDTO? selected) {
  //                                       // if (selected == null) {
  //                                       //   bankSelected = banks.first;
  //                                       //   //    value.updateBankSelected(banks.first);
  //                                       // } else {
  //                                       //   bankSelected = selected;
  //                                       //   value.updateBankSelected(selected);
  //                                       //   value.updateErrs(
  //                                       //     (value.bankSelected ==
  //                                       //         'Chọn ngân hàng'),
  //                                       //     value.bankAccountErr,
  //                                       //     value.bankAccountNameErr,
  //                                       //   );
  //                                       // }
  //                                     },
  //                                     items: bankTypes
  //                                         .map<DropdownMenuItem<BankTypeDTO>>(
  //                                             (BankTypeDTO value) {
  //                                       return DropdownMenuItem<BankTypeDTO>(
  //                                         value: value!,
  //                                         child: SizedBox(
  //                                           width: width - 120,
  //                                           child: Row(
  //                                             children: [
  //                                               Container(
  //                                                 width: 80,
  //                                                 decoration: BoxDecoration(
  //                                                   image: DecorationImage(
  //                                                     image: ImageUtils.instance
  //                                                         .getImageNetWork(
  //                                                             value.imageId),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Expanded(
  //                                                   child: Column(
  //                                                 children: [
  //                                                   Text(value.bankCode),
  //                                                   Text(value.bankName),
  //                                                 ],
  //                                               ))
  //                                             ],
  //                                           ),
  //                                           // Text(
  //                                           //   value!.bankName,
  //                                           //   style: TextStyle(
  //                                           //     color:
  //                                           //         Theme.of(context).hintColor,
  //                                           //   ),
  //                                           // ),
  //                                         ),
  //                                       );
  //                                     }).toList(),
  //                                   ),
  //                                 );
  //                               }
  //                               return const SizedBox();
  //                             },
  //                           ),
  //                         ),
  //                         Visibility(
  //                           visible: value.bankSelectErr,
  //                           child: const Padding(
  //                             padding: EdgeInsets.only(left: 10, top: 5),
  //                             child: Text(
  //                               'Vui lòng chọn Ngân hàng.',
  //                               style: TextStyle(
  //                                   color: DefaultTheme.RED_TEXT, fontSize: 13),
  //                             ),
  //                           ),
  //                         ),
  //                         const Padding(padding: EdgeInsets.only(top: 15)),
  //                         Container(
  //                           width: width,
  //                           padding: const EdgeInsets.symmetric(
  //                               vertical: 5, horizontal: 20),
  //                           decoration: BoxDecoration(
  //                             color: (value.bankAccountErr)
  //                                 ? DefaultTheme.RED_TEXT.withOpacity(0.2)
  //                                 : Theme.of(context).canvasColor,
  //                             borderRadius: BorderRadius.circular(15),
  //                           ),
  //                           child: TextFieldWidget(
  //                               width: width,
  //                               hintText: 'Số tài khoản',
  //                               controller: bankAccountController,
  //                               keyboardAction: TextInputAction.next,
  //                               onChange: (value) {},
  //                               inputType: TextInputType.number,
  //                               isObscureText: false),
  //                         ),
  //                         Visibility(
  //                           visible: value.bankAccountErr,
  //                           child: const Padding(
  //                             padding: EdgeInsets.only(left: 10, top: 5),
  //                             child: Text(
  //                               'Số tài khoản không đúng định dạng.',
  //                               style: TextStyle(
  //                                   color: DefaultTheme.RED_TEXT, fontSize: 13),
  //                             ),
  //                           ),
  //                         ),
  //                         const Padding(padding: EdgeInsets.only(top: 15)),
  //                         Container(
  //                           width: width,
  //                           padding: const EdgeInsets.symmetric(
  //                               vertical: 5, horizontal: 20),
  //                           decoration: BoxDecoration(
  //                             color: (value.bankAccountNameErr)
  //                                 ? DefaultTheme.RED_TEXT.withOpacity(0.2)
  //                                 : Theme.of(context).canvasColor,
  //                             borderRadius: BorderRadius.circular(15),
  //                           ),
  //                           child: TextFieldWidget(
  //                               width: width,
  //                               hintText: 'Tên tài khoản',
  //                               controller: bankAccountNameController,
  //                               keyboardAction: TextInputAction.done,
  //                               onChange: (value) {},
  //                               inputType: TextInputType.text,
  //                               isObscureText: false),
  //                         ),
  //                         Visibility(
  //                           visible: value.bankAccountNameErr,
  //                           child: const Padding(
  //                             padding: EdgeInsets.only(left: 10, top: 5),
  //                             child: Text(
  //                               'Tên tài khoản không được để trống.',
  //                               style: TextStyle(
  //                                   color: DefaultTheme.RED_TEXT, fontSize: 13),
  //                             ),
  //                           ),
  //                         ),
  //                         const Spacer(),
  //                         ButtonWidget(
  //                           width: width - 40,
  //                           text: 'Thêm tài khoản ngân hàng',
  //                           textColor: DefaultTheme.WHITE,
  //                           bgColor: DefaultTheme.GREEN,
  //                           function: () {
  //                             FocusManager.instance.primaryFocus?.unfocus();
  //                             value.updateErrs(
  //                                 (value.bankSelected == 'Chọn ngân hàng'),
  //                                 (bankAccountController.text.isEmpty ||
  //                                     !StringUtils.instance.isNumeric(
  //                                         bankAccountController.text)),
  //                                 (bankAccountNameController.text.isEmpty));
  //                             if (!value.bankSelectErr &&
  //                                 !value.bankAccountErr &&
  //                                 !value.bankAccountNameErr) {
  //                               if (bankSelected != 'Chọn ngân hàng') {
  //                                 const Uuid uuid = Uuid();
  //                                 BankAccountDTO dto = BankAccountDTO(
  //                                   id: uuid.v1(),
  //                                   bankAccount: bankAccountController.text,
  //                                   bankAccountName:
  //                                       bankAccountNameController.text,
  //                                   bankCode: bankSelected.split('-')[0].trim(),
  //                                   bankName: BankInformationUtil.instance
  //                                       .getBankNameFromSelectBox(bankSelected),
  //                                   userId: UserInformationHelper.instance
  //                                       .getUserId(),
  //                                 );
  //                                 bankManageBloc.add(
  //                                   BankManageEventAddDTO(
  //                                     userId: UserInformationHelper.instance
  //                                         .getUserId(),
  //                                     dto: dto,
  //                                     phoneNo: UserInformationHelper.instance
  //                                         .getUserInformation()
  //                                         .phoneNo,
  //                                   ),
  //                                 );
  //                               }
  //                             } else {
  //                               DialogWidget.instance.openMsgDialog(
  //                                   title: 'Không thể thêm tài khoản',
  //                                   msg:
  //                                       'Không thể thêm tài khoản ngân hàng. Vui lòng nhập đầy đủ và chính xác thông tin tài khoản ngân hàng.');
  //                             }
  //                           },
  //                         ),
  //                         const Padding(padding: EdgeInsets.only(top: 10)),
  //                       ],
  //                     );
  //                   }),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future openAddMemberIntoBank(
      {required String bankId, required String roleInsert}) {
    final double width =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
            .size
            .width;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: AddMembersCardWidget(
                    width: width,
                    bankId: bankId,
                    roleInsert: roleInsert,
                    isModalBottom: true,
                  ),
                ),
              ),
            ),
          );
        }).then((value) => Provider.of<MemeberManageProvider>(
            NavigationService.navigatorKey.currentContext!,
            listen: false)
        .reset());
  }

  Future openSettingCard({
    required String userId,
    required BankAccountDTO bankAccountDTO,
    required bool isDelete,
    required String role,
  }) {
    final double width =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
            .size
            .width;
    return showModalBottomSheet(
        isScrollControlled: false,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              width: 200,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width,
                    //  height: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ButtonWidget(
                          width: width,
                          text: 'Quản lý thành viên',
                          textColor: DefaultTheme.BLUE_TEXT,
                          bgColor: DefaultTheme.TRANSPARENT,
                          function: () {
                            Navigator.pop(context);
                            openAddMemberIntoBank(
                                bankId: bankAccountDTO.id, roleInsert: role);
                          },
                        ),
                        (isDelete)
                            ? const Divider(
                                color: DefaultTheme.GREY_LIGHT,
                                height: 0.5,
                              )
                            : const SizedBox(),
                        (isDelete)
                            ? ButtonWidget(
                                width: width,
                                text: 'Xoá',
                                textColor: DefaultTheme.RED_TEXT,
                                bgColor: DefaultTheme.TRANSPARENT,
                                function: () {
                                  Navigator.pop(context);
                                  final BankManageBloc bankManageBloc =
                                      BlocProvider.of(context);
                                  bankManageBloc.add(
                                    BankManageEventRemoveDTO(
                                      userId: userId,
                                      bankCode: bankAccountDTO.bankAccount,
                                      bankId: bankAccountDTO.id,
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ButtonWidget(
                    width: width,
                    text: 'Huỷ',
                    textColor: DefaultTheme.BLUE_TEXT,
                    bgColor: Theme.of(context).cardColor,
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          );
        });
  }
}
