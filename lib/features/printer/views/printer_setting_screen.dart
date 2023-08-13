import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:vierqr/features/printer/blocs/printer_bloc.dart';
import 'package:vierqr/features/printer/events/printer_event.dart';
import 'package:vierqr/features/printer/states/printer_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class PrinterSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrinterBloc>(
      create: (BuildContext context) => PrinterBloc(),
      child: PrinterSettingView(),
    );
  }
}

class PrinterSettingView extends StatefulWidget {
  PrinterSettingView({super.key});

  @override
  State<PrinterSettingView> createState() => _PrinterSettingViewState();
}

class _PrinterSettingViewState extends State<PrinterSettingView> {
  late CountdownProvider _countdownProvider = CountdownProvider(10);

  late PrinterBloc _printerBloc;

  List<PrinterBluetooth> printers = [];

  void initialServices(BuildContext context) {
    String userId = UserInformationHelper.instance.getUserId();
    printers.clear();
    _printerBloc = BlocProvider.of(context);
    _printerBloc.add(PrinterInitialEvent());
    _printerBloc.add(PrinterEventCheck(userId: userId));
  }

  //   if (PlatformUtils.instance.isPhysicalDevice()) {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      body: Column(
        children: [
          const SubHeader(title: 'Cài đặt máy in'),
          Expanded(
            child: BlocConsumer<PrinterBloc, PrinterState>(
              listener: (context, state) {
                if (state is PrinterRemoveSuccessState ||
                    state is PrinterSavedSuccessState) {
                  String userId = UserInformationHelper.instance.getUserId();
                  _printerBloc.add(PrinterEventCheck(userId: userId));
                }
              },
              builder: (context, state) {
                if (state is PrinterCheckExistedState) {
                  if (state.dto.id.isNotEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            width: width * 0.2,
                            child: Image.asset(
                              'assets/images/ic-printer.png',
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                            'Máy in đã kết nối',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildElement(
                          context: context,
                          title: 'Tên thiết bị',
                          description: state.dto.name,
                        ),
                        _buildElement(
                          context: context,
                          title: 'IP',
                          description: state.dto.address,
                        ),
                        const Spacer(),
                        Center(
                          child: ButtonIconWidget(
                            width: width - 40,
                            height: 40,
                            icon: Icons.bluetooth_disabled_rounded,
                            title: 'Huỷ kết nối',
                            function: () {
                              String userId =
                                  UserInformationHelper.instance.getUserId();
                              _printerBloc
                                  .add(PrinterEventRemove(userId: userId));
                            },
                            bgColor: Theme.of(context).cardColor,
                            textColor: AppColor.RED_TEXT,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 30)),
                      ],
                    );
                  }
                }
                if (state is PrinterScanningState ||
                    state is PrinterReceiveSuccessState) {
                  if (state is PrinterReceiveSuccessState) {
                    if (printers.isEmpty) {
                      printers.add(state.printer);
                    } else {
                      if (printers
                          .where((element) =>
                              element.address == state.printer.address)
                          .isEmpty) {
                        printers.add(state.printer);
                      }
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Danh sách thiết bị gần đây',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            ValueListenableBuilder(
                              valueListenable: _countdownProvider,
                              builder: (_, value, child) {
                                return (value != 0)
                                    ? SizedBox(
                                        child: Text(
                                          'Còn $value giây quét lại',
                                          style: const TextStyle(
                                            color: AppColor.GREY_TEXT,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : ButtonIconWidget(
                                        width: 100,
                                        icon: Icons.refresh_rounded,
                                        title: 'Quét lại',
                                        textSize: 12,
                                        function: () {
                                          printers.clear();
                                          _printerBloc.add(PrinterEventScan(
                                              printerBloc: _printerBloc));
                                          _countdownProvider =
                                              CountdownProvider(10);
                                          _countdownProvider.countDown();
                                        },
                                        bgColor: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.3),
                                        textColor: AppColor.GREEN,
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          if (printers.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: printers.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    DialogWidget.instance.openBoxWebConfirm(
                                      title: 'Xác nhận kết nối',
                                      confirmText: 'Kết nối',
                                      imageAsset:
                                          'assets/images/ic-printer.png',
                                      description:
                                          'Xác nhận kết nối với máy in ${printers[index].name}? Hệ thống sẽ tự động kết nối với thiết bị này cho việc in mã VietQR.',
                                      confirmFunction: () {
                                        Navigator.pop(context);
                                        String userId = UserInformationHelper
                                            .instance
                                            .getUserId();
                                        const Uuid uuid = Uuid();
                                        BluetoothPrinterDTO printer =
                                            BluetoothPrinterDTO(
                                          id: uuid.v1(),
                                          name: printers[index].name ?? '',
                                          address:
                                              printers[index].address ?? '',
                                          userId: userId,
                                        );
                                        _printerBloc.add(
                                            PrinterEventSave(printer: printer));
                                      },
                                    );
                                  },
                                  child: BoxLayout(
                                    width: width,
                                    borderRadius: 5,
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                          child: Image.asset(
                                            'assets/images/ic-printer.png',
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 10)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                printers[index].name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                // style: const TextStyle(fontSize: 10),
                                              ),
                                              Text(
                                                printers[index].address ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      const Spacer(),
                      const Center(
                        child: Text(
                          'Chọn thiết bị',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Chọn một thiết bị để kết nối',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 30)),
                    ],
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: width * 0.5,
                      child: Image.asset(
                        'assets/images/ic-printer.png',
                      ),
                    ),
                    const Spacer(),
                    // const Padding(padding: EdgeInsets.only(top: 30)),
                    const Text(
                      'Kết nối với máy in',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Chức năng Bluetooth trên máy in cho phép kết nối với điện thoại di động, giúp bạn dễ dàng in các mã VietQR từ hệ thống trực tuyến.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 30)),
                    ButtonIconWidget(
                      width: width - 40,
                      height: 40,
                      title: 'Quét thiết bị',
                      icon: Icons.bluetooth_searching_rounded,
                      textColor: AppColor.BLUE_TEXT,
                      bgColor: Theme.of(context).cardColor,
                      function: () {
                        _printerBloc
                            .add(PrinterEventScan(printerBloc: _printerBloc));
                        _countdownProvider = CountdownProvider(10);
                        _countdownProvider.countDown();
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 30)),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildElement(
      {required BuildContext context,
      required String title,
      required String description}) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title),
          ),
          Expanded(
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
