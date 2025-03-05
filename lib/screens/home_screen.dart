import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/tabs/about.dart';
import 'package:jnu_bus_routes/tabs/bus.dart';
import 'package:jnu_bus_routes/tabs/home.dart';
import 'package:jnu_bus_routes/tabs/place.dart';
import 'package:jnu_bus_routes/tabs/setting.dart';
import 'package:jnu_bus_routes/widgets/tab_bar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';


class HomeScreen extends StatefulWidget{
  static  String userName = "";
   HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
   return _HomeScreenState();
  }
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
  return    ShadApp.material(
    debugShowCheckedModeBanner: false,
    home: DefaultTabController(length: 5,
        child: Scaffold(
          body:  CustomScrollView(
            slivers: [
               const SliverAppBar(
                backgroundColor: Colors.redAccent,
                floating: true,
                title: HomeScreenTabBar()
              ),
              SliverFillRemaining(
                child: TabBarView(children: [
                   HomeTab(userName: HomeScreen.userName,),
                   const PlaceTab(),
                   const BusTab(),
                   const SettingTab(),
                  const AboutTab()

                ]
                ),
              ),

            ],
          ),
        ),
    )
  );
  }
}