import 'package:clock_app/features/timer/timer_run_model.dart';
import 'package:clock_app/shared/prefs_list_repository.dart';

const _key = 'clock_app_timer_history';
const _maxEntries = 50;

class TimerHistoryRepository {
  TimerHistoryRepository._();

  static final instance = TimerHistoryRepository._();

  static final _repo = PrefsListRepository<TimerRunRecord>(
    key: _key,
    fromJsonSafe: TimerRunRecord.fromJsonSafe,
    toJson: (r) => r.toJson(),
    maxEntries: _maxEntries,
    skipAddIfDuplicate: (list, record) =>
        list.isNotEmpty && list.first.durationSeconds == record.durationSeconds,
  );

  Future<List<TimerRunRecord>> getAll() => _repo.getAll();
  Future<void> add(TimerRunRecord record) => _repo.add(record);
  Future<void> removeAt(int index) => _repo.removeAt(index);
}
