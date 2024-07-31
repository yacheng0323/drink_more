import 'package:drink_more/core/database/database_service.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  sl.registerSingleton<DatabaseService>(DatabaseService());
}
