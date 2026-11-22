import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

enum DeviceKind { phone, desktop, laptop, tablet }

enum DeviceStatus { available, connected, offline }

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    required this.name,
    required this.kind,
    this.status = DeviceStatus.available,
    this.subtitle,
    this.onTap,
    this.trailing,
    super.key,
  });

  final String name;
  final DeviceKind kind;
  final DeviceStatus status;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Icon(_iconFor(kind)),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,
                    Row(
                      children: [
                        _StatusDot(status: status),
                        AppSpacing.gapXs,
                        Flexible(
                          child: Text(
                            subtitle ?? _labelFor(status),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[AppSpacing.gapSm, trailing!],
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(DeviceKind kind) => switch (kind) {
    DeviceKind.phone => Icons.smartphone,
    DeviceKind.desktop => Icons.desktop_windows_outlined,
    DeviceKind.laptop => Icons.laptop,
    DeviceKind.tablet => Icons.tablet_android,
  };

  static String _labelFor(DeviceStatus status) => switch (status) {
    DeviceStatus.available => 'Available',
    DeviceStatus.connected => 'Connected',
    DeviceStatus.offline => 'Offline',
  };
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final DeviceStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      DeviceStatus.available => AppColors.warning,
      DeviceStatus.connected => AppColors.success,
      DeviceStatus.offline => Theme.of(context).colorScheme.outline,
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
