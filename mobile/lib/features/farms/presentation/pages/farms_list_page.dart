import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state.dart';

class FarmsListPage extends ConsumerStatefulWidget {
  const FarmsListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FarmsListPage> createState() => _FarmsListPageState();
}

class _FarmsListPageState extends ConsumerState<FarmsListPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _farms = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      setState(() {
        _farms = [
          {
            'id': '1',
            'name': 'North Field',
            'size': 2.5,
            'location': 'Musanze',
            'crops': ['Maize', 'Beans'],
            'status': 'Active',
          },
          {
            'id': '2',
            'name': 'South Valley',
            'size': 1.8,
            'location': 'Huye',
            'crops': ['Coffee'],
            'status': 'Active',
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Farms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/farms/add');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  message: _error!,
                  onRetry: _loadFarms,
                )
              : _farms.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.agriculture,
                      title: 'No Farms Yet',
                      message: 'Add your first farm to get started',
                      actionLabel: 'Add Farm',
                      onAction: () {
                        context.push('/farms/add');
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFarms,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _farms.length,
                        itemBuilder: (context, index) {
                          final farm = _farms[index];
                          return _FarmCard(
                            farm: farm,
                            onTap: () {
                              context.push('/farms/${farm['id']}');
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  final Map<String, dynamic> farm;
  final VoidCallback onTap;

  const _FarmCard({
    required this.farm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.agriculture,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              farm['location'],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      farm['status'],
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.crop_square,
                    label: '${farm['size']} ha',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.eco,
                    label: '${farm['crops'].length} crops',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (farm['crops'] as List<String>)
                    .map((crop) => Chip(
                          label: Text(
                            crop,
                            style: const TextStyle(fontSize: 12),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
