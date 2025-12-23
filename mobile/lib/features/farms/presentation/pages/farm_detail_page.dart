import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';

class FarmDetailPage extends ConsumerStatefulWidget {
  final String farmId;

  const FarmDetailPage({
    Key? key,
    required this.farmId,
  }) : super(key: key);

  @override
  ConsumerState<FarmDetailPage> createState() => _FarmDetailPageState();
}

class _FarmDetailPageState extends ConsumerState<FarmDetailPage> {
  bool _isLoading = false;
  Map<String, dynamic>? _farm;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFarmDetails();
  }

  Future<void> _loadFarmDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _farm = {
          'id': widget.farmId,
          'name': 'North Field',
          'size': 2.5,
          'location': 'Musanze, Northern Province',
          'soilType': 'Clay Loam',
          'irrigationType': 'Drip',
          'crops': [
            {
              'name': 'Maize',
              'area': 1.5,
              'plantedDate': '2024-03-15',
              'expectedHarvest': '2024-07-15',
              'status': 'Growing',
            },
            {
              'name': 'Beans',
              'area': 1.0,
              'plantedDate': '2024-03-20',
              'expectedHarvest': '2024-06-20',
              'status': 'Growing',
            },
          ],
        };
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
        title: Text(_farm?['name'] ?? 'Farm Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit page
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  message: _error!,
                  onRetry: _loadFarmDetails,
                )
              : _farm == null
                  ? const Center(child: Text('Farm not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(),
                          const SizedBox(height: 24),
                          _buildCropsSection(),
                          const SizedBox(height: 24),
                          _buildActionsSection(),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Farm Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.crop_square,
              label: 'Size',
              value: '${_farm!['size']} hectares',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: _farm!['location'],
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.terrain,
              label: 'Soil Type',
              value: _farm!['soilType'],
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.water_drop,
              label: 'Irrigation',
              value: _farm!['irrigationType'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropsSection() {
    final crops = _farm!['crops'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Crops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Add crop
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Crop'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...crops.map((crop) => _CropCard(crop: crop)).toList(),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.camera_alt,
                label: 'Diagnose',
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate to diagnosis
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.wb_sunny,
                label: 'Weather',
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to weather
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Farm'),
        content: const Text(
          'Are you sure you want to delete this farm? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete farm
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CropCard extends StatelessWidget {
  final Map<String, dynamic> crop;

  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  crop['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                    crop['status'],
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CropInfo(
                    label: 'Area',
                    value: '${crop['area']} ha',
                  ),
                ),
                Expanded(
                  child: _CropInfo(
                    label: 'Planted',
                    value: crop['plantedDate'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CropInfo(
              label: 'Expected Harvest',
              value: crop['expectedHarvest'],
            ),
          ],
        ),
      ),
    );
  }
}

class _CropInfo extends StatelessWidget {
  final String label;
  final String value;

  const _CropInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
