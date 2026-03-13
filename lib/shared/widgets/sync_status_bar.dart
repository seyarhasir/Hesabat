import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SyncStatus {
  online,
  offline,
  syncing,
  error,
  conflict,
}

class SyncStatusBar extends StatelessWidget {
  final SyncStatus status;
  final int? pendingCount;
  final VoidCallback? onTap;

  const SyncStatusBar({
    super.key,
    required this.status,
    this.pendingCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _bgColor(cs).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _bgColor(cs).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _icon(cs),
            const SizedBox(width: 6),
            Text(
              _text,
              style: TextStyle(
                color: _bgColor(cs),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (pendingCount != null && pendingCount! > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _bgColor(cs).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pendingCount',
                  style: TextStyle(
                    color: _bgColor(cs),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _icon(ColorScheme cs) {
    final color = _bgColor(cs);
    switch (status) {
      case SyncStatus.online:
        return Icon(Icons.cloud_done, color: color, size: 16);
      case SyncStatus.offline:
        return Icon(Icons.cloud_off, color: color, size: 16);
      case SyncStatus.syncing:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      case SyncStatus.error:
        return Icon(Icons.error_outline, color: color, size: 16);
      case SyncStatus.conflict:
        return Icon(Icons.merge_type_rounded, color: color, size: 16);
    }
  }

  String get _text {
    switch (status) {
      case SyncStatus.online:
        return 'Synced';
      case SyncStatus.offline:
        return 'Offline';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.error:
        return 'Sync error';
      case SyncStatus.conflict:
        return 'Conflicts';
    }
  }

  Color _bgColor(ColorScheme cs) {
    switch (status) {
      case SyncStatus.online:
        return AppColors.success;
      case SyncStatus.offline:
        return AppColors.warning;
      case SyncStatus.syncing:
        return cs.primary;
      case SyncStatus.error:
        return AppColors.danger;
      case SyncStatus.conflict:
        return Colors.deepPurple;
    }
  }
}
