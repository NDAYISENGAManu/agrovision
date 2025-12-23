import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state.dart';

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends ConsumerState<ForumPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _posts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _posts = [
          {
            'id': '1',
            'title': 'Best time to plant maize in Rwanda?',
            'author': 'John Farmer',
            'content':
                'I\'m planning to plant maize next month. What\'s the best time considering the current weather patterns?',
            'category': 'Crops',
            'likes': 24,
            'comments': 8,
            'timestamp': '2 hours ago',
            'isLiked': false,
          },
          {
            'id': '2',
            'title': 'Dealing with coffee rust',
            'author': 'Maria Coffee',
            'content':
                'My coffee plants are showing signs of rust. Has anyone dealt with this before? What treatment worked?',
            'category': 'Disease',
            'likes': 15,
            'comments': 12,
            'timestamp': '5 hours ago',
            'isLiked': true,
          },
          {
            'id': '3',
            'title': 'Organic fertilizer recommendations',
            'author': 'Peter Organic',
            'content':
                'Looking for reliable organic fertilizer suppliers in Kigali. Any recommendations?',
            'category': 'Inputs',
            'likes': 31,
            'comments': 20,
            'timestamp': '1 day ago',
            'isLiked': false,
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
        title: const Text('Community Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  message: _error!,
                  onRetry: _loadPosts,
                )
              : _posts.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.forum,
                      title: 'No Posts',
                      message: 'Be the first to start a discussion',
                      actionLabel: 'Create Post',
                      onAction: () {
                        // TODO: Navigate to create post
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPosts,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return _PostCard(
                            post: post,
                            onTap: () {
                              // TODO: Navigate to post detail
                            },
                            onLike: () {
                              setState(() {
                                post['isLiked'] = !post['isLiked'];
                                post['likes'] += post['isLiked'] ? 1 : -1;
                              });
                            },
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create post
        },
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const _PostCard({
    required this.post,
    required this.onTap,
    required this.onLike,
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
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: Text(
                      post['author'][0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['author'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          post['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(
                      post['category'],
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          post['isLiked']
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          size: 20,
                          color: post['isLiked']
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post['likes'].toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: post['isLiked']
                                ? Colors.green.shade700
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post['comments'].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      // TODO: Share post
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
