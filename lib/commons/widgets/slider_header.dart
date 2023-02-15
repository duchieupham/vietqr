import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/logo_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class SliverHeader extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final String title;
  final String image;
  final BankAccountDTO bankAccountDTO;
  final String accountBalance;

  const SliverHeader({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    required this.title,
    required this.image,
    required this.bankAccountDTO,
    required this.accountBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double expandRatio = _calculateExpandRatio(constraints);
        final AlwaysStoppedAnimation<double> animation =
            AlwaysStoppedAnimation(expandRatio);
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            _buildImage(context),
            _buildGradient(animation),
            _buildTitle(animation, context),
            _buildLogo(animation, context),
            _buildBackFunction(context),
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.4) expandRatio = 0.0;
    return expandRatio;
  }

  Container _buildGradient(Animation<double> animation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DefaultTheme.BLACK.withOpacity(0.2),
            DefaultTheme.BLACK.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildBackFunction(BuildContext context) {
    return Positioned(
      top: 65,
      left: 20,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            // color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: DefaultTheme.WHITE,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Animation<double> animation, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Tween<double>(begin: 32.5, end: 50).evaluate(animation),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              width: Tween<double>(begin: 30, end: 120).evaluate(animation),
              height: Tween<double>(begin: 30, end: 60).evaluate(animation),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Tween<double>(begin: 30, end: 10).evaluate(animation),
                ),
                color: DefaultTheme.WHITE,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    LogoUtils.instance
                        .getAssetImageBank(bankAccountDTO.bankCode),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(Animation<double> animation, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
          .evaluate(animation),
      child: Container(
        alignment: AlignmentTween(
          begin: Alignment.bottomCenter,
          end: Alignment.bottomLeft,
        ).evaluate(animation),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: AlignmentTween(
                      begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
                  .evaluate(animation),
              child: Text(
                title,
                style: TextStyle(
                    fontSize:
                        Tween<double>(begin: 0, end: 20).evaluate(animation),
                    fontWeight: FontWeight.w500,
                    color: DefaultTheme.WHITE),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              width: width,
              alignment: AlignmentTween(
                      begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
                  .evaluate(animation),
              child: Container(
                width: Tween<double>(begin: width * 0.7, end: width * 0.8)
                    .evaluate(animation),
                height: Tween<double>(begin: 75, end: 80).evaluate(animation),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: AlignmentTween(
                        begin: Alignment.bottomCenter,
                        end: Alignment.bottomLeft)
                    .evaluate(animation),
                padding: EdgeInsets.only(
                  left: Tween<double>(begin: 0, end: 20).evaluate(animation),
                  top: Tween<double>(begin: 15, end: 0).evaluate(animation),
                  bottom: Tween<double>(begin: 10, end: 0).evaluate(animation),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentTween(
                              begin: Alignment.center,
                              end: Alignment.centerLeft)
                          .evaluate(animation),
                      child: Text(
                        bankAccountDTO.bankName.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Tween<double>(begin: 13, end: 15)
                              .evaluate(animation),
                          color: DefaultTheme.GREY_TEXT,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentTween(
                              begin: Alignment.center,
                              end: Alignment.centerLeft)
                          .evaluate(animation),
                      child: Text(
                        '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Tween<double>(begin: 13, end: 15)
                              .evaluate(animation),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentTween(
                              begin: Alignment.center,
                              end: Alignment.centerLeft)
                          .evaluate(animation),
                      child: Text(
                        'Số dư: $accountBalance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Tween<double>(begin: 13, end: 15)
                              .evaluate(animation),
                          color: DefaultTheme.GREEN,
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
    );
  }

  _buildImage(BuildContext context) {
    return Hero(
      tag: title,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.width - 20) / 1.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
