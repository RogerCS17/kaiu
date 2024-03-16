import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusWidget extends StatefulWidget {
  const PermissionStatusWidget({Key? key}) : super(key: key);

  @override
  State<PermissionStatusWidget> createState() => _PermissionStatusWidgetState();
}

class _PermissionStatusWidgetState extends State<PermissionStatusWidget> {
  late PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    PermissionStatus status = await Permission.notification.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request().then((value) {
        _checkPermissionStatus();
      });
      // Actualizar el estado después de solicitar permisos
    } else if (await Permission.notification.isGranted) {
      Fluttertoast.showToast(
          msg: "Permisos de notificaciones habilitados",
          toastLength: Toast.LENGTH_SHORT); // Mostrar un toast
      _checkPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _permissionStatus == PermissionStatus.granted
            ? Icons.notifications_active_sharp
            : Icons.notifications_off,
        color: Colors.white,
      ),
      onPressed: () {
        _requestPermission();
      },
    );
  }
}
