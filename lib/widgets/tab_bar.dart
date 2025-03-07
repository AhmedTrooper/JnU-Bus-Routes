import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeScreenTabBar extends StatelessWidget {
  const HomeScreenTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [
        Tab(
          child: Icon(
            LucideIcons.house,
            color: Colors.white,
            size: 25,
          ),
        ),
        Tab(
          child: Icon(
            LucideIcons.map,
            color: Colors.white,
            size: 25,
          ),
        ),
        Tab(
          child: Icon(
            LucideIcons.bus,
            color: Colors.white,
            size: 25,
          ),
        ),
        Tab(
          child: Icon(
            LucideIcons.settings,
            color: Colors.white,
            size: 25,
          ),
        ),
        Tab(
          child: Icon(
            LucideIcons.info,
            color: Colors.white,
            size: 25,
          ),
        )
      ],
      indicatorColor: Colors.white,
      dividerColor: Colors.transparent,
    );
  }
}
