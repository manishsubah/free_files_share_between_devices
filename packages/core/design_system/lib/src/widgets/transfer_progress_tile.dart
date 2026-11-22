import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import '../utils/byte_format.dart';

class TransferProgressTile extends StatelessWidget {
  const TransferProgressTile({
    required this.fileName,
    required this.totalBytes,
    required this.transferredBytes,
    this.bytesPerSecond,
    this.onCancel,
    super.key,
  });

  final String fileName;
  final int totalBytes;
  final int transferredBytes;
  final double? bytesPerSecond;
  final VoidCallback? onCancel;

  double get progress =>
      totalBytes <= 0 ? 0 : (transferredBytes / totalBytes).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speed = bytesPerSecond;
    final details = [
      '${formatBytes(transferredBytes)} of ${formatBytes(totalBytes)}',
      if (speed != null && speed > 0) '${formatBytes(speed.round())}/s',
    ].join(' · ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined),
                AppSpacing.gapSm,
                Expanded(
                  child: Text(
                    fileName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${(progress * 100).floor()}%',
                  style: theme.textTheme.labelLarge,
                ),
                if (onCancel != null)
                  IconButton(
                    tooltip: 'Cancel',
                    icon: const Icon(Icons.close),
                    onPressed: onCancel,
                  ),
              ],
            ),
            AppSpacing.gapSm,
            LinearProgressIndicator(value: progress),
            AppSpacing.gapXs,
            Text(
              details,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
