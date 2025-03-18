import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _urlDeveloperOne = Uri.parse('https://github.com/AhmedTrooper');
final Uri _urlDeveloperTwo =
    Uri.parse('https://www.facebook.com/mehrabhosen.mahi');
final Uri _urlDeveloperThree =
    Uri.parse("https://www.facebook.com/asfi.sultan");

class AboutTab extends ConsumerStatefulWidget {
  const AboutTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AboutTabState();
  }
}

class _AboutTabState extends ConsumerState<AboutTab> {
  @override
  Widget build(BuildContext context) {
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            "Developers",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Theme.of(context).brightness != Brightness.dark
                    ? Colors.black
                    : Colors.white),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.white
                        : Colors.grey[800]!,
                    width: 1,
                  ),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black54
                                    : Colors.white70,
                            size: 30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Md. Ramjan Miah",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Me ? Learning.....",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _launchUrlOne,
                            icon: Icon(
                              LucideIcons.github,
                              size: 30,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: _launchUrlOne,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              foregroundColor: Color(stColor),
                            ),
                            child: const Text(
                              "AhmedTrooper",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.white
                      : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).brightness != Brightness.dark
                              ? Colors.black54
                              : Colors.white70,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Mehrab Hosen Mahi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Bus data collector......",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _launchUrlTwo,
                          icon: Icon(
                            LucideIcons.facebook,
                            size: 30,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black54
                                    : Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _launchUrlTwo,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Color(stColor),
                          ),
                          child: const Text(
                            "Mehrab Hosen Mahi",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.white
                      : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).brightness != Brightness.dark
                              ? Colors.black54
                              : Colors.white70,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "MT Asfi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "App collaborator, App's console/version manager......",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _launchUrlThree,
                          icon: Icon(
                            LucideIcons.facebook,
                            size: 30,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black54
                                    : Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _launchUrlThree,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Color(stColor),
                          ),
                          child: const Text(
                            "MT Asfi",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 80,
          ),
        ),
      ],
    );
  }
}

Future<void> _launchUrlOne() async {
  if (!await launchUrl(_urlDeveloperOne)) {
    throw Exception('Could not launch $_urlDeveloperOne');
  }
}

Future<void> _launchUrlTwo() async {
  if (!await launchUrl(_urlDeveloperTwo)) {
    throw Exception('Could not launch $_urlDeveloperTwo');
  }
}

Future<void> _launchUrlThree() async {
  if (!await launchUrl(_urlDeveloperThree)) {
    throw Exception('Could not launch $_urlDeveloperThree');
  }
}
