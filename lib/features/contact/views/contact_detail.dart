import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
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
import '../../../commons/widgets/viet_qr.dart';
import '../../../models/qr_generated_dto.dart';
import '../../../services/shared_references/user_information_helper.dart';
import '../../printer/views/printing_view.dart';
import 'contact_edit_view.dart';

// ignore: must_be_immutable
class ContactDetailScreen extends StatefulWidget {
  final ContactDTO dto;
  final bool isEdit;

  const ContactDetailScreen(
      {super.key, required this.dto, required this.isEdit});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final GlobalKey globalKey = GlobalKey();
  QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
    bankCode: '',
    bankName: '',
    bankAccount: '',
    userBankName: '',
    amount: '',
    content: '',
    qrCode: '',
    imgId: '',
  );

  Future<void> share({required QRGeneratedDTO dto}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: globalKey,
        textSharing: ShareUtils.instance.getTextSharing(dto),
      );
    });
  }

  void actionServices(
      BuildContext context, String action, QRGeneratedDTO dto) async {
    if (action == 'SAVE') {
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
          Fluttertoast.showToast(
            msg: 'Đã lưu ảnh',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          // Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider<ContactBloc>(
      create: (context) =>
          ContactBloc(context)..add(ContactEventGetDetail(id: widget.dto.id)),
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == BlocStatus.UNLOADING) {
            qrGeneratedDTO = QRGeneratedDTO(
              bankCode: state.contactDetailDTO.bankShortName ?? '',
              bankName: state.contactDetailDTO.bankName ?? '',
              bankAccount: state.contactDetailDTO.bankAccount ?? '',
              userBankName: state.contactDetailDTO.nickName ?? '',
              amount: '',
              content: '',
              qrCode: state.contactDetailDTO.value ?? '',
              imgId: state.contactDetailDTO.imgId ?? '',
            );
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
              actions: widget.isEdit && state.contactDetailDTO.type == 2
                  ? [
                      GestureDetector(
                        onTap: () async {
                          final data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ContactEditView(
                                  contactDetailDTO: state.contactDetailDTO),
                              // settings: RouteSettings(name: ContactEditView.routeName),
                            ),
                          );

                          if (!mounted) return;
                          if (data is bool) {
                            BlocProvider.of<ContactBloc>(context)
                                .add(ContactEventGetDetail(id: widget.dto.id));
                          }
                        },
                        child: Image.asset(
                          'assets/images/ic-edit.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ]
                  : null,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          if (state.status == BlocStatus.LOADING)
                            Padding(
                              padding: EdgeInsets.only(top: height / 3),
                              child: const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ),
                            )
                          else
                            _buildViewCard(state.contactDetailDTO, context)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
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
                                      actionServices(
                                          context, 'SAVE', qrGeneratedDTO);
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
                                    function: () async {
                                      await share(dto: qrGeneratedDTO);
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

  ImageProvider getEmbeddedImageImage(ContactDetailDTO dto) {
    if (dto.type == 1 || dto.type == 3) {
      if (dto.imgId?.isNotEmpty ?? false) {
        return ImageUtils.instance.getImageNetworkCache(dto.imgId ?? '');
      }
    }
    return const AssetImage('assets/images/ic-viet-qr-small.png');
  }

  Widget _buildTypeQr(ContactDetailDTO dto, {required Function()? onEdit}) {
    Widget buttonEdit = widget.isEdit
        ? GestureDetector(
            onTap: onEdit,
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
          )
        : const SizedBox();
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
                image: dto.type == 2
                    ? DecorationImage(
                        image: ImageUtils.instance
                            .getImageNetWork(dto.imgId ?? ''),
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
              image: dto.imgId?.isNotEmpty ?? false
                  ? DecorationImage(
                      image: ImageUtils.instance
                          .getImageNetworkCache(dto.imgId ?? ''),
                      fit: BoxFit.cover)
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
                  'Thẻ khác',
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

  Widget _buildViewCard(ContactDetailDTO dto, BuildContext contextBloc) {
    if (dto.type == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return VietQr(qrGeneratedDTO: qrGeneratedDTO);
              }),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Mô tả QR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: Text(dto.additionalData ?? ''),
            ),
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              RepaintBoundaryWidget(
                  globalKey: globalKey,
                  builder: (key) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: dto.getBgGradient()),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 68, bottom: 32),
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                            ),
                            child: Stack(
                              children: [
                                QrImage(
                                  data: dto.value ?? '',
                                  version: QrVersions.auto,
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.cover,
                                        image: getEmbeddedImageImage(dto),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            dto.nickName ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.WHITE),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            dto.additionalData ?? '',
                            style: TextStyle(color: AppColor.WHITE),
                          ),
                          if (dto.type == 3 && dto.value!.contains('https'))
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Đường dẫn: ',
                                    ),
                                    TextSpan(
                                      text: dto.value ?? '',
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          // ignore: deprecated_member_use
                                          await launch(
                                            dto.value ?? '',
                                            forceSafariVC: false,
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    );
                  }),
              Positioned(
                top: 32,
                right: 0,
                left: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypeQr(
                      dto,
                      onEdit: () async {
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ContactEditView(contactDetailDTO: dto),
                          ),
                        );

                        if (!mounted) return;
                        if (data is bool) {
                          BlocProvider.of<ContactBloc>(contextBloc)
                              .add(ContactEventGetDetail(id: widget.dto.id));
                        }
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColor.greyF0F0F0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      );
    }
  }
}
