import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlens/global/providers/task_manager_provider.dart';
import 'package:classlens/home/teacher_home/widgets/notification_task_item.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the main list of tasks from our central provider
    final tasks = ref.watch(taskManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF0F4F8),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          'You have no notifications yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        // We reverse the list to show the newest tasks at the top
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[tasks.length - 1 - index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: NotificationTaskItem(task: task),
          );
        },
      ),
    );
  }
}