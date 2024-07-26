import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/maintain_charge/events/maintain_charge_events.dart';
import 'package:vierqr/models/confirm_manitain_charge_dto.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../models/maintain_charge_create.dart';
import '../../../models/maintain_charge_dto.dart';
import '../blocs/maintain_charge_bloc.dart';
import '../states/maintain_charge_state.dart';

class ConfirmActiveKeyScreen extends StatelessWidget {
  final MaintainChargeDTO dto;
  final MaintainChargeCreate createDto;
  const ConfirmActiveKeyScreen({
    super.key,
    required this.dto,
    required this.createDto,
  });

  String timestampToDate(int timestamp) {
    // Create a DateTime object from the timestamp
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Format the date in the desired format
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottom(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leadingWidth: 100,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25,
                    ),
                    SizedBox(width: 2),
                    Text(
                      "Trở về",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  AppImages.icLogoVietQr,
                  width: 95,
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const Text(
                      "Xác nhận thông tin kích hoạt \ndịch vụ phần mềm VietQR",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "TK kích hoạt:",
                            style: TextStyle(fontSize: 15),
                          ),
                          Consumer<MaintainChargeProvider>(
                            builder: (context, value, child) {
                              String text = '';
                              if (value.bankAccount != null &&
                                  value.bankName != null) {
                                text =
                                    '${value.bankName} - ${value.bankAccount}';
                              }
                              return Text(
                                text,
                                style: const TextStyle(fontSize: 15),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Mã:",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            dto.key ?? '',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Thời hạn mã:",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "${dto.duration.toString()} tháng",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Từ ngày",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                timestampToDate(dto.validFrom!),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColor.BLACK,
                            size: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Đến ngày",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                timestampToDate(dto.validTo!),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintainChargeBloc(context),
      child: BlocBuilder<MaintainChargeBloc, MaintainChargeState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
            child: InkWell(
              onTap: () {
                BlocProvider.of<MaintainChargeBloc>(context).add(
                    ConfirmMaintainChargeEvent(
                        dto: ConfirmMaintainCharge(
                            keyValue: createDto.key,
                            otp: dto.otp!,
                            bankId: createDto.bankId,
                            userId: createDto.userId,
                            password: createDto.password)));
                // _bloc.add(ConfirmMaintainChargeEvent(
                //     dto: ConfirmMaintainCharge(
                //         otp: state.dto!.otp!,
                //         bankId: state.createDto!.bankId,
                //         userId: state.createDto!.userId,
                //         password: state.createDto!.password)));
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(5)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "Xác nhận",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
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
}
