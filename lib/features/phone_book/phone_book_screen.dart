import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_bloc.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_provider.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/phone_book_dto.dart';

class PhoneBookScreen extends StatelessWidget {
  const PhoneBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneBookBloc>(
      create: (context) => PhoneBookBloc(context),
      child: ChangeNotifierProvider<PhoneBookProvider>(
        create: (context) => PhoneBookProvider(),
        child: _PhoneBookState(),
      ),
    );
  }
}

class _PhoneBookState extends StatefulWidget {
  @override
  State<_PhoneBookState> createState() => _PhoneBookStateState();
}

class _PhoneBookStateState extends State<_PhoneBookState> {
  late PhoneBookBloc _bloc;

  List<DataModel> listTab = [
    DataModel(
      title: 'Đã lưu',
      index: 0,
    ),
    DataModel(
      title: 'Gợi ý',
      index: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(PhoneBookEventGetList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Danh bạ',
        actions: [
          GestureDetector(
            child: Image.asset('assets/images/ic-tb-qr.png'),
          )
        ],
      ),
      body: BlocConsumer<PhoneBookBloc, PhoneBookState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            print('nfgsjdngd');
            Navigator.pop(context);
          }

          if (state.type == PhoneBookType.GET_LIST) {}
        },
        builder: (context, state) {
          return Consumer<PhoneBookProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(listTab.length, (index) {
                        DataModel model = listTab.elementAt(index);
                        return _buildTab(
                          onTap: () {
                            provider.updateTab(index);
                          },
                          text: model.title,
                          isSuggest: index == 1,
                          isSelect: provider.tab == model.index,
                        );
                      }).toList(),
                    ),
                    if (provider.tab == 0) ...[
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        fillColor: AppColor.WHITE,
                        // controller: provider.contentController,
                        hintText: 'Tìm kiếm danh bạ',
                        inputType: TextInputType.text,
                        prefixIcon: const Icon(Icons.search),
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {},
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: List.generate(state.listPhoneBookDTO.length,
                            (index) {
                          PhoneBookDTO dto = state.listPhoneBookDTO[index];
                          return _buildItemSave(dto: dto);
                        }).toList(),
                      ),
                    ] else ...[
                      Column(
                        children: List.generate(state.listPhoneBookDTO.length,
                            (index) {
                          PhoneBookDTO dto = state.listPhoneBookDTO[index];
                          return _buildItemSuggest(dto: dto);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItemSave({required PhoneBookDTO? dto}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(dto?.imgId ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dto?.nickname ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.BLACK,
                    height: 1.4,
                  ),
                ),
                Text(
                  dto?.description ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.BLUE_TEXT,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemSuggest({required PhoneBookDTO? dto}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                  image: DecorationImage(
                    image:
                        ImageUtils.instance.getImageNetWork(dto?.imgId ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dto?.nickname ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLACK,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      dto?.description ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLUE_TEXT,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              MButtonWidget(title: 'Lưu'),
              MButtonWidget(title: 'Bỏ qua'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTab({
    required String text,
    GestureTapCallback? onTap,
    bool isSuggest = false,
    bool isSelect = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelect ? AppColor.BLUE_TEXT : AppColor.TRANSPARENT,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            if (isSuggest)
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 4),
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  '1',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLUE_TEXT),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DataModel {
  final String title;
  final int index;

  DataModel({required this.title, required this.index});
}
