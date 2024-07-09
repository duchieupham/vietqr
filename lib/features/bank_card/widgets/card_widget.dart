import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/popup_bank/popup_bank_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../commons/utils/format_date.dart';

class CardWidget extends StatelessWidget {
  final bool? isAuthen;
  final bool? isExtend;
  final List<BankAccountDTO> listBanks;
  final int index;
  final GestureTapCallback? onLinked;
  final GestureTapCallback? onActive;

  const CardWidget({
    super.key,
    required this.isAuthen,
    required this.isExtend,
    required this.listBanks,
    required this.index,
    this.onLinked,
    this.onActive,
  });

  String get userId => SharePrefUtils.getProfile().userId;

  double get heightCard => isAuthen! ? 170 : (isExtend! ? 90 : 126);

  double get paddingTop => 15;

  double get paddingIconCheck => 4;

  double get radius => 12;

  double get heightInfoCard => 50;

  double get widthInfoCard => 85;

  double get sizeIconCheck => 16;

  // PageRouteBuilder _customPageRoute(Widget page) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => page,
  //     transitionDuration: const Duration(milliseconds: 200), // Tắt animation
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    bool isFirst = (index != 0);
    bool isLast = (index == listBanks.length - 1);
    BankAccountDTO e = listBanks[index];
    // DateTime validFrom =
    //     DateTime.fromMillisecondsSinceEpoch(e.validFeeFrom! * 1000);
    DateTime now = DateTime.now();
    int millisecondsSinceEpoch = now.millisecondsSinceEpoch;
    DateTime dateTimeFromMilliseconds =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime validTo =
        DateTime.fromMillisecondsSinceEpoch(e.validFeeTo! * 1000);

    // Calculate the difference in days
    int daysDifference = validTo.difference(dateTimeFromMilliseconds).inDays;

    // Since we want to include both dates, add 1 to the result
    int inclusiveDays = daysDifference + 1;
    return GestureDetector(
      onTap: isExtend!
          ? null
          : () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankCardDetailScreen(bankId: e.id),
                  settings: const RouteSettings(
                    name: Routes.BANK_CARD_DETAIL_VEW,
                  ),
                ),
              );
            },
      onLongPress: isExtend!
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  allowSnapshotting: false,
                  builder: (context) =>
                      PopupBankScreen(tag: 'Card_$index', dto: e, index: index),
                  settings: const RouteSettings(name: ''),
                ),
              );
            },
      child: Container(
        height:
            isExtend! ? 90 : (isLast ? (heightCard - paddingTop) : heightCard),
        padding: EdgeInsets.only(top: isExtend! ? 10 : paddingTop),
        decoration: isExtend! == false
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: isFirst ? Colors.white : Colors.transparent)
            : const BoxDecoration(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: isExtend! ? AppColor.WHITE : e.bankColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 2,
                  color: AppColor.BLACK.withOpacity(0.3),
                )
              ]),
          child: Stack(
            children: [
              Column(children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: isExtend! ? 0.0 : 16.0, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: widthInfoCard,
                            height: heightInfoCard,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: widthInfoCard - 10,
                                    height: heightInfoCard - 10,
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE,
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(e.imgId),
                                      ),
                                    ),
                                    // child: XImage(imagePath: e.imgId),
                                  ),
                                ),
                                if (e.isAuthenticated &&
                                    e.isOwner &&
                                    isExtend == false)
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: XImage(
                                      imagePath:
                                          ImageConstant.icAuthenticatedBank,
                                      width: 28,
                                    ),
                                  ),
                                if (!e.isOwner && isExtend == false)
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: XImage(
                                      imagePath: ImageConstant.icSharedBank,
                                      width: 28,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            height: heightInfoCard,
                            // padding: const EdgeInsets.only(right: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: widthInfoCard * 2 - 2,
                                  height: heightInfoCard - 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.bankAccount,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: isExtend!
                                                ? AppColor.BLACK
                                                : AppColor.WHITE,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        e.userBankName.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isExtend!
                                              ? AppColor.BLACK
                                              : AppColor.WHITE,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      isExtend!
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: onActive,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // height: 20,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: AppColor.BLUE_TEXT,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Gia hạn",
                                      style: TextStyle(
                                          fontSize: 12, color: AppColor.WHITE),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                if (isAuthen == true) ...[
                  const SizedBox(height: 30),
                  const MySeparator(
                    color: AppColor.WHITE,
                  ),
                  e.isOwner == false && e.isValidService == false
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(20, 8, 10, 10),
                          width: double.infinity,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle_outline,
                                    size: 15,
                                    color: AppColor.WHITE,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Chưa đăng ký dịch vụ",
                                    style: TextStyle(
                                        fontSize: 12, color: AppColor.WHITE),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          // onTap: !e.isValidService! ? onActive : null,
                          onTap: onActive,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
                            width: double.infinity,
                            child: (e.isValidService!)
                                ? (inclusiveDays != 0)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: AppColor.BLUE_TEXT,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: const Center(
                                              child: Text(
                                                'Gia hạn',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.WHITE),
                                              ),
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     const SizedBox(width: 5),
                                          //     Text(
                                          //       "Đã đăng ký dịch vụ VietQR",
                                          //       style: TextStyle(
                                          //           fontSize: 12,
                                          //           color: AppColor.WHITE),
                                          //     )
                                          //   ],
                                          // ),
                                          inclusiveDays <= 7
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 10, 5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColor.RED_FFFF0000,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Center(
                                                    child: Text(
                                                      "Còn $inclusiveDays ngày hết hạn",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColor.WHITE),
                                                    ),
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      size: 15,
                                                      color: AppColor.WHITE,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Đến ${timestampToDate(e.validFeeTo!)}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColor.WHITE),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      )
                                    : Row(
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: onActive,
                                            child: Container(
                                              // width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              height: 26,
                                              decoration: BoxDecoration(
                                                  color: AppColor.BLUE_TEXT,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Center(
                                                child: Text(
                                                  "Gia hạn dịch vụ VietQR",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.WHITE),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                : Row(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: onActive,
                                        child: Container(
                                          // width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          height: 26,
                                          decoration: BoxDecoration(
                                              color: AppColor.BLUE_TEXT,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: const Center(
                                            child: Text(
                                              "Đăng ký dịch vụ VietQR",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.WHITE),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                ] else
                  const SizedBox.shrink(),
              ]),
              isExtend! == false
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              allowSnapshotting: false,
                              builder: (context) => PopupBankScreen(
                                  tag: 'Card_$index', dto: e, index: index),
                              settings: const RouteSettings(name: ''),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: AssetImage(ImageConstant.icMoreInList),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              if (e.isLinked && isExtend == false)
                Positioned(
                  right: 8,
                  bottom: isLast ? (28 - paddingTop) : 28,
                  child: GestureDetector(
                    onTap: onLinked,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColor.BLUE_TEXT,
                      ),
                      child: const Row(
                        children: [
                          XImage(
                            imagePath: ImageConstant.icLinkedBankInList,
                            width: 24,
                            height: 24,
                          ),
                          Text(
                            'Liên kết ngay',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColor.WHITE,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
