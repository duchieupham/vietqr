import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class CreateQrScreen extends StatelessWidget {
  const CreateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateQRBloc>(
      create: (_) => CreateQRBloc(context),
      child: _CreateQRScreen(),
    );
  }
}

class _CreateQRScreen extends StatefulWidget {
  @override
  State<_CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<_CreateQRScreen> {
  final List<String> listSuggest = [
    'Thanh toán bữa ăn trưa',
    'Chuyển khoản',
  ];

  final moneyController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  initData(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    BankTypeDTO? bankTypeDTO = args['bankTypeDTO'];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    BankAccountDTO? model = args['bankInfo'];
    return Scaffold(
      appBar: const MAppBar(title: 'Tạo QR'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: AppColor.WHITE,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(model?.imgId ?? '')),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${model?.bankCode ?? ''} - ${model?.bankName ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.BLACK),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model?.bankAccount ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.BLACK),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model?.userBankName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.BLACK),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              fillColor: AppColor.WHITE,
              controller: moneyController,
              textFieldType: TextfieldType.LABEL,
              title: 'Số tiền',
              hintText: 'Nhập số tiền thanh toán',
              inputType: TextInputType.number,
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
            ),
            const SizedBox(height: 30),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              fillColor: AppColor.WHITE,
              controller: contentController,
              textFieldType: TextfieldType.LABEL,
              title: 'Nội dung',
              hintText: 'Nhập nội dung thanh toán',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Gợi ý: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  children: List.generate(listSuggest.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        contentController.value = contentController.value
                            .copyWith(text: listSuggest[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColor.BLUE_TEXT),
                          color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        ),
                        child: Text(
                          listSuggest[index],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.note),
                    SizedBox(width: 8),
                    Text(
                      'Định kèm hoá đơn',
                      style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: MButtonWidget(
        title: 'Tạo QR',
        isEnable: true,
        onTap: () {},
      ),
    );
  }
}
