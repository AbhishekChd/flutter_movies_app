import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/constants/strings.dart';

class ApiKeyEdit extends StatelessWidget {
  const ApiKeyEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = preferences.getApiKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  preferences.saveApiKey(controller.text);
                } else {
                  preferences.saveApiKey('');
                }
                Navigator.pop(context);
              },
              child: const Text(Strings.settingActionDone))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryTextField(
          label: "API Key",
          prefixIcon: Icons.key,
          inputType: TextInputType.multiline,
          controller: controller,
        ),
      ),
    );
  }
}
