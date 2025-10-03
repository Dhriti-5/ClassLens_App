import 'package:classlens/api/api.dart';
import 'package:classlens/data_models/task_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


class UserTask{
  late final String taskID;
  late final DateTime submissionTime;

  TaskStatus? currentStatus;
  late bool isRead;

  UserTask({
    required this.taskID,
    required this.submissionTime,
    this.currentStatus,
    this.isRead =true
  });

  bool get isCompleted=> currentStatus?.status == 'SUCCESS' || currentStatus?.status=='FAILURE';
}


class TaskManagerNotifier extends StateNotifier<List<UserTask>>{
  TaskManagerNotifier():super([]);

  // Adds a new task to the list when a user submits attendance
  void addTask(String taskID){
    if(state.where((task)=>task.taskID==taskID).isEmpty){
      final newTask = UserTask(taskID: taskID, submissionTime: DateTime.now());
      state = [...state,newTask];
    }
  }

  // Updates a task's status (and read state) based on the backend response
  void updateTaskStatus(String taskID, TaskStatus status){
    state=[
      for(final task in state)
        if (task.taskID==taskID)
          UserTask(
              taskID: task.taskID,
              submissionTime: task.submissionTime,
              currentStatus: status,
            isRead: (status.status=='SUCCESS'||status.status=='FAILURE')?false:task.isRead,
          )
        else
          task
    ];
  }

  void markAllRead(){
    state=[
      for(final task in state)
        UserTask(
          taskID: task.taskID,
          submissionTime: task.submissionTime,
          currentStatus: task.currentStatus,
          isRead: true,
        )
    ];
  }
}

final taskManagerProvider = StateNotifierProvider<TaskManagerNotifier,List<UserTask>>((ref) {
  return TaskManagerNotifier();
});

final unreadTaskCountProvider = Provider<int>((ref){
  final tasks = ref.watch(taskManagerProvider);
  return tasks.where((task)=> !task.isRead && task.isCompleted).length;

});