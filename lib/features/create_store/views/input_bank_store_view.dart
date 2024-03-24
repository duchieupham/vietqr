import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/create_store/create_store.dart';
import 'package:vierqr/models/bank_account_terminal.dart';

class InputBankStoreView extends StatefulWidget {
  final Function(BankAccountTerminal) callBack;
  final String nameStore;

  const InputBankStoreView(
      {super.key, required this.callBack, required this.nameStore});

  @override
  State<InputBankStoreView> createState() => _InputBankStoreViewState();
}

class _InputBankStoreViewState extends State<InputBankStoreView> {
  String codeStore = '';
  late CreateStoreBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateStoreBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetListBankAccountLink(''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<CreateStoreBloc, CreateStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: _hideKeyBoard,
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderStoreWidget(
                    nameStore: widget.nameStore,
                    title: 'Chọn tài khoản nhận tiền\ncho cửa hàng của bạn',
                    desTitle:
                        'Danh sách dưới đây là các tài khoản ngân hàng đã được liên kết của bạn.',
                  ),
                  const SizedBox(height: 16),
                  if (state.status == BlocStatus.LOADING_PAGE)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    if (state.banks.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.banks.length,
                          itemBuilder: (context, index) {
                            BankAccountTerminal dto = state.banks[index];
                            return _buildItemBank(dto);
                          },
                        ),
                      )
                    else if (state.isEmpty) ...[
                      Text(
                        'Có vẻ như bạn chưa\nliên kết tài khoản ngân hàng!',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFF3DF),
                              Color(0xFFFFE1C9),
                            ],
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Liên kết tài khoản ngân hàng',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Liên kết tài khoản ngân hàng để nhận và quản lý các thông tin giao dịch của bạn.',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/images/ic-add-bank.png',
                                height: 30,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemBank(BankAccountTerminal dto) {
    return GestureDetector(
      onTap: () => widget.callBack.call(dto),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.grey979797, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 40,
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.grey979797),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.bankAccount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    dto.userBankName.toUpperCase().trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            Image.asset('assets/images/ic-navigate-next-blue.png', width: 44)
          ],
        ),
      ),
    );
  }

  void _onContinue(BankAccountTerminal dto) async {}

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
