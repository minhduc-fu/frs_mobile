import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';

import '../core/constants/dismension_constants.dart';
import '../core/constants/textstyle_constants.dart';

void showCustomDialog(BuildContext context, String title, String content,
    bool barrierDismissible) {
  showGeneralDialog(
    context: context, // BuildContext để xác định vị trí hiển thị của hộp thoại
    barrierDismissible:
        barrierDismissible, // cho phép người dùng đóng hộp thoại bằng cách chạm vào màn hình ngoài hộp thoại
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
            elevation: 0,
            backgroundColor: ColorPalette.grey3a,
            title: Text(
              title,
              style: TextStyles.h5.bold.setTextSize(20),
            ),
            content: Text(
              content,
              style: TextStyles.defaultStyle.setTextSize(18),
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultCircle14),
              borderSide: BorderSide.none,
            ),
            actions: [
              barrierDismissible
                  ? ButtonWidget(
                      title: "OK",
                      size: 18,
                      height: 40,
                      width: 120,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    },
  );
}
