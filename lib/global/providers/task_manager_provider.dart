import 'package:classlens/global/providers/task_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:classlens/data_models/notification_hive_model.dart';
import 'package:classlens/data_models/task_status.dart';

class UserTask {
  late final String taskID;
  late final DateTime submissionTime;
  TaskStatus? currentStatus;
  late bool isRead;

  UserTask({
    required this.taskID,
    required this.submissionTime,
    this.currentStatus,
    this.isRead = true,
  });

  bool get isCompleted =>
      currentStatus?.status == 'SUCCESS' || currentStatus?.status == 'FAILURE';
}

class TaskManagerNotifier extends StateNotifier<List<UserTask>> {
  final Ref _ref;
  final _box = Hive.box<NotificationHiveModel>('notifications');


  final Set<String> _activeListeners = {};

  TaskManagerNotifier(this._ref) : super([]) {
    final tasksFromHive =
    _box.values.map((hiveTask) => hiveTask.toUserTask()).toList();
    state = tasksFromHive;
    print("Loaded ${state.length} tasks from Hive on startup.");

    for (final task in state) {
      if (!task.isCompleted) {
        _listenToSingleTask(task);
      }
    }
  }

  void _listenToSingleTask(UserTask task) {
    // Prevent duplicate listeners
    if (_activeListeners.contains(task.taskID)) {
      return;
    }
    _activeListeners.add(task.taskID);

    _ref.listen<AsyncValue<TaskStatus>>(
      taskStatusProvider(task.taskID),
          (previous, next) {
        if (next.isLoading || next.hasError || !next.hasValue) return;

        final previousStatus = previous?.value?.status;
        final newStatus = next.value!.status;


        if (previousStatus != newStatus) {
          print("Status for ${task
              .taskID} changed from '$previousStatus' to '$newStatus'. Updating state.");
          updateTaskStatus(task.taskID, next.value!);
        }
      },
    );
  }

  void addTask(String taskID) {
    if (state.any((task) => task.taskID == taskID)) return;

    final newTask = UserTask(taskID: taskID, submissionTime: DateTime.now());
    state = [...state, newTask];
    _saveStateToHive();

    _listenToSingleTask(newTask);
  }

  void updateTaskStatus(String taskID, TaskStatus status) {
    state = [
      for (final task in state)
        if (task.taskID == taskID)
          UserTask(
            taskID: task.taskID,
            submissionTime: task.submissionTime,
            currentStatus: status,
            isRead: (status.status == 'SUCCESS' || status.status == 'FAILURE')
                ? false
                : task.isRead,
          )
        else
          task
    ];
  }

  void addCompletedTask(UserTask completedTask) {
    final currentState = [...state];
    final index = currentState.indexWhere((task) =>
    task.taskID == completedTask.taskID);

    if (index != -1) {
      currentState[index] = completedTask;
    } else {
      currentState.add(completedTask);
    }
    state = currentState;
    _saveStateToHive();
  }

  void markAllRead() {
    state = [
      for(final task in state)
        UserTask(
          taskID: task.taskID,
          submissionTime: task.submissionTime,
          currentStatus: task.currentStatus,
          isRead: true,
        )
    ];
    _saveStateToHive();
  }

  void _saveStateToHive() {
    final existingKeys = _box.keys.cast<String>().toSet();

    for (var task in state) {
      print(task.isCompleted);
      final model = NotificationHiveModel.fromUserTask(task);
      print(model.taskID);
      _box.put(task.taskID, model);
      existingKeys.remove(task.taskID);
    }

    for (var obsoleteKey in existingKeys) {
      print(obsoleteKey+"deleted");
      _box.delete(obsoleteKey);
    }
  }

  void deleteAllNotification(){
    state=[];
    _box.clear();

    print("cleared notification");
  }
}


final taskManagerProvider =
StateNotifierProvider<TaskManagerNotifier, List<UserTask>>((ref) {
  return TaskManagerNotifier(ref);
});

final unreadTaskCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(taskManagerProvider);
  return tasks.where((task) => !task.isRead && task.isCompleted).length;
});