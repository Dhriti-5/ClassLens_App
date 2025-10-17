import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlens/global/providers/task_manager_provider.dart';
import 'package:classlens/global/providers/task_provider.dart';

// --- Design Constants for consistent styling ---
const Color primaryTextColor = Color(0xFF1A2533);
const Color secondaryTextColor = Color(0xFF6C757D);
const Color accentColor = Color(0xFF4A90E2);
const Color successColor = Color(0xFF43A047);
const Color pendingColor = Color(0xFFFDD835);
const Color errorColor = Color(0xFFE53935);

class NotificationTaskItem extends ConsumerWidget {
  final UserTask task;
  final bool isRead;

  const NotificationTaskItem({
    required this.task,
    required this.isRead,
    super.key,
  });

  void _showResultImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Attendance Result", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                loadingBuilder: (context, child, progress) =>
                progress == null ? child : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({Color color, IconData icon}) _getStatusStyle(String status) {
    switch (status) {
      case 'SUCCESS':
        return (color: successColor, icon: Icons.check_circle_outline);
      case 'PENDING':
      case 'STARTED':
        return (color: pendingColor, icon: Icons.hourglass_bottom_rounded);
      default:
        return (color: errorColor, icon: Icons.error_outline_rounded);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTaskStatus = ref.watch(taskStatusProvider(task.taskID));
    final taskManager = ref.read(taskManagerProvider.notifier);

    return asyncTaskStatus.when(
      loading: () => _buildLayout(
        context: context,
        icon: Icons.hourglass_empty,
        iconColor: Colors.grey,
        title: "Attendance Scan",
        subtitle: "Initializing...",
        trailing: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
      ),
      error: (err, stack) => _buildLayout(
        context: context,
        icon: Icons.error_outline,
        iconColor: errorColor,
        title: "Scan Failed",
        subtitle: err.toString(),
        trailing: const Icon(Icons.refresh, color: secondaryTextColor),
      ),
      data: (status) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          taskManager.updateTaskStatus(task.taskID, status);
        });

        final statusStyle = _getStatusStyle(status.status);
        Widget trailingWidget;
        if (status.status == 'SUCCESS') {
          trailingWidget = TextButton(
            child: const Text("View", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              if (!isRead) taskManager.markAllRead();
              if (status.result is Map && status.result.containsKey('image_url')) {
                _showResultImage(context, status.result['image_url']);
              }
            },
          );
        } else {
          trailingWidget = const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5));
        }

        return _buildLayout(
          context: context,
          icon: statusStyle.icon,
          iconColor: statusStyle.color,
          title: "Attendance Scan",
          subtitle: 'Status: ${status.status}',
          trailing: trailingWidget,
        );
      },
    );
  }

  // This widget now ONLY builds the content, not the background card itself.
  Widget _buildLayout({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return InkWell(
      onTap: () {
        final taskManager = ProviderScope.containerOf(context).read(taskManagerProvider.notifier);
        if (!isRead) taskManager.markAllRead();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: iconColor.withOpacity(0.15),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                if (!isRead)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: secondaryTextColor, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}