import 'package:clock_app/features/stopwatch/stopwatch_run_model.dart';
import 'package:clock_app/shared/prefs_list_repository.dart';

const _key = 'clock_app_stopwatch_run_history';
const _maxEntries = 50;

class StopwatchHistoryRepository {
  StopwatchHistoryRepository._();

  static final instance = StopwatchHistoryRepository._();

  static final _repo = PrefsListRepository<StopwatchRunRecord>(
    key: _key,
    fromJsonSafe: StopwatchRunRecord.fromJsonSafe,
    toJson: (r) => r.toJson(),
    maxEntries: _maxEntries,
  );

  Future<List<StopwatchRunRecord>> getAll() => _repo.getAll();
  Future<void> add(StopwatchRunRecord record) => _repo.add(record);
  Future<void> removeAt(int index) => _repo.removeAt(index);
}
