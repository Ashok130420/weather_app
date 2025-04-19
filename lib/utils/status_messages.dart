import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

void showErrorMessage(
  String message,
) {
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: const TextStyle(color: AppColors.primary),
    ),
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 1),
    borderRadius: 8.0,
    backgroundColor: const Color.fromARGB(255, 249, 206, 203),
    borderWidth: 1,
    borderColor: Color.fromARGB(255, 249, 206, 203),
    // mainButton: CloseButton(
    //   onPressed: () async {
    //     await Get.closeCurrentSnackbar();
    //   },
    // ),
    icon: const Icon(
      Icons.error_outline,
      color: Colors.red,
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 86),
  );
}

void showInfoMessage(
  String message,
) {
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: TextStyle(color: AppColors.black),
    ),
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 1),
    borderRadius: 8.0,
    backgroundColor: AppColors.primary.withValues(alpha: .5),
    borderWidth: 1,
    borderColor: AppColors.primary,
    mainButton: CloseButton(
      onPressed: () async {
        await Get.closeCurrentSnackbar();
      },
    ),
    icon: const Icon(
      Icons.info_outline_rounded,
      color: AppColors.black,
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 86),
  );
}

void showSuccessMessage(
  String message,
) {
  Get.rawSnackbar(
    messageText: Row(
      children: [
        Text(
          message,
          style: const TextStyle(color: AppColors.primary),
        ),
      ],
    ),
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 1),
    borderRadius: 8.0,
    backgroundColor: const Color.fromARGB(255, 204, 255, 206),
    borderWidth: 1,
    borderColor: Color.fromARGB(255, 204, 255, 206),
    // mainButton: CloseButton(
    //   onPressed: () async {
    //     await Get.closeCurrentSnackbar();
    //   },
    // ),
    icon: const Icon(
      // Icons.verified_outlined,
      Icons.done,
      color: Colors.green,
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 86),
  );
}

void showWarningMessage(
  String message,
) {
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.amber),
    ),
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 1),
    borderRadius: 8.0,
    backgroundColor: const Color.fromARGB(255, 249, 237, 205),
    borderWidth: 1,
    borderColor: Colors.amber,
    mainButton: CloseButton(
      onPressed: () async {
        await Get.closeCurrentSnackbar();
      },
    ),
    icon: const Icon(
      Icons.warning_amber_rounded,
      color: Colors.amber,
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 86),
  );
}
