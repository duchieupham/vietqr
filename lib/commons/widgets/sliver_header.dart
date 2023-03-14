import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';

class SliverHeader extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final String heroId;
  final String coverImgId;
  final String imgId;
  final String businessName;

  const SliverHeader({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    required this.heroId,
    required this.coverImgId,
    required this.imgId,
    required this.businessName,
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
            _buildTitle(context, animation),
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

  Widget _buildTitle(BuildContext context, Animation<double> animation) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
          .evaluate(animation),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: Tween<double>(begin: 0, end: 30).evaluate(animation),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: Tween<double>(begin: 60, end: 80).evaluate(animation),
            height: Tween<double>(begin: 60, end: 80).evaluate(animation),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Tween<double>(begin: 60, end: 80).evaluate(animation),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (imgId.isNotEmpty)
                    ? ImageUtils.instance.getImageNetWork(imgId)
                    : Image.asset(
                        'assets/images/ic-avatar-business.png',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ).image,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Container(
            width: Tween<double>(begin: width - 110, end: width - 130)
                .evaluate(animation),
            alignment: AlignmentTween(
                    begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
                .evaluate(animation),
            child: Text(
              businessName,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                color: DefaultTheme.WHITE,
                fontSize: Tween<double>(begin: 15, end: 20).evaluate(animation),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildImage(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Hero(
      tag: heroId,
      child: Container(
        width: width,
        height: (width - 20) / 1.2,
        decoration: BoxDecoration(
          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
          image: (coverImgId.isNotEmpty)
              ? DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(coverImgId),
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
    );
  }
}
