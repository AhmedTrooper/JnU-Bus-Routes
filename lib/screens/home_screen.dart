// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/tabs/about_tab.dart';
import 'package:jnu_bus_routes/tabs/bus_tab.dart';
import 'package:jnu_bus_routes/tabs/home_tab.dart';
import 'package:jnu_bus_routes/tabs/setting_tab.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../utils/shared_preferences_helper.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late TabController _tabController;



  @override
  Widget build(BuildContext context) {

    return DefaultTabController(length: 4, child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const TabBar(tabs: [
          Tab(
            child: Icon(LucideIcons.house,color: Colors.white,size: 25,),
          ),
          Tab(
            child: Icon(LucideIcons.bus,color: Colors.white,size: 25,),
          ),
          Tab(
            child: Icon(LucideIcons.settings,color: Colors.white,size: 25,),
          ),
          Tab(
            child: Icon(LucideIcons.info,color: Colors.white,size: 25,),
          )
        ],
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
        ),
      ),
      body: const  TabBarView(children: [
         HomeTab(),
        BusTab(),
        SettingTab(),
        AboutTab(),
      ]),
    )
    );
  }
}