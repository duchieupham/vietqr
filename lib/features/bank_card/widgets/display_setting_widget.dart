import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/setting_bdsd_provider.dart';

// ignore: must_be_immutable
class DisplaySettingWidget extends StatefulWidget {
  DisplaySettingWidget(
      {super.key, required this.listIsOwnerBank, required this.width});

  List<BankAccountDTO> listIsOwnerBank;
  double width;

  @override
  State<DisplaySettingWidget> createState() => _DisplaySettingWidgetState();
}

class _DisplaySettingWidgetState extends State<DisplaySettingWidget> {
  final DashBoardBloc _bloc = getIt.get<DashBoardBloc>();
  bool onOffBdsd = false;

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

  void _enablePopupNoti(
      SettingBDSDProvider provider, int value, String userId) async {
    try {
      final listIsOwnerBank = widget.listIsOwnerBank;

      bool enableStatus =
          await accRepository.setNotificationBDSD(value, userId);
      if (enableStatus) {
        if (listIsOwnerBank.isNotEmpty) {
          for (var e in listIsOwnerBank) {
            e.pushNotification = (provider.enablePopup) ? 1 : 0;
          }
        }

        await SharePrefUtils.saveListOwnerBanks(listIsOwnerBank);
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      width: widget.width,
      child: Consumer<SettingBDSDProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cài đặt hiển thị',
                style: TextStyle(
                    color: AppColor.BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-voice-black.png',
                      color: AppColor.BLUE_TEXT,
                      height: 40,
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Nhận thông báo với giọng nói',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Switch(
                      value: provider.enableVoice,
                      trackColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColor.BLUE_TEXT.withOpacity(0.3);
                        }
                        return AppColor.GREY_DADADA.withOpacity(0.3);
                      }),
                      thumbColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColor.BLUE_TEXT;
                        }
                        return AppColor.GREY_DADADA;
                      }),
                      trackOutlineColor: WidgetStateProperty.resolveWith(
                        (final Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return null;
                          }

                          return AppColor.TRANSPARENT;
                        },
                      ),
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
              _buildDashLine(),
              Row(
                children: [
                  const XImage(
                    imagePath: 'assets/images/ic-popup-settings.png',
                    color: AppColor.BLUE_TEXT,
                    height: 40,
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Hiển thị Pop-up thông báo BĐSD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Switch(
                    value: provider.enablePopup,
                    trackColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColor.BLUE_TEXT.withOpacity(0.3);
                      }
                      return AppColor.GREY_DADADA.withOpacity(0.3);
                    }),
                    thumbColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColor.BLUE_TEXT;
                      }
                      return AppColor.GREY_DADADA;
                    }),
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                      (final Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return null;
                        }

                        return AppColor.TRANSPARENT;
                      },
                    ),
                    onChanged: (bool value) {
                      provider.updateOpenPopupNoti(value);

                      String userId = SharePrefUtils.getProfile().userId;
                      // for (var e in provider.listVoiceBank) {
                      //   e.enableVoice = value;
                      // }
                      _enablePopupNoti(provider, value ? 1 : 0, userId);
                    },
                  ),
                ],
              ),
              _buildDashLine(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-screenon.png',
                      color: AppColor.BLUE_TEXT,
                      height: 40,
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Màn hình luôn sáng khi hiển thị QR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Consumer<AuthenProvider>(
                      builder: (context, provider, _) {
                        return Switch(
                          value: provider.settingDTO.keepScreenOn,
                          trackColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColor.BLUE_TEXT.withOpacity(0.3);
                            }
                            return AppColor.GREY_DADADA.withOpacity(0.3);
                          }),
                          thumbColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColor.BLUE_TEXT;
                            }
                            return AppColor.GREY_DADADA;
                          }),
                          trackOutlineColor: WidgetStateProperty.resolveWith(
                            (final Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return null;
                              }

                              return AppColor.TRANSPARENT;
                            },
                          ),
                          onChanged: (bool value) {
                            _bloc.add(UpdateKeepBrightEvent(value));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        double dashHeight = 1;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppColor.GREY_DADADA),
              ),
            );
          }),
        );
      },
    );
  }
}
