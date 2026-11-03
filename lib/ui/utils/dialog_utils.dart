import 'package:flutter/material.dart';

class DialogUtils {
  // ========== Loading Dialog ==========
  // بيعرض دايلوج بـ CircularProgressIndicator أثناء العمليات الطويلة
  // barrierDismissible = false علشان المستخدم ميقدرش يقفله بالضغط برا
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Please wait...'),
          ],
        ),
      ),
    );
  }

  // بيقفل أي Dialog مفتوح حالياً
  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // ========== Message Dialog ==========
  // بيعرض رسالة للمستخدم (نجاح أو خطأ)
  // message        = نص الرسالة
  // posBottomTitle = عنوان زرار التأكيد (مثلاً "OK" أو "Retry")
  // posBottomAction = الـ callback لما المستخدم يضغط الزرار
  static void showMessage(
    BuildContext context, {
    required String message,
    String? posBottomTitle,
    VoidCallback? posBottomAction,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (posBottomTitle != null)
            TextButton(
              onPressed: posBottomAction ??
                  () => Navigator.of(context, rootNavigator: true).pop(),
              child: Text(
                posBottomTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

