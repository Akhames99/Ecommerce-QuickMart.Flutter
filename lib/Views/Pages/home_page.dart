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
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 69, 15, 5),
      child: BlocProvider(
        create: (context) {
          final cubit = HomeCubit();
          cubit.getHomeData();
          return cubit;
        },
        child: Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: AssetImage('assets/images/salah.jpg'),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Salah',
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
                      IconNavbar('assets/icons/search.png'),
                      SizedBox(width: 10),
                      IconNavbar('assets/icons/notification.png'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              TabBar(
                dividerColor: Colors.white,
                labelColor: AppColors.primarycolor,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                indicatorColor: AppColors.primarycolor,
                unselectedLabelColor: AppColors.primarycolor.withOpacity(0.15),
                tabs: [
                  Tab(text: 'Home'),
                  Tab(text: 'Category'),
                ],
                controller: _tabController,
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [HomeTabview(), CategoryTabview()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
