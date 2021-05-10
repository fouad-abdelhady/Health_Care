import 'package:permission_handler/permission_handler.dart';

class PermissionsManager{
  static final Permission LOCATION_PERMISSIONS = Permission.location;
  static final Permission STORGE_PERMISSIONS = Permission.storage;
  static final Permission CAMERA_PERMISSION = Permission.camera;


  static final _permissionsManager = PermissionsManager._internal();
  factory PermissionsManager () => _permissionsManager;
  PermissionsManager._internal();

  Future checkAndRequestPermission(Permission permission) async {
    if(await permission.status.isDenied)
      await permission.request();
    return await permission.status.isGranted;
  }

}