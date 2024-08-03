import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/my_vietqr/bloc/vietqr_store_bloc.dart';
import 'package:vierqr/features/my_vietqr/event/vietqr_store_event.dart';
import 'package:vierqr/features/my_vietqr/state/vietqr_store_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class SelectStoreWidget extends StatefulWidget {
  final String bankId;
  const SelectStoreWidget({super.key, required this.bankId});

  @override
  State<SelectStoreWidget> createState() => _SelectStoreWidgetState();
}

class _SelectStoreWidgetState extends State<SelectStoreWidget> {
  final VietQRStoreBloc _bloc = getIt.get<VietQRStoreBloc>();
  final ScrollController _controller = ScrollController();

  List<VietQRStoreDTO> list = [];
  MetaDataDTO? metadata;

  @override
  void initState() {
    super.initState();
    _bloc.add(GetListStore(bankId: widget.bankId));
    _controller.addListener(
      () {
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          if (metadata != null) {
            int total = (metadata!.total! / 5).ceil();
            if (total > metadata!.page!) {
              _bloc.add(GetListStore(
                  bankId: widget.bankId,
                  isLoadMore: true,
                  page: metadata!.page! + 1));
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VietQRStoreBloc, VietQRStoreState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS &&
            state.request == VietQrStore.GET_LIST) {
          list = [...state.listStore];
          metadata = state.metadata;
        }
        if (state.status == BlocStatus.SUCCESS &&
            state.request == VietQrStore.LOADMORE) {
          list = [...list, ...state.listStore];
          metadata = state.metadata;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Chọn cửa hàng',
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                controller: _controller,
                padding: EdgeInsets.zero,
                children: [
                  ...List.generate(
                    state.listStore.length,
                    (index) {
                      VietQRStoreDTO dto = state.listStore[index];
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: VietQRTheme.gradientColor.lilyLinear,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dto.merchantName,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            const MySeparator(color: AppColor.GREY_DADADA),
                            ...List.generate(
                              dto.terminals.length,
                              (index) {
                                TerminalDTO terminalDTO = dto.terminals[index];
                                return InkWell(
                                  onTap: () {
                                    _bloc.add(
                                        SetTerminalEvent(dto: terminalDTO));
                                    Navigator.of(context).pop();
                                  },
                                  child: _buildItem(dto.terminals[index]),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  if (state.status == BlocStatus.LOAD_MORE)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(TerminalDTO termial) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                termial.terminalAddress,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              Text(
                termial.terminalCode,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColor.GREY_TEXT),
              ),
            ],
          ),
          const XImage(
            imagePath: 'assets/images/ic-next-black.png',
            width: 30,
            height: 30,
            color: AppColor.BLACK,
          ),
        ],
      ),
    );
  }
}
