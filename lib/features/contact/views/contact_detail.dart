import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import '../../../commons/utils/printer_utils.dart';
import '../../../commons/widgets/button_icon_widget.dart';
import '../../../models/qr_generated_dto.dart';
import '../../../services/shared_references/user_information_helper.dart';
import '../../printer/views/printing_view.dart';
import 'contact_edit_view.dart';

// ignore: must_be_immutable
class ContactDetailScreen extends StatefulWidget {
  final ContactDTO dto;

  const ContactDetailScreen({super.key, required this.dto});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) =>
          ContactBloc(context)..add(ContactEventGetDetail(id: widget.dto.id)),
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == BlocStatus.UNLOADING) {
            // Navigator.pop(context);
          }

          if (state.type == ContactType.REMOVE) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: 'Xoá thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          }

          if (state.type == ContactType.UPDATE) {}

          if (state.type == ContactType.GET_LIST) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: MAppBar(
              title: 'Thẻ QR',
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: state.contactDetailDTO.getBgGradient()),
                          child: Column(
                            children: [
                              _buildTypeQr(state.contactDetailDTO,
                                  onEdit: () async {
                                final data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ContactEditView(
                                        contactDetailDTO:
                                            state.contactDetailDTO),
                                    // settings: RouteSettings(name: ContactEditView.routeName),
                                  ),
                                );

                                if (!mounted) return;
                                if (data is bool) {
                                  BlocProvider.of<ContactBloc>(context).add(
                                      ContactEventGetDetail(id: widget.dto.id));
                                }
                              }),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: AppColor.greyF0F0F0,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 40, right: 40, top: 68, bottom: 32),
                                decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                ),
                                child: QrImage(
                                  data: state.contactDetailDTO.value ?? '',
                                  version: QrVersions.auto,
                                  embeddedImage: const AssetImage(
                                      'assets/images/ic-viet-qr-small.png'),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: const Size(30, 30),
                                  ),
                                ),
                              ),
                              Text(
                                state.contactDetailDTO.nickName ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.WHITE),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                state.contactDetailDTO.additionalData ?? '',
                                style: TextStyle(color: AppColor.WHITE),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ButtonIconWidget(
                                    height: 40,
                                    pathIcon: 'assets/images/ic-print-blue.png',
                                    title: '',
                                    function: () async {
                                      BluetoothPrinterDTO bluetoothPrinterDTO =
                                          await LocalDatabase.instance
                                              .getBluetoothPrinter(
                                                  UserInformationHelper.instance
                                                      .getUserId());
                                      if (bluetoothPrinterDTO.id.isNotEmpty) {
                                        bool isPrinting = false;
                                        if (!isPrinting) {
                                          isPrinting = true;
                                          DialogWidget.instance
                                              .showFullModalBottomContent(
                                                  widget: const PrintingView());
                                          QRGeneratedDTO qrGeneratedDTO =
                                              QRGeneratedDTO(
                                            bankCode: state.contactDetailDTO
                                                    .bankShortName ??
                                                '',
                                            bankName: state.contactDetailDTO
                                                    .bankName ??
                                                '',
                                            bankAccount: state.contactDetailDTO
                                                    .bankAccount ??
                                                '',
                                            userBankName: state.contactDetailDTO
                                                    .nickName ??
                                                '',
                                            amount: '',
                                            content: '',
                                            qrCode:
                                                state.contactDetailDTO.value ??
                                                    '',
                                            imgId:
                                                state.contactDetailDTO.imgId ??
                                                    '',
                                          );
                                          await PrinterUtils.instance
                                              .print(qrGeneratedDTO)
                                              .then((value) {
                                            Navigator.pop(context);
                                            isPrinting = false;
                                          });
                                        }
                                      } else {
                                        DialogWidget.instance.openMsgDialog(
                                            title: 'Không thể in',
                                            msg:
                                                'Vui lòng kết nối với máy in để thực hiện việc in.');
                                      }
                                    },
                                    bgColor: Theme.of(context).cardColor,
                                    textColor: AppColor.ORANGE,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                  child: ButtonIconWidget(
                                    height: 40,
                                    pathIcon:
                                        'assets/images/ic-edit-avatar-setting.png',
                                    title: '',
                                    function: () {
                                      QRGeneratedDTO qrGeneratedDTO =
                                          QRGeneratedDTO(
                                        bankCode: state.contactDetailDTO
                                                .bankShortName ??
                                            '',
                                        bankName:
                                            state.contactDetailDTO.bankName ??
                                                '',
                                        bankAccount: state
                                                .contactDetailDTO.bankAccount ??
                                            '',
                                        userBankName:
                                            state.contactDetailDTO.nickName ??
                                                '',
                                        amount: '',
                                        content: '',
                                        qrCode:
                                            state.contactDetailDTO.value ?? '',
                                        imgId:
                                            state.contactDetailDTO.imgId ?? '',
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        Routes.QR_SHARE_VIEW,
                                        arguments: {
                                          'qrGeneratedDTO': qrGeneratedDTO,
                                          'action': 'SAVE'
                                        },
                                      );
                                    },
                                    bgColor: Theme.of(context).cardColor,
                                    textColor: AppColor.RED_CALENDAR,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                  child: ButtonIconWidget(
                                    height: 40,
                                    pathIcon: 'assets/images/ic-copy-blue.png',
                                    title: '',
                                    function: () async {
                                      QRGeneratedDTO qrGeneratedDTO =
                                          QRGeneratedDTO(
                                        bankCode: state.contactDetailDTO
                                                .bankShortName ??
                                            '',
                                        bankName:
                                            state.contactDetailDTO.bankName ??
                                                '',
                                        bankAccount: state
                                                .contactDetailDTO.bankAccount ??
                                            '',
                                        userBankName:
                                            state.contactDetailDTO.nickName ??
                                                '',
                                        amount: '',
                                        content: '',
                                        qrCode:
                                            state.contactDetailDTO.value ?? '',
                                        imgId:
                                            state.contactDetailDTO.imgId ?? '',
                                      );
                                      await FlutterClipboard.copy(ShareUtils
                                              .instance
                                              .getTextSharing(qrGeneratedDTO))
                                          .then(
                                        (value) => Fluttertoast.showToast(
                                          msg: 'Đã sao chép',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                          textColor:
                                              Theme.of(context).hintColor,
                                          fontSize: 15,
                                          webBgColor: 'rgba(255, 255, 255)',
                                          webPosition: 'center',
                                        ),
                                      );
                                    },
                                    bgColor: Theme.of(context).cardColor,
                                    textColor: AppColor.BLUE_TEXT,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                  child: ButtonIconWidget(
                                    height: 40,
                                    pathIcon: 'assets/images/ic-share-blue.png',
                                    title: '',
                                    function: () {
                                      QRGeneratedDTO qrGeneratedDTO =
                                          QRGeneratedDTO(
                                        bankCode: state.contactDetailDTO
                                                .bankShortName ??
                                            '',
                                        bankName:
                                            state.contactDetailDTO.bankName ??
                                                '',
                                        bankAccount: state
                                                .contactDetailDTO.bankAccount ??
                                            '',
                                        userBankName:
                                            state.contactDetailDTO.nickName ??
                                                '',
                                        amount: '',
                                        content: '',
                                        qrCode:
                                            state.contactDetailDTO.value ?? '',
                                        imgId:
                                            state.contactDetailDTO.imgId ?? '',
                                      );
                                      Navigator.pushNamed(
                                          context, Routes.QR_SHARE_VIEW,
                                          arguments: {
                                            'qrGeneratedDTO': qrGeneratedDTO
                                          });
                                    },
                                    bgColor: Theme.of(context).cardColor,
                                    textColor: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeQr(ContactDetailDTO dto, {required Function onEdit}) {
    Widget buttonEdit = GestureDetector(
      onTap: () {
        onEdit();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: AppColor.GREY_BUTTON.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          'Sửa',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
    if (dto.type == 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.WHITE,
                image: DecorationImage(
                    image:
                        ImageUtils.instance.getImageNetWork(dto.imgId ?? '')),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.nickName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dto.bankShortName ?? '',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            buttonEdit,
          ],
        ),
      );
    } else if (dto.type == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(40),
                image: dto?.type == 2
                    ? DecorationImage(
                        image: ImageUtils.instance
                            .getImageNetWork(dto?.imgId ?? ''),
                        fit: BoxFit.contain)
                    : const DecorationImage(
                        image: AssetImage('assets/images/ic-viet-qr-small.png'),
                        fit: BoxFit.contain),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.nickName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'VietQR ID',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            buttonEdit,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(40),
              image: dto?.type == 2
                  ? DecorationImage(
                      image:
                          ImageUtils.instance.getImageNetWork(dto?.imgId ?? ''),
                      fit: BoxFit.contain)
                  : const DecorationImage(
                      image: AssetImage('assets/images/ic-viet-qr-small.png'),
                      fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
