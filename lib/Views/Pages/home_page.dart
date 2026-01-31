import 'package:ecommerce/Utils/app_colors.dart';
import 'package:ecommerce/View_Models/home_cubit/home_cubit.dart';
import 'package:ecommerce/Views/Widgets/category_tabView.dart';
import 'package:ecommerce/Views/Widgets/home_tabView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget iconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..getHomeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    foregroundImage: AssetImage(
                      'assets/images/profileIcon.jpg',
                    ),
                    radius: 28,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Ahmed',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF005A32),
                        ),
                      ),
                      Text(
                        'What Will You Buy Today!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF41AB5D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  iconNavbar('assets/icons/search.png'),
                  SizedBox(width: 10),
                  iconNavbar('assets/icons/notification.png'),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Column(
            children: [
              TabBar(
                dividerColor: Colors.white,
                labelColor: AppColors.primarycolor,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                indicatorColor: AppColors.primarycolor,
                unselectedLabelColor: AppColors.primarycolor.withOpacity(0.15),
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Category'),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [HomeTabview(), CategoryTabview()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
