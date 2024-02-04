import 'package:ecommerce_major_project/app_service.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:ecommerce_major_project/go_router.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/screens/top_categories.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/tab_provider.dart';
import '../providers/search_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppService appService;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    appService = AppService(sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: MultiProvider(providers: [
          ChangeNotifierProvider<AppService>(create: (_) => appService),
          Provider<AppRouter>(create: (_) => AppRouter(appService)),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => FilterProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TabProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AdsProvider(),
          ),
        ], child: TopCategories()),
      ),
    );
  }
}
