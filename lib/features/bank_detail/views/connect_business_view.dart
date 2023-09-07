import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/business_branch_dto.dart';

class ConnectBusinessView extends StatefulWidget {
  final List<BusinessAvailDTO> list;
  final Function(String, String) onConnect;

  const ConnectBusinessView(
      {super.key, required this.list, required this.onConnect});

  @override
  State<ConnectBusinessView> createState() => _ConnectBusinessViewState();
}

class _ConnectBusinessViewState extends State<ConnectBusinessView> {
  int step = 0;
  int selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight * 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(),
            const SizedBox(height: 30),
            _buildStep(select: step),
            Expanded(
              child: step == 0
                  ? _BuildStepFirst(
                      list: widget.list,
                      onNext: (index, select) {
                        setState(() {
                          step = index;
                          selected = select;
                        });
                      },
                    )
                  : _BuildStepSecond(
                      model: widget.list[selected],
                      onConnect: widget.onConnect,
                      onBack: (index) {
                        setState(() {
                          step = index;
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.clear),
          color: Colors.transparent,
        ),
        Expanded(
          child: Center(
            child: Text(
              'Kết nối doanh nghiệp',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear, size: 20),
        )
      ],
    );
  }
}

class _buildStep extends StatelessWidget {
  final int select;

  const _buildStep({this.select = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 70,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(1, select),
              Expanded(
                child: Container(
                  height: 2,
                  color: select > 0 ? AppColor.BLUE_TEXT : AppColor.grey979797,
                ),
              ),
              _buildItem(2, select),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'Chọn doanh nghiệp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: select >= 0 ? AppColor.BLACK : AppColor.GREY_TEXT),
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  'Chọn chi nhánh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: select >= 2 ? AppColor.BLACK : AppColor.GREY_TEXT),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildItem(int title, int select) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title == 2)
            Expanded(
              child: Container(
                height: 2,
                color: select >= 2 ? AppColor.BLUE_TEXT : AppColor.grey979797,
              ),
            )
          else
            const Expanded(child: SizedBox()),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: select >= title - 1
                    ? AppColor.BLUE_TEXT
                    : AppColor.GREY_EBEBEB,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: select >= title - 1
                        ? AppColor.TRANSPARENT
                        : AppColor.TRANSPARENT)),
            child: Text(
              '$title',
              style: TextStyle(
                color:
                    select >= (title - 1) ? AppColor.WHITE : AppColor.GREY_TEXT,
              ),
            ),
          ),
          if (title == 1)
            Expanded(
              child: Container(
                height: 2,
                color: select > 0 ? AppColor.BLUE_TEXT : AppColor.grey979797,
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class _BuildStepFirst extends StatelessWidget {
  final List<BusinessAvailDTO> list;
  final Function(int, int) onNext;

  const _BuildStepFirst({required this.list, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Danh sách doanh nghiệp khả dụng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                if (list.isNotEmpty)
                  ...List.generate(list.length, (index) {
                    BusinessAvailDTO model = list.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onNext(2, index);
                      },
                      child: _buildItem(model),
                    );
                  }).toList(),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Nếu bạn chưa có doanh nghiệp nào,\nhãy tạo doanh nghiệp mới',
                textAlign: TextAlign.center,
              ),
              MButtonWidget(
                title: 'Tạo doanh nghiệp mới',
                isEnable: true,
                margin: const EdgeInsets.symmetric(vertical: 20),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItem(BusinessAvailDTO model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.greyF0F0F0,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ic-tb-business-selected.png',
            width: 32,
            color: AppColor.BLACK,
          ),
          Expanded(
            child: Text(
              model.name ?? '',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Image.asset(
            'assets/images/ic-next-user.png',
            width: 32,
          ),
        ],
      ),
    );
  }
}

class _BuildStepSecond extends StatelessWidget {
  final Function(int) onBack;
  final BusinessAvailDTO model;
  final Function(String, String) onConnect;

  const _BuildStepSecond(
      {required this.onBack, required this.model, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Danh sách chi nhánh khả dụng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                if (model.branchs.isNotEmpty)
                  ...List.generate(model.branchs.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        onConnect(model.businessId ?? '',
                            model.branchs[index].branchId ?? '');
                      },
                      child: _buildItem(model.branchs[index]),
                    );
                  }).toList(),
              ],
            ),
          ),
          MButtonWidget(
            title: 'Trở về',
            isEnable: true,
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.25),
            colorEnableText: AppColor.BLUE_TEXT,
            margin: const EdgeInsets.symmetric(vertical: 20),
            onTap: () {
              onBack(0);
            },
          )
        ],
      ),
    );
  }

  Widget _buildItem(BranchModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.greyF0F0F0,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ic-tb-business-selected.png',
            width: 32,
            color: AppColor.BLACK,
          ),
          Expanded(
            child: Text(
              model.name ?? '',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Image.asset(
            'assets/images/ic-next-user.png',
            width: 32,
          ),
        ],
      ),
    );
  }
}
