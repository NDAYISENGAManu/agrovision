import 'package:flutter/material.dart';

/// Empty state widget for lists with no data
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Preset empty states
class EmptyFarmsWidget extends StatelessWidget {
  final VoidCallback? onAdd;
  
  const EmptyFarmsWidget({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.landscape_outlined,
      title: 'No Farms Yet',
      subtitle: 'Start by adding your first farm to track your crops.',
      actionLabel: 'Add Farm',
      onAction: onAdd,
    );
  }
}

class EmptyCropsWidget extends StatelessWidget {
  final VoidCallback? onAdd;
  
  const EmptyCropsWidget({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.grass_outlined,
      title: 'No Crops Yet',
      subtitle: 'Add crops to track their growth and health.',
      actionLabel: 'Add Crop',
      onAction: onAdd,
    );
  }
}

class EmptyDiagnosesWidget extends StatelessWidget {
  final VoidCallback? onScan;
  
  const EmptyDiagnosesWidget({super.key, this.onScan});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.camera_alt_outlined,
      title: 'No Diagnoses Yet',
      subtitle: 'Scan your crops to detect diseases and get treatment recommendations.',
      actionLabel: 'Scan Now',
      onAction: onScan,
    );
  }
}

class EmptyListingsWidget extends StatelessWidget {
  final VoidCallback? onCreate;
  
  const EmptyListingsWidget({super.key, this.onCreate});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.storefront_outlined,
      title: 'No Listings Found',
      subtitle: 'Be the first to list your produce in the marketplace.',
      actionLabel: 'Create Listing',
      onAction: onCreate,
    );
  }
}

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.notifications_none_outlined,
      title: 'No Notifications',
      subtitle: 'You\'re all caught up! New notifications will appear here.',
    );
  }
}
