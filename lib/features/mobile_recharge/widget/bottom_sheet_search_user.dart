import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/models/contact_dto.dart';

import '../../contact/events/contact_event.dart';
import '../../contact/states/contact_state.dart';

class BottomSheetSearchUser extends StatelessWidget {
  final Function(ContactDTO) chooseContact;
  const BottomSheetSearchUser({Key? key, required this.chooseContact})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    late ContactBloc _bloc = BlocProvider.of(context);
    _bloc.add(ContactEventGetListRecharge());
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            const SizedBox(
              width: 32,
            ),
            Text(
              'Nạp tiền điện thoại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                size: 18,
              ),
            ),
          ],
        ),
        TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          fillColor: AppColor.GREY_BUTTON,
          // controller: searchController,
          hintText: 'Tìm kiếm số điện thoại',
          inputType: TextInputType.number,
          prefixIcon: const Icon(Icons.search),
          keyboardAction: TextInputAction.done,
          onChange: (value) {
            if (value.length >= 5) {
              _bloc.add(SearchUser(value));
            } else if (value.isEmpty) {
              _bloc.add(ContactEventGetListRecharge());
            } else {
              List<ContactDTO> list = [];
              Provider.of<ContactProvider>(context, listen: false)
                  .updateList(list);
            }
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
            child: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state.type == ContactType.GET_LIST_RECHARGE) {
              if (state.listContactDTO.isNotEmpty) {
                Provider.of<ContactProvider>(context, listen: false)
                    .updateList(state.listContactDTO);
              }
            }

            if (state.type == ContactType.SEARCH_USER) {
              Provider.of<ContactProvider>(context, listen: false)
                  .updateList(state.listContactDTO);
            }
          },
          builder: (context, state) {
            return Consumer<ContactProvider>(
                builder: (context, provider, child) {
              if (provider.listSearch.isEmpty) {
                return const SizedBox.shrink();
              }
              return ListView.separated(
                itemCount: provider.listSearch.length,
                separatorBuilder: (context, index) {
                  if (index == provider.listSearch.length - 1) {
                    return const SizedBox.shrink();
                  }
                  String firstLetterA =
                      (provider.listSearch[index].nickname)[0];
                  String firstLetterB =
                      (provider.listSearch[index + 1].nickname)[0];
                  if (firstLetterA != firstLetterB) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        firstLetterB,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text((provider.listSearch[index].nickname)[0],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        _buildItemSave(context,
                            dto: provider.listSearch[index]),
                      ],
                    );
                  }
                  return _buildItemSave(context,
                      dto: provider.listSearch[index]);
                },
              );
            });
          },
        ))
      ],
    );
  }

  Widget _buildItemSave(BuildContext context, {required ContactDTO? dto}) {
    return GestureDetector(
      onTap: () async {
        chooseContact(dto!);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.WHITE,
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                image: const DecorationImage(
                    image: AssetImage('assets/images/ic-avatar.png'),
                    fit: BoxFit.contain),
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
                      fontWeight: FontWeight.w600,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    dto?.phoneNo ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
