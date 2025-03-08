import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingTab extends ConsumerWidget {
  SettingTab({super.key});

  final formKey = GlobalKey<ShadFormState>();
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeStatus = ref.watch(isDarkTheme);
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(1),
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                      color: Theme.of(context).brightness != Brightness.dark
                          ? Colors.white
                          : Colors.grey[800]!,
                      width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () async {
                          await SharedPreferencesHelper.setThemeStatus(
                              !isDarkModeStatus);
                          ref.read(isDarkTheme.notifier).state =
                              !isDarkModeStatus;
                        },
                        icon: isDarkModeStatus
                            ? const Icon(
                                LucideIcons.sun,
                                size: 35,
                                color: Colors.white,
                              )
                            : const Icon(
                                LucideIcons.moon,
                                size: 35,
                                color: Colors.blueAccent,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShadForm(
                      key: formKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          children: [
                            ShadInputFormField(
                              cursorColor: Colors.blueAccent,
                              controller: _userNameController,
                              autofocus: false,
                              id: 'username',
                              label: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.user,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              placeholder: const Text('Enter your username'),
                              description: const Text(
                                "Set up you homepage profile",
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.saveAndValidate()) {
                                  if (_userNameController.text.isNotEmpty) {
                                    SharedPreferencesHelper.setUserName(
                                        _userNameController.text);
                                    _userNameController.text = "";
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                fixedSize: const Size(120, 60),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
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
