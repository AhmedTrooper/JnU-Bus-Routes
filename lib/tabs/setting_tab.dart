import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SettingTab();
  }
}

class _SettingTab extends State<SettingTab>{

  final formKey = GlobalKey<ShadFormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child:  SingleChildScrollView(
        child: Column(
          children: [
ShadForm(child: ConstrainedBox(
  constraints:  const BoxConstraints(maxWidth: 350),
  child: Column(
    children: [
      ShadInputFormField(
        id: 'username',
        label: const Text('Username'),
        placeholder: const Text('Enter your username'),
        description: const Text("This is your name for homepage"),
      ),
      const SizedBox(height: 16),
      ShadButton(
        child: const Text('Submit'),
        onPressed: () {
          if (formKey.currentState!.saveAndValidate()) {

          } else {

          }
        },
      ),
    ],
  ),
))
          ],
        ),
      ),
    );
  }
}