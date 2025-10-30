import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class Helper {
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static showSnackBarMessage(
      {required BuildContext context,
      required String text,
      int? durationInSec,
      Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: durationInSec ?? 2),
        content: Text(text,
            style: GoogleFonts.lato(
              color: Colors.white,
            )),
        backgroundColor: bgColor ?? AppColors.darkBlue,
      ),
    );
  }
}
