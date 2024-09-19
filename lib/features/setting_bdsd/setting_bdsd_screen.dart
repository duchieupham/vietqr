import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/widget/custom_switch_view.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';
import 'package:vierqr/services/providers/setting_bdsd_provider.dart';

// ignore: must_be_immutable
class SettingBDSD extends StatefulWidget {
  SettingBDSD({super.key, required this.listIsOwnerBank});

  List<BankAccountDTO> listIsOwnerBank;

  static String routeName = '/setting_bdsd';

  @override
  State<SettingBDSD> createState() => _SettingBDSDState();
}

class _SettingBDSDState extends State<SettingBDSD> {
  final DashBoardBloc _bloc = getIt.get<DashBoardBloc>();

  void _enableVoiceSetting(
      Map<String, dynamic> param, SettingBDSDProvider provider) async {
    try {
      final listIsOwnerBank = widget.listIsOwnerBank;
      bool enableStatus = await accRepository.enableVoiceSetting(param);
      if (enableStatus) {
        List<String> listBanks = param['bankIds'];
        String stringBanks = listBanks.join(',');
        await SharePrefUtils.saveListEnableVoiceBanks(stringBanks);
        if (listBanks.isNotEmpty) {
          for (var e in listIsOwnerBank) {
            e.enableVoice = listBanks.contains(e.id);
          }
        } else {
          for (var e in listIsOwnerBank) {
            e.enableVoice = false;
          }
        }

        await SharePrefUtils.saveListOwnerBanks(listIsOwnerBank);
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
    }
  }
  // create: (context) =>
  //   SettingBDSDProvider()..initData(widget.listIsOwnerBank),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Cài đặt hệ thống'),
      body: Consumer<SettingBDSDProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              ...[
                const Text(
                  'Hiển thị',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _buildContainer(
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Giữ màn hình sáng khi hiện QR',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 4),
                            Text(
                                'Hệ thống giữ thiết bị của bạn luôn sáng ở những màn hình có thông tin mã QR.',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Consumer<AuthenProvider>(builder: (context, provider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              provider.settingDTO.keepScreenOn ? 'Bật' : 'Tắt',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            // CustomSwitch(
                            //   value: provider.settingDTO.keepScreenOn,
                            //   onChanged: (value) {
                            //     _bloc.add(UpdateKeepBrightEvent(value));
                            //   },
                            // ),
                            Switch(
                              value: provider.settingDTO.keepScreenOn,
                              activeColor: AppColor.BLUE_TEXT,
                              onChanged: (bool value) {
                                _bloc.add(UpdateKeepBrightEvent(value));
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Cài đặt giọng nói',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildBgItem(
                customPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Giọng nói được kích hoạt khi nhận thông báo Biến động số dư trong ứng dụng VietQR cho tất cả tài khoản',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      provider.enableVoice ? 'Bật' : 'Tắt',
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    Switch(
                      value: provider.enableVoice,
                      activeColor: AppColor.BLUE_TEXT,
                      onChanged: (bool value) {
                        provider.updateOpenVoice(value);
                        Map<String, dynamic> paramEnable = {};
                        paramEnable['bankIds'] = provider.getListId();
                        paramEnable['userId'] =
                            SharePrefUtils.getProfile().userId;
                        // for (var e in provider.listVoiceBank) {
                        //   e.enableVoice = value;
                        // }
                        _enableVoiceSetting(paramEnable, provider);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // const Text(
              //   'Danh sách tài khoản nhận giọng nói\nthông báo Biến động số dư',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: 100,
                      height: 45,
                      padding: const EdgeInsets.all(4),
                      color: AppColor.BLUE_TEXT.withOpacity(0.3),
                      child: const Center(
                        child: Text(
                          'Tài khoản ngân hàng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    // width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    child: const Center(
                      child: Text(
                        'Thông báo BĐSD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ...provider.listBank
                  .asMap()
                  .map(
                    (index, e) => MapEntry(e, _itemBank(e, index, provider)),
                  )
                  .values,

              _buildBgNote(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '- Giọng nói thông báo biến động số dư hoạt động khi bạn đang sử dụng ứng dụng.',
                      style: TextStyle(fontSize: 11),
                    ),
                    Text(
                      '- Các trường hợp chạy nền, tắt ứng dụng thì giọng nói sẽ không hoạt động.',
                      style: TextStyle(fontSize: 11),
                    ),
                    Text(
                      '- Âm lượng thiết bị của bạn phải luôn bật.',
                      style: TextStyle(fontSize: 11),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // Text(
              //   'Danh sách tài khoản nhận biến động số dư',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // _buildListBank(context, provider),
              // _buildBgNote(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         '- Biến động số dư được bật khi bạn cho phép tính năng này hoạt động.',
              //         style: TextStyle(fontSize: 11),
              //       ),
              //       const SizedBox(
              //         height: 8,
              //       ),
              //       Text(
              //         '- Danh sách tài khoản ngân hàng khả dụng để nhận biến động số dư là các tài khoản ngân hàng đã được liên kết với hệ thống VietQR VN.',
              //         style: TextStyle(fontSize: 11),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 40,
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _itemBank(
      BankSelection dto, int index, SettingBDSDProvider settingProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5, color: Colors.grey),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.bank!.imgId),
                  ),
                ),
                // Placeholder for bank logo
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dto.bank!.bankAccount,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(dto.bank!.userBankName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          CupertinoSwitch(
            activeColor: AppColor.BLUE_TEXT,
            value: dto.value!,
            onChanged: (value) {
              settingProvider.selectValue(value, index);
              Map<String, dynamic> paramEnable = {};
              paramEnable['bankIds'] = settingProvider.getListId();
              paramEnable['userId'] = SharePrefUtils.getProfile().userId;
              _enableVoiceSetting(paramEnable, settingProvider);
            },
          )
        ],
      ),
    );
  }
  // Widget _buildListBank(BuildContext context, SettingBDSDProvider provider) {
  //   return BlocProvider<BankBloc>(
  //       create: (context) => BankBloc(context)..add(BankCardEventGetList()),
  //       child: BlocConsumer<BankBloc, BankState>(
  //         listener: (context, state) {},
  //         builder: (context, state) {
  //           List<BankAccountDTO> listBank =
  //               state.listBanks.where((dto) => dto.isAuthenticated).toList();
  //           return Column(
  //             children: listBank.map((bank) {
  //               return Container(
  //                 height: 60,
  //                 margin: EdgeInsets.only(top: 12),
  //                 padding: EdgeInsets.symmetric(horizontal: 20),
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: AppColor.WHITE),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: 35,
  //                       height: 35,
  //                       decoration: BoxDecoration(
  //                         color: AppColor.WHITE,
  //                         borderRadius: BorderRadius.circular(40),
  //                         border:
  //                             Border.all(width: 0.5, color: AppColor.GREY_TEXT),
  //                         image: DecorationImage(
  //                           image: ImageUtils.instance.getImageNetWork(
  //                             bank.imgId,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(left: 10)),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           '${bank.bankCode} - ${bank.bankAccount}',
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                               color: AppColor.BLACK,
  //                               fontWeight: FontWeight.w600),
  //                         ),
  //                         Text(
  //                           bank.userBankName.toUpperCase(),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             color: AppColor.BLACK,
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     Text(
  //                       provider.bankIds.contains(bank.id) ? 'Bật' : 'Tắt',
  //                       style:
  //                           TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
  //                     ),
  //                     Switch(
  //                       value: provider.bankIds.contains(bank.id),
  //                       activeColor: AppColor.BLUE_TEXT,
  //                       onChanged: (bool value) {
  //                         provider.updateListBank(bank.id);
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //           );
  //         },
  //       ));
  // }

  Widget _buildBgItem({required Widget child, EdgeInsets? customPadding}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: customPadding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }

  Widget _buildContainer({
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color ?? AppColor.WHITE,
      ),
      child: child,
    );
  }

  Widget _buildBgNote({required Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColor.BLUE_TEXT,
                size: 16,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Lưu ý:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          child,
        ],
      ),
    );
  }
}
