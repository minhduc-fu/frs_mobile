import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String title, String content) {
  showGeneralDialog(
    context: context, // BuildContext để xác định vị trí hiển thị của hộp thoại
    barrierDismissible:
        true, // cho phép người dùng đóng hộp thoại bằng cách chạm vào màn hình ngoài hộp thoại
    barrierLabel: '', // label thêm chú thích
    transitionDuration: const Duration(
        milliseconds:
            250), // Thời gian để thực hiện hiệu ứng animation khi hiển thị hộp thoại (trong ví dụ này là hiệu ứng scale và fade)
    pageBuilder: (context, animation1, animation2) {
      // xây dựng nội dung của hộp thoại, trả về container trống vì dùng transitionBuilder để hiển thị nội dung
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      // a1 đại diện cho thằng xuất hiện
      return ScaleTransition(
        // hiệu ứng co giãn
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: FadeTransition(
          // hiệu ứng làm mờ
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            title: Text(
              title,
              style: TextStyles.h4.bold,
            ),
            content: Text(
              content,
              style: TextStyles.defaultStyle.setTextSize(20),
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultCircle14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    },
  );
}
