import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DialogUpdateView extends StatefulWidget {
  final bool isHideClose;
  final Function() onCheckUpdate;

  const DialogUpdateView(
      {super.key, this.isHideClose = false, required this.onCheckUpdate});

  @override
  State<DialogUpdateView> createState() => _DialogUpdateViewState();
}

class _DialogUpdateViewState extends State<DialogUpdateView> {
  bool isCheckApp = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<AuthProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: UserInformationHelper.instance.getUserId().isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: provider.settingDTO.logoUrl,
                          width: 130,
                          height: 130,
                        )
                      : provider.fileLogo.path.isNotEmpty
                          ? Image.file(
                              provider.fileLogo,
                              width: 130,
                              height: 130,
                            )
                          : Image.asset(
                              'assets/images/logo_vietgr_payment.png',
                              width: 130,
                              height: 130,
                            ),
                );
              }),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  if (provider.isCheckApp) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Đang kiểm tra',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 50),
                          ButtonWidget(
                            height: 40,
                            text: 'Huỷ',
                            textColor: AppColor.BLACK,
                            bgColor: AppColor.GREY_EBEBEB,
                            borderRadius: 5,
                            function: () {
                              provider.updateIsCheckApp(false);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Phiên bản hiện tại: ${provider.packageInfo?.version ?? ''}',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 10),
                        provider.isShowToastUpdate == 1
                            ? ButtonWidget(
                                height: 40,
                                text: 'Cập nhật bản: ${provider.versionApp}',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 5,
                                function: () async {
                                  Uri uri = Uri.parse(Stringify.urlStore);
                                  if (!await launchUrl(uri,
                                      mode: LaunchMode.externalApplication)) {}
                                },
                              )
                            : ButtonWidget(
                                height: 40,
                                text: 'Kiểm tra cập nhật',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 5,
                                function: () {
                                  provider.updateIsCheckApp(true);
                                  widget.onCheckUpdate();
                                },
                              ),
                        const SizedBox(height: 10),
                        if (!widget.isHideClose) ...[
                          ButtonWidget(
                            height: 40,
                            text: 'Đóng',
                            textColor: AppColor.BLACK,
                            bgColor: AppColor.GREY_EBEBEB,
                            borderRadius: 5,
                            function: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 10),
                        ]
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
