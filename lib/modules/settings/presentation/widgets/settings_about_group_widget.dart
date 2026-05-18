import 'package:flutter/material.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/settings/presentation/widgets/settings_tile_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsAboutGroupWidget extends StatelessWidget {
  const SettingsAboutGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SettingsTileWidget(
            icon: LucideIcons.smartphone,
            label: 'Device info',
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => context.pushNamed(Routes.deviceInfo.name),
          ),
          const Divider(height: 1),
          SettingsTileWidget(
            icon: LucideIcons.package,
            label: 'Package info',
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => context.pushNamed(Routes.packageInfo.name),
          ),
        ],
      ),
    );
  }
}
