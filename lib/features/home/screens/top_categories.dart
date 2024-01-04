import 'dart:math';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/features/home/widgets/carousel_image.dart';
import 'package:ecommerce_major_project/features/home/widgets/myGridWidgetItems.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/utils.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories>
    with TickerProviderStateMixin {
  // tabbar variables
  int activeTabIndex = 0;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );
  bool isProductLoading = true;

  //products
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailServices productDetailServices = ProductDetailServices();

  @override
  void initState() {
    fetchCategory();
    fetchAdvertisement();
    super.initState();
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    tabProvider.setTab(1);
    context.go('/category/$category');
  }

  fetchAdvertisement() async {
    await homeServices.fetchAdvertisement(
      context: context,
    );
  }

  fetchCategory() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await homeServices.fetchCategory(
      context: context,
    );

    fetchCategoryProducts(categoryProvider.category[activeTabIndex].name);
  }

  fetchCategoryProducts(String categoryName) async {
    setState(() {
      isProductLoading = true;
    });
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: categoryName,
    );
    setState(() {
      isProductLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    mq = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(top: mq.height * .01),
            child: const CarouselImage(),
          )),
        ];
      },
      body: DefaultTabController(
        length: categoryProvider.tab,
        child: Column(
          children: [
            SizedBox(
              height: mq.height * .07,
              width: double.infinity,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    activeTabIndex = index;
                  });
                  fetchCategoryProducts(
                      categoryProvider.category[activeTabIndex].name);
                },
                physics: const BouncingScrollPhysics(),
                splashBorderRadius: BorderRadius.circular(15),
                indicatorWeight: 1,
                indicatorColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                isScrollable: true,
                tabs: [
                  for (int index = 0; index < categoryProvider.tab; index++)
                    Tab(
                      child: Card(
                        color: activeTabIndex == index
                            ? Colors.black87
                            : Colors.grey.shade50,
                        elevation: .8,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: GlobalVariables.primaryGreyTextColor,
                                width: 0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.network(
                                  categoryProvider.category[index].icon,
                                  height: 30,
                                  // ignore: deprecated_member_use
                                  color: activeTabIndex == index
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                SizedBox(width: mq.width * .015),
                                Text(
                                  categoryProvider.category[index].name,
                                  style: TextStyle(
                                    color: activeTabIndex == index
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                //controller: _tabController,
                children: [
                  for (int i = 0; i < categoryProvider.tab; i++)
                    Container(
                      height: mq.height * 0.3,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade700, width: 0.4),
                        ),
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: mq.height * .008,
                              ).copyWith(right: mq.height * .015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateToCategoryPage(
                                          context,
                                          categoryProvider
                                              .category[activeTabIndex].name);
                                    },
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              sliver: isProductLoading
                                  ? const SliverToBoxAdapter(
                                      child: ColorLoader2(),
                                    )
                                  : productList!.isEmpty
                                      ? const SliverToBoxAdapter(
                                          child: Center(
                                            child: Text("No item to fetch"),
                                          ),
                                        )
                                      : SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: kIsWeb ? 4 : 2,
                                            childAspectRatio:
                                                kIsWeb ? 1.1 : 0.69,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 0,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                              childCount:
                                                  min(productList!.length, 8),
                                              (context, index) {
                                            Product product =
                                                productList![index];

                                            final user = context
                                                .watch<UserProvider>()
                                                .user;
                                            List<dynamic> wishList =
                                                user.wishList != null
                                                    ? user.wishList!
                                                    : [];
                                            bool isProductWishListed = false;

                                            for (int i = 0;
                                                i < wishList.length;
                                                i++) {
                                              // final productWishList = wishList[i];
                                              // final productFromJson =
                                              //     Product.fromJson(
                                              //         productWishList['product']);
                                              // final productId = productFromJson.id;

                                              if (wishList[i]['product'] ==
                                                  product.id) {
                                                isProductWishListed = true;
                                                break;
                                              }
                                            }

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onTap: () {
                                                  // Get the current location
                                                  String currentPath =
                                                      getCurrentPathWithoutQuery(
                                                          context);
                                                  // Build the new path
                                                  String newPath =
                                                      '${currentPath}product/${product.id}';
                                                  context.go(newPath);
                                                },
                                                child: GridWidgetItems(
                                                    product:
                                                        productList![index],
                                                    isProductWishListed:
                                                        isProductWishListed),
                                              ),
                                            );
                                          })))
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculatePercentageDiscount(num originalPrice, num discountedPrice) {
    if (originalPrice <= 0 || discountedPrice <= 0) {
      return 0;
    }
    double discount = (originalPrice - discountedPrice) / originalPrice * 100.0;

    return discount.toInt();
  }
}
