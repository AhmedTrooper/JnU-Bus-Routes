import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeScreenTabBar extends ConsumerWidget {
  const HomeScreenTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBar(
      labelColor: Theme.of(context).brightness != Brightness.dark
          ? Colors.black
          : Colors.white,
      unselectedLabelColor: const Color(0xff767676),
      indicator: BoxDecoration(
          color: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.transparent),
      tabs: [
        Tab(
          icon: const Icon(
            Icons.home,
            size: 20,
          ),
          child: Text(
            "Home",
            style: TextStyle(
                fontSize: 11.5,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
        Tab(
          icon: const Icon(
            Icons.map,
            size: 20,
          ),
          child: Text(
            "Place",
            style: TextStyle(
                fontSize: 11.5,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
        Tab(
          icon: const Icon(
            LucideIcons.bus,
            size: 20,
          ),
          child: Text(
            "Bus",
            style: TextStyle(
                fontSize: 11.5,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
        Tab(
          icon: const Icon(
            LucideIcons.settings2,
            size: 20,
          ),
          child: Text(
            "Prefs",
            style: TextStyle(
                fontSize: 11.5,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
      indicatorColor: Theme.of(context).brightness != Brightness.dark
          ? Colors.black
          : Colors.white,
      dividerColor: Colors.transparent,
    );
  }
}
