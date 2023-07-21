import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_bloc.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_provider.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

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
        listener: (context, state) {},
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
                        return _buildItem(
                          onTap: () {
                            provider.updateTab(index);
                          },
                          text: model.title,
                          isSuggest: index == 1,
                          isSelect: provider.tab == model.index,
                        );
                      }).toList(),
                    ),
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItem({
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
