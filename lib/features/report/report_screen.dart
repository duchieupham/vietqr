import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/report/views/report_feedback_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final imagePicker = ImagePicker();
  final desController = TextEditingController();
  bool isEnableBT = false;
  DataModel model = DataModel(title: 'Vui lòng chọn mục liên quan', type: -1);
  bool _isSendSuccess = false;

  List<XFile> imageFileList = [];

  final List<DataModel> list = [
    DataModel(title: 'Vui lòng chọn mục liên quan', type: -1),
    DataModel(title: 'Liên kết TK Ngân hàng', type: 1),
    DataModel(title: 'Nạp tiền dịch vụ VietQR', type: 2),
    DataModel(title: 'Nạp tiền điện thoại', type: 3),
    DataModel(title: 'Doanh nghiệp và chia sẻ BĐSD', type: 4),
    DataModel(title: 'khác', type: 5),
  ];

  @override
  void initState() {
    super.initState();
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  bool enableList = false;

  _onHandleTap() {
    setState(() {
      enableList = !enableList;
    });
  }

  _onChanged(int index) {
    setState(() {
      enableList = !enableList;
      if (model != list[index]) {
        model = list[index];
      }

      if (model.type != -1 && desController.text.isNotEmpty) {
        isEnableBT = true;
      } else {
        isEnableBT = false;
      }
    });
  }

  _onSend() async {
    FocusManager.instance.primaryFocus?.unfocus();
    DialogWidget.instance.openLoadingDialog();
    final ResponseMessageDTO dto =
        await dashBoardRepository.sendReport(list: imageFileList, data: {
      'userId': SharePrefUtils.getProfile().userId,
      'type': '${model.type}',
      'description': desController.text,
    });

    if (dto.status == Stringify.RESPONSE_STATUS_SUCCESS) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        _isSendSuccess = true;
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      await DialogWidget.instance.openMsgDialog(
          title: 'Có lỗi xảy ra',
          msg:
              'Có vấn đề xảy ra khi thực hiện yêu cầu. \nVui lòng thử lại sau');
      setState(() {
        _isSendSuccess = false;
      });
    }
  }

  Widget _buildSearchList() => Container(
        height: 300.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 26.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          itemCount: list.length,
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () {
                _onChanged(position);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(
                  border: position != (list.length - 1)
                      ? const Border(
                          bottom:
                              BorderSide(color: AppColor.GREY_TEXT, width: 0.5))
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        list[position].title,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    if (position == 0)
                      const Icon(
                        Icons.expand_less,
                        color: AppColor.BLACK,
                        size: 16,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (enableList) {
          setState(() {
            enableList = !enableList;
          });
        }
      },
      child: Scaffold(
        appBar: const MAppBar(
          title: 'Báo cáo',
        ),
        body: SafeArea(
          child: _isSendSuccess
              ? const ReportFeedbackView()
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFieldCustom(
                                    isObscureText: false,
                                    maxLines: 1,
                                    isRequired: true,
                                    enable: false,
                                    textFieldType: TextfieldType.LABEL,
                                    title: 'Vấn đề của bạn liên quan tới',
                                    hintText: model.title,
                                    hintColor: AppColor.BLACK,
                                    inputType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    suffixIcon: const Icon(
                                      Icons.expand_more,
                                      color: AppColor.BLACK,
                                      size: 16,
                                    ),
                                    onTap: _onHandleTap,
                                  ),
                                  const SizedBox(height: 30),
                                  TextFieldCustom(
                                    isObscureText: false,
                                    maxLines: 6,
                                    isRequired: true,
                                    controller: desController,
                                    textFieldType: TextfieldType.LABEL,
                                    title: 'Cho chúng tôi biết vấn đề của bạn',
                                    hintText:
                                        'Mô tả vấn đề của bạn. Tối đa 1000 ký tự',
                                    inputType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    onChange: (value) {
                                      if (value.isNotEmpty &&
                                          model.type != -1) {
                                        isEnableBT = true;
                                      } else {
                                        isEnableBT = false;
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.BLACK,
                                          ),
                                          children: [
                                            const TextSpan(
                                                text: 'Hình ảnh đính kèm '),
                                            TextSpan(
                                              text:
                                                  '(${imageFileList.length}/3)',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColor.GREY_TEXT,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 110,
                                        child: Row(
                                          children: [
                                            if (imageFileList.length < 3)
                                              GestureDetector(
                                                onTap: () async {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  selectImages();
                                                  // await Permission.mediaLibrary.request();
                                                  // await imagePicker
                                                  //     .pickImage(source: ImageSource.gallery)
                                                  //     .then(
                                                  //   (pickedFile) async {
                                                  //     if (pickedFile != null) {
                                                  //       File? file = File(pickedFile.path);
                                                  //       File? compressedFile =
                                                  //           FileUtils.instance.compressImage(file);
                                                  //     }
                                                  //   },
                                                  // );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: AppColor.WHITE,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ic-img-blue.png',
                                                        color:
                                                            AppColor.GREY_TEXT,
                                                        width: 40,
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      const Text(
                                                        'Thêm ảnh',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColor
                                                              .GREY_TEXT,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (imageFileList.isNotEmpty)
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(
                                                        imageFileList.length,
                                                        (index) {
                                                      return _buildImage(
                                                          imageFileList
                                                              .elementAt(index),
                                                          index);
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              enableList ? _buildSearchList() : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MButtonWidget(
                      title: 'Gửi',
                      isEnable: isEnableBT,
                      onTap: _onSend,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImage(XFile file, int index) {
    return Container(
      height: 110,
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(file.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                    colors: <Color>[
                      AppColor.BLACK,
                      AppColor.BLACK.withOpacity(0.0),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          imageFileList.removeAt(index);
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 20,
                        color: AppColor.WHITE,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataModel {
  final String title;
  final int type;

  DataModel({required this.title, required this.type});
}
