import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';


class AsyncTaskHelper {
  static final OverlayEntry _loading = OverlayEntry(
    builder: (context) => Stack(
      fit: StackFit.expand,
      children: [
        const ModalBarrier(
          dismissible: false,
          color: Colors.black12,
        ),
        Center(
          child: Container(
              alignment: Alignment.center,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CupertinoActivityIndicator(
                radius: 18,
                color: AppColors.primary,
              )),
        ),
      ],
    ),
  );

  static void remove() => _loading.remove();

  static void showBusy(BuildContext context) =>
      Overlay.of(context).insert(_loading);
}
