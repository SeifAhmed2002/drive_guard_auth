/// Mock for now (always grants). Replace with the permission_handler package
/// when you test on a real phone.
abstract class PermissionService {
  Future<bool> requestCamera();
  Future<bool> requestLocation();
}

class MockPermissionService implements PermissionService {
  @override
  Future<bool> requestCamera() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return true;
  }

  @override
  Future<bool> requestLocation() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return true;
  }
}

final PermissionService permissionService = MockPermissionService();