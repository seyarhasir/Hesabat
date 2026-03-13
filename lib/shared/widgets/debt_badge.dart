import 'package:flutter/material.dart';
import '../../core/utils/number_system_formatter.dart';
import '../theme/app_colors.dart';

enum DebtStatus {
  current,
  warning,
  overdue,
}

class DebtBadge extends StatelessWidget {
  final double amount;
  final int daysSince;
  final bool showAmount;
  final bool isCompact;

  const DebtBadge({
    super.key,
    required this.amount,
    required this.daysSince,
    this.showAmount = true,
    this.isCompact = false,
  });

  DebtStatus get _status {
    if (daysSince > 30) return DebtStatus.overdue;
    if (daysSince > 7) return DebtStatus.warning;
    return DebtStatus.current;
  }

  Color get _color {
    switch (_status) {
      case DebtStatus.current: return AppColors.success;
      case DebtStatus.warning: return AppColors.warning;
      case DebtStatus.overdue: return AppColors.danger;
    }
  }

  String get _label {
    switch (_status) {
      case DebtStatus.current: return 'Current';
      case DebtStatus.warning: return 'Due soon';
      case DebtStatus.overdue: return 'Overdue';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _label,
            style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          if (showAmount) ...[
            const SizedBox(width: 8),
            Text(
              '${NumberSystemFormatter.formatFixed(amount)} \u060B',
              style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
