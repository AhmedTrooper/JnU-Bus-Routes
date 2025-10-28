import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/tabs/bus.dart';
import 'package:jnu_bus_routes/tabs/home.dart';
import 'package:jnu_bus_routes/tabs/place.dart';
import 'package:jnu_bus_routes/tabs/setting.dart';
import 'package:jnu_bus_routes/widgets/tab_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 10,
              backgroundColor: Theme.of(context).brightness != Brightness.dark
                  ? Colors.white
                  : Colors.black12,
            ),
            const SliverFillRemaining(
              child: TabBarView(
                children: [
                  HomeTab(),
                  PlaceTab(),
                  BusTab(),
                  SettingTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.black12,
          padding: const EdgeInsets.all(0.0),
          child: const HomeScreenTabBar(),
        ),
      ),
    );
  }
}
