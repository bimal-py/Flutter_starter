import 'package:flutter/material.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/package_info/package_info.dart';
import 'package:flutter_starter/modules/settings/presentation/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: const [
          SettingsAppCardWidget(),
          SizedBox(height: 20),
          SettingsSectionHeaderWidget(label: 'Appearance'),
          SettingsThemePickerWidget(),
          SizedBox(height: 8),
          SettingsThemePlaygroundTileWidget(),
          SizedBox(height: 20),
          SettingsSectionHeaderWidget(label: 'App'),
          SettingsReplayOnboardingTileWidget(),
          SizedBox(height: 20),
          SettingsSectionHeaderWidget(label: 'Share & feedback'),
          SettingsShareFeedbackGroupWidget(),
          SizedBox(height: 20),
          SettingsSectionHeaderWidget(label: 'About'),
          SettingsAboutGroupWidget(),
          AppVersionFooter(),
        ],
      ),
    );
  }
}
