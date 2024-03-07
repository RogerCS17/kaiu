import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusWidget extends StatelessWidget {
  const PermissionStatusWidget({Key? key}) : super(key: key);

  Future<PermissionStatus> _getNotificationPermissionStatus() async {
    return await Permission.notification.status;
  }

  Future<void> requestPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    } else {
      Fluttertoast.showToast(
          msg: "Permisos de notificaciones habilitados",
          toastLength: Toast.LENGTH_SHORT); // Show toast
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: _getNotificationPermissionStatus(),
      builder: (context, snapshot) {
        final status = snapshot.data;
        return IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {
            requestPermission();
          },
        );
      },
    );
  }
}
