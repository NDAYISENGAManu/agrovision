import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
    {'icon': Icons.landscape_outlined, 'activeIcon': Icons.landscape, 'label': 'Farms'},
    {'icon': Icons.camera_alt_outlined, 'activeIcon': Icons.camera_alt, 'label': 'Scan'},
    {'icon': Icons.store_outlined, 'activeIcon': Icons.store, 'label': 'Market'},
    {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _DashboardTab(),
          _FarmsTab(),
          _ScanTab(),
          _MarketTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _currentIndex == index;
                final isCenter = index == 2;

                if (isCenter) {
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A4F),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2D6A4F).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item['activeIcon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item['activeIcon'] : item['icon'],
                          color: isSelected
                              ? const Color(0xFF2D6A4F)
                              : Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? const Color(0xFF2D6A4F)
                                : Colors.grey[400],
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning! 👋',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Test Farmer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B4332),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weather card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kigali, Rwanda',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '24',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '°C',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Partly Cloudy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '⛅',
                      style: TextStyle(fontSize: 64),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick stats
              Row(
                children: [
                  _StatCard(
                    icon: Icons.landscape,
                    label: 'Farms',
                    value: '2',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.grass,
                    label: 'Crops',
                    value: '3',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.camera_alt,
                    label: 'Scans',
                    value: '5',
                    color: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _ActionButton(icon: '🔬', label: 'Scan', onTap: () {}),
                  _ActionButton(icon: '🚜', label: 'Add Farm', onTap: () {}),
                  _ActionButton(icon: '💰', label: 'Prices', onTap: () {}),
                  _ActionButton(icon: '📚', label: 'Learn', onTap: () {}),
                ],
              ),

              const SizedBox(height: 24),

              // Recent activities
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    _ActivityItem(
                      icon: Icons.grass,
                      title: 'Tomatoes planted',
                      subtitle: 'Green Valley Farm',
                      time: '2 hours ago',
                    ),
                    Divider(height: 1),
                    _ActivityItem(
                      icon: Icons.camera_alt,
                      title: 'Disease scan completed',
                      subtitle: 'No disease detected',
                      time: 'Yesterday',
                    ),
                    Divider(height: 1),
                    _ActivityItem(
                      icon: Icons.cloud,
                      title: 'Weather alert',
                      subtitle: 'Rain expected tomorrow',
                      time: '2 days ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF2D6A4F).withOpacity(0.1),
        child: Icon(icon, color: const Color(0xFF2D6A4F), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }
}

// Placeholder tabs
class _FarmsTab extends StatelessWidget {
  const _FarmsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Farms Tab'));
  }
}

class _ScanTab extends StatelessWidget {
  const _ScanTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Scan Tab'));
  }
}

class _MarketTab extends StatelessWidget {
  const _MarketTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Market Tab'));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Tab'));
  }
}
