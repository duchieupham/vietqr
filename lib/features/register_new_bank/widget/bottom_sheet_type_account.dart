import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/register_new_bank/provider/register_new_bank_provider.dart';

class BottomSheetTypeAccount extends StatelessWidget {
  const BottomSheetTypeAccount({
    super.key,
    required this.list,
    required this.onChange,
    required this.initData,
  });

  final List<AccountType> list;
  final AccountType initData;
  final Function(AccountType) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 10,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, bottom: 20),
            child: Row(
              children: [
                const SizedBox(
                  width: 32,
                ),
                const Expanded(
                    child: Center(
                        child: Text(
                  'Loại tài khoản',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ))),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onChange(list[index]);
                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(
                            bottom: 12, left: 20, top: 12),
                        child: Row(
                          children: [
                            Expanded(child: Text(list[index].tile)),
                            if (initData.type == list[index].type)
                              const Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.check,
                                  size: 18,
                                  color: AppColor.BLUE_TEXT,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColor.GREY_TEXT.withOpacity(0.5),
                      height: 0.5,
                    );
                  },
                  itemCount: list.length)),
        ],
      ),
    );
  }
}
