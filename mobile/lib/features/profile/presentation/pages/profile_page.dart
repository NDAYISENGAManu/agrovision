import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get user data from provider
    final userData = {
      'name': 'John Farmer',
      'email': 'john@example.com',
      'phone': '+250 788 123 456',
      'role': 'Farmer',
      'location': 'Musanze, Northern Province',
      'memberSince': 'January 2024',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(userData),
            const SizedBox(height: 24),
            _buildStatsSection(context),
            const SizedBox(height: 24),
            _buildMenuSection(context),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, String> userData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade200,
              child: Text(
                userData['name']![0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userData['name']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                userData['role']!,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ProfileInfo(
              icon: Icons.email,
              text: userData['email']!,
            ),
            const SizedBox(height: 8),
            _ProfileInfo(
              icon: Icons.phone,
              text: userData['phone']!,
            ),
            const SizedBox(height: 8),
            _ProfileInfo(
              icon: Icons.location_on,
              text: userData['location']!,
            ),
            const SizedBox(height: 8),
            _ProfileInfo(
              icon: Icons.calendar_today,
              text: 'Member since ${userData['memberSince']}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.agriculture,
            label: 'Farms',
            value: '3',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.camera_alt,
            label: 'Diagnoses',
            value: '12',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.shopping_bag,
            label: 'Orders',
            value: '8',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Navigate to edit profile
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // TODO: Navigate to notifications settings
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // TODO: Show language selector
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.security,
            title: 'Privacy & Security',
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // TODO: Show about dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutDialog(context);
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Clear auth state
              context.go('/login');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
