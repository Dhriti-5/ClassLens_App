import 'dart:async';
import 'package:classlens/data_models/task_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlens/api/api.dart';

final apiServiceProvider = Provider((ref)=>ApiServices());

final taskStatusProvider = StreamProvider.family<TaskStatus,String>((ref,taskID){

  final controller = StreamController<TaskStatus>();
  Timer? timer;

  int attempts =0;
  const maxAttempts = 12;
  Duration delay = const Duration(seconds: 2);

  Future<void> poll() async{
    if(attempts>=maxAttempts){
      controller.addError('Polling timed out');
      await controller.close();
      timer?.cancel();
      return;
    }
    attempts++;

    try{
      final status = await ApiServices.checkTaskStatus(taskID: taskID);
      controller.add(status);

      if(status.status=='SUCCESS' || status.status=='FAILURE'){
        await controller.close();
        timer?.cancel();
      }
      else{
        delay = Duration(seconds: (delay.inSeconds*2).clamp(2, 30));
        timer = Timer(delay, poll);
      }
    }
    catch(e){
      controller.addError(e);
      await controller.close();
      timer?.cancel();
    }
  }

  controller.onListen =()=>poll();
  controller.onCancel=()=>timer?.cancel();
  return controller.stream;
});