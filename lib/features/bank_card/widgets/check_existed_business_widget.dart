import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/branch_choice_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class CheckExistedBusinessWidget extends StatelessWidget {
  static late BranchBloc branchBloc;
  static bool isInitial = false;

  const CheckExistedBusinessWidget({super.key});

  void initialServices(BuildContext context) {
    isInitial = true;
    String userId = UserInformationHelper.instance.getUserId();
    branchBloc = BlocProvider.of(context);
    branchBloc.add(BranchEventGetChoice(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return SizedBox(
      width: width,
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Chọn doanh nghiệp',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    isInitial = false;
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: DefaultTheme.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          Expanded(child: BlocBuilder<BranchBloc, BranchState>(
            builder: (context, state) {
              if (state is BranchChoiceLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: DefaultTheme.GREEN,
                  ),
                );
              }
              if (state is BranchChoiceSuccessfulState) {
                if (state.list.isEmpty) {
                  return Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            'assets/images/ic-business-introduction.png',
                            width: width,
                          ),
                        ),
                      ),
                      // const Padding(padding: EdgeInsets.only(top: 10)),
                      Center(
                        child: SizedBox(
                          width: width * 0.7,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Bạn không thuộc danh sách quản trị viên trong bất kỳ doanh nghiệp nào. Để liên kết TK ngân hàng doanh nghiệp, hãy ',
                                ),
                                TextSpan(
                                  text: 'tạo một tổ chức doanh nghiệp mới.',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: DefaultTheme.GREEN,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, Routes.ADD_BUSINESS_VIEW);
                                    },
                                ),
                                // const TextSpan(
                                //   text:
                                //       ' để tiếp tục thực hiện liên kết TK ngân hàng doanh nghiệp.',
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return _buildBusinessBranchItem(
                        context: context,
                        dto: state.list[index],
                      );
                    },
                  );
                }
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/ic-business-introduction.png',
                        width: width,
                      ),
                    ),
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                  Center(
                    child: SizedBox(
                      width: width,
                      child: const Text('Vui lòng kiểm tra lại kết nối mạng'),
                    ),
                  ),
                ],
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildBusinessBranchItem(
      {required BuildContext context, required BusinessBranchChoiceDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          SizedBox(
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: width * 9 / 16,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                    image: (dto.coverImage.isNotEmpty)
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: ImageUtils.instance
                                .getImageNetWork(dto.coverImage),
                          )
                        : null,
                  ),
                ),
                Container(
                  width: width,
                  height: width * 9 / 16,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DefaultTheme.TRANSPARENT,
                        Theme.of(context).cardColor.withOpacity(0.4),
                        Theme.of(context).cardColor,
                        Theme.of(context).cardColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  child: SizedBox(
                    width: width - 50,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (dto.image.isNotEmpty)
                                  ? ImageUtils.instance
                                      .getImageNetWork(dto.image)
                                  : Image.asset(
                                      'assets/images/ic-avatar-business.png',
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ).image,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Expanded(
                          child: Text(
                            dto.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dto.branchs.length,
              itemBuilder: (context, index) {
                return BoxLayout(
                  width: width,
                  bgColor: Theme.of(context).canvasColor,
                  borderRadius: 10,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dto.branchs[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              dto.branchs[index].address,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          BranchChoiceInsertDTO insertDTO =
                              BranchChoiceInsertDTO(
                            image: dto.image,
                            coverImage: dto.coverImage,
                            companyName: dto.name,
                            branchName: dto.branchs[index].name,
                            branchAddress: dto.branchs[index].address,
                            branchId: dto.branchs[index].branchId,
                          );
                          Provider.of<AddBankProvider>(context, listen: false)
                              .updateBranchChoice(insertDTO);
                          Provider.of<AddBankProvider>(context, listen: false)
                              .updateType(1);
                          Navigator.pop(context, true);
                        },
                        child: const BoxLayout(
                          width: 80,
                          alignment: Alignment.center,
                          child: Text(
                            'Chọn',
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
