import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/features/verify_email/widgets/popup_key_free.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';

class KeyActiveFreeScreen extends StatefulWidget {
  const KeyActiveFreeScreen({super.key});

  @override
  State<KeyActiveFreeScreen> createState() => _KeyActiveFreeScreenState();
  static String routeName = '/key_active_free';
}

class _KeyActiveFreeScreenState extends State<KeyActiveFreeScreen> {
  List<BankAccountDTO> list = [];
  KeyFreeDTO? keyDTO;

  final EmailBloc _bloc = getIt.get<EmailBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    setState(() {
      list = Provider.of<ConnectMediaProvider>(context, listen: false)
          .listIsOwnerBank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailBloc, EmailState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is GetKeyFreeSuccessfulState) {
          keyDTO = state.keyFreeDTO;
          DialogWidget.instance.showModelBottomSheet(
              borderRadius: BorderRadius.circular(16),
              widget: PopUpKeyFree(
                dto: state.dto,
                keyDTO: keyDTO!,
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: AppBar(
            leadingWidth: 120,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Text('Trở về'),
                ],
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: XImage(
                  imagePath: 'assets/images/ic-viet-qr.png',
                  width: 80,
                ),
              ),
            ],
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context).pop();
              // Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    // Gradient border
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 2,
                            color: Colors.transparent,
                          ),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          XImage(
                            imagePath: 'assets/images/ic-home-gradient.png',
                            width: 40,
                          ),
                          SizedBox(width: 4),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF00C6FF),
                                Color(0xFF0072FF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              'Trang chủ',
                              style: TextStyle(
                                fontSize: 15,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 30)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Lấy mã kích hoạt dịch vụ\nVietQR miễn phí 01 tháng',
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  'Danh sách tài khoản ngân hàng đã liên kết của bạn.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      return _itemBank(list[index], index);
                    },
                    itemCount: list.length,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemBank(
    BankAccountDTO dto,
    int index,
  ) {
    return Column(
      children: [
        Container(
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
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dto.bankAccount,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(dto.userBankName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              dto.activeKey == true
                  ? InkWell(
                      onTap: () {
                        Map<String, dynamic> param = {
                          'duration': 1,
                          'numOfKeys': 1,
                          'bankId': dto.id,
                          'userId': SharePrefUtils.getProfile().userId,
                        };
                        _bloc.add(GetKeyFreeEvent(param: param, dto: dto));
                        // DialogWidget.instance.showModelBottomSheet(
                        //     borderRadius: BorderRadius.circular(16),
                        //     widget: PopUpKeyFree(
                        //       dto: dto,
                        //       keyDTO: keyDTO!,
                        //     ));
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Đã kích hoạt',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Map<String, dynamic> param = {
                          'duration': 1,
                          'numOfKeys': 1,
                          'bankId': dto.id,
                          'userId': SharePrefUtils.getProfile().userId,
                        };
                        _bloc.add(GetKeyFreeEvent(param: param, dto: dto));
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Lấy mã',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
      ],
    );
  }
}
