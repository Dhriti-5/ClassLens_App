import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlens/global/providers/task_manager_provider.dart';
import 'package:classlens/global/providers/task_provider.dart';
import 'package:intl/intl.dart';

class NotificationTaskItem extends ConsumerWidget {
  final UserTask task;
  const NotificationTaskItem({required this.task, super.key});

  void _showResultImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Text("Attendance Result", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Image.network(imageUrl),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the individual provider for this specific task to get live updates
    final asyncTaskStatus = ref.watch(taskStatusProvider(task.taskID));

    return asyncTaskStatus.when(
      // While waiting for the first status update
      loading: () => ListTile(
        leading: const CircularProgressIndicator(),
        title: const Text("Attendance Scan", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat.yMMMd().add_jm().format(task.submissionTime)),
      ),

      // If the polling fails for any reason
      error: (err, stack) => ListTile(
        leading: const Icon(Icons.error_outline, color: Colors.red),
        title: const Text("Task Failed", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        subtitle: Text(err.toString(), maxLines: 2),
      ),
      // When we get data (a TaskStatus object)
      data: (status) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(taskManagerProvider.notifier).updateTaskStatus(task.taskID, status);
        });

        Widget trailingWidget;
        switch (status.status) {
          case 'SUCCESS':
            trailingWidget = TextButton.icon(
              icon: const Icon(Icons.image_outlined),
              label: const Text("View"),
              onPressed: () {
                if (status.result is Map && status.result.containsKey('image_url')) {
                  _showResultImage(context, status.result['image_url']);
                }
              },
            );
            break;
          default: // PENDING, STARTED, or any other state
            trailingWidget = const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            );
        }

        return ListTile(
          leading: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
          title: const Text("Attendance Scan", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Status: ${status.status}'),
          trailing: trailingWidget,
        );
      },
    );
  }
}