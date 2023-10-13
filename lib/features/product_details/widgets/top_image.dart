import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class TopImage extends StatefulWidget {
  const TopImage({super.key, required this.product,required this.height});
  final Product product;
  final double height;

  @override
  State<TopImage> createState() => _TopImageState();
}

class _TopImageState extends State<TopImage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Column(
          children: [
            SizedBox(
                        height: mq.height * .52,
                        child: PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (value) {
                              setState(() {
                                currentIndex = value;
                              });
                            },
                            itemCount: widget.product.images.length,
                            // physics: PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              // print("............index = $index");

                              return Builder(
                                builder: (context) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        barrierColor:
                                            Colors.black.withOpacity(0.7),
                                        barrierDismissible: true,
                                        pageBuilder:
                                            (BuildContext context, _, __) {
                                          return InteractiveViewer(
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(10),
                                              child: SafeArea(
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Image.network(
                                                          widget.product
                                                              .images[index],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 8, 0, 0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Icon(
                                                          Icons.close_rounded,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: mq.height * .05),
                                    child: Image.network(
                                        widget.product.images[index],
                                        fit: BoxFit.contain,
                                        height: mq.width * .3),
                                  ),
                                ),
                              );
                            }),
                      ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.images.length,
                (index) => buildDot(index: index),
              ),
            ),
          ],
        ),
        Positioned(
          top: mq.height * 0.02,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  HomeServices()
                      .addToWishList(context: context, product: widget.product);
                  showSnackBar(
                      context: context,
                      text: "Added to WishList",
                      onTapFunction: () {
                        Navigator.of(context).push(GlobalVariables.createRoute(
                            const WishListScreen()));
                      },
                      actionLabel: "View");
                },
                child: const Icon(
                  Icons.favorite_border_rounded,
                ),
              ),
              IconButton(
                onPressed: () {
                  showSnackBar(
                      context: context,
                      text:
                          "Share feature yet to be implemented using deep links");
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        )
      ],
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xFFFF7643)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
