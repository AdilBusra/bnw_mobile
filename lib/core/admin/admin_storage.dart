import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'admin_store.dart';

Future<void> initializeAdminStorage(AdminStore store) async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}${Platform.pathSeparator}bnw_admin_v1.json');
  await store.initialize(
    read: () async => await file.exists() ? file.readAsString() : null,
    write: (value) async {
      await directory.create(recursive: true);
      final temporary = File('${file.path}.tmp');
      await temporary.writeAsString(value, flush: true);
      await temporary.rename(file.path);
    },
  );
}
