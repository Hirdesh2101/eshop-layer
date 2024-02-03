import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/screens/top_categories.dart';
import 'package:provider/provider.dart';

import '../../../providers/tab_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TabProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AdsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
        ],
        child: Scaffold(
          appBar: GlobalVariables.getAppBar(
            context: context,
            wantBackNavigation: false,
            // onClickSearchNavigateTo: const MySearchScreen()
          ),
          body: const TopCategories(),
        ),
      ),
    );
  }
}
