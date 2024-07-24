import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';

class BuildLoading extends StatelessWidget {
  const BuildLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const ShimmerBlock(
          width: 70,
          height: 12,
          borderRadius: 10,
        ),
        const SizedBox(height: 10),
        ...List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ShimmerBlock(
                  width: 30,
                  height: 30,
                  borderRadius: 10,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(
                        width: 100,
                        height: 12,
                        borderRadius: 10,
                      ),
                      SizedBox(height: 2),
                      ShimmerBlock(
                        height: 12,
                        width: 170,
                        borderRadius: 10,
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerBlock(
                      width: 50,
                      height: 10,
                      borderRadius: 10,
                    ),
                    SizedBox(height: 2),
                    ShimmerBlock(
                      width: 70,
                      height: 10,
                      borderRadius: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
