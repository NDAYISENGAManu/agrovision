import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state.dart';

class LearningPage extends ConsumerStatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _content = [];
  String? _error;
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All'},
    {'id': 'crops', 'label': 'Crops'},
    {'id': 'pests', 'label': 'Pests'},
    {'id': 'soil', 'label': 'Soil'},
    {'id': 'weather', 'label': 'Weather'},
    {'id': 'market', 'label': 'Market'},
  ];

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _content = [
          {
            'id': '1',
            'title': 'Best Practices for Maize Farming',
            'category': 'crops',
            'description': 'Learn the optimal techniques for growing maize',
            'duration': '15 min',
            'views': 1234,
            'thumbnail': 'https://via.placeholder.com/150',
          },
          {
            'id': '2',
            'title': 'Identifying and Managing Crop Diseases',
            'category': 'pests',
            'description': 'Common diseases and how to treat them',
            'duration': '20 min',
            'views': 987,
            'thumbnail': 'https://via.placeholder.com/150',
          },
          {
            'id': '3',
            'title': 'Soil Health and Fertility',
            'category': 'soil',
            'description': 'Understanding soil composition and nutrients',
            'duration': '18 min',
            'views': 756,
            'thumbnail': 'https://via.placeholder.com/150',
          },
          {
            'id': '4',
            'title': 'Organic Farming Techniques',
            'category': 'crops',
            'description': 'Sustainable farming without chemicals',
            'duration': '25 min',
            'views': 2341,
            'thumbnail': 'https://via.placeholder.com/150',
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

  List<Map<String, dynamic>> get _filteredContent {
    if (_selectedCategory == 'all') return _content;
    return _content
        .where((item) => item['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : _error != null
                    ? AppErrorWidget(
                        message: _error!,
                        onRetry: _loadContent,
                      )
                    : _filteredContent.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.school,
                            title: 'No Content',
                            message: 'No learning content in this category',
                            actionLabel: 'Refresh',
                            onAction: _loadContent,
                          )
                        : RefreshIndicator(
                            onRefresh: _loadContent,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredContent.length,
                              itemBuilder: (context, index) {
                                final item = _filteredContent[index];
                                return _ContentCard(
                                  content: item,
                                  onTap: () {
                                    // TODO: Navigate to detail
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category['label']!),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category['id']!;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.green.shade100,
              checkmarkColor: Colors.green.shade700,
              labelStyle: TextStyle(
                color: isSelected ? Colors.green.shade700 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Map<String, dynamic> content;
  final VoidCallback onTap;

  const _ContentCard({
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content['duration'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${content['views']} views',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
