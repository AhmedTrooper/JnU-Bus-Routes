import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _urlDeveloperOne = Uri.parse('https://github.com/AhmedTrooper');

class AboutTab extends StatefulWidget {
  const AboutTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutTabState();
  }
}

class _AboutTabState extends State<AboutTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 80,
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
                      const Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Color(0xFF2E4053),
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
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
                          const IconButton(
                            onPressed: _launchUrlOne,
                            icon: Icon(
                              LucideIcons.github,
                              size: 30,
                              color: Color(0xFF2E4053),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              foregroundColor: const Color(0xFF2E4053),
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
                    const Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xFF2E4053),
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Old JnU Bus Developer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Bus data collector, contactless....",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.github,
                          size: 30,
                          color: Color(0xFF2E4053),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: const Color(0xFF2E4053),
                          ),
                          child: const Text(
                            "Not Found",
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
        )
      ],
    );
  }
}

Future<void> _launchUrlOne() async {
  if (!await launchUrl(_urlDeveloperOne)) {
    throw Exception('Could not launch $_urlDeveloperOne');
  }
}
