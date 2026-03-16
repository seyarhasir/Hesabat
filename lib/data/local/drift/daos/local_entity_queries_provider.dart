import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_database_provider.dart';
import 'local_entity_queries.dart';

final localEntityQueriesProvider = Provider<LocalEntityQueries>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalEntityQueries(db);
});
