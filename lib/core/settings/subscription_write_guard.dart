import 'package:flutter/material.dart';

import 'shop_profile_service.dart';

typedef SubscriptionTr = String Function(String en, String fa, [String? ps]);

class SubscriptionWriteGuard {
  static Future<bool> ensureCanWrite(
    BuildContext context,
    SubscriptionTr tr,
  ) async {
    final profile = await ShopProfileService.loadWithCloudFallback();
    final canWrite = profile?.canWrite ?? true;

    if (canWrite) return true;

    if (!context.mounted) return false;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          tr(
            'View-only mode: subscription expired. Renew to add or edit data.',
            'حالت فقط‌نمایش فعال است: اشتراک منقضی شده. برای افزودن یا ویرایش داده، اشتراک را تمدید کنید.',
            'یوازې-کتلو حالت فعال دی: ګډون پای ته رسېدلی. د معلوماتو د زیاتولو یا سمولو لپاره ګډون نوي کړئ.',
          ),
        ),
        action: SnackBarAction(
          label: tr('Renew', 'تمدید', 'تمدید'),
          onPressed: () {
            Navigator.pushNamed(context, '/subscription');
          },
        ),
      ),
    );

    return false;
  }
}
