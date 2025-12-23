import 'package:flutter/material.dart';

/// Reusable loading widget with shimmer effect
class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF2D6A4F),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer loading placeholder for lists
class ShimmerLoading extends StatefulWidget {
  final int itemCount;
  final double itemHeight;
  
  const ShimmerLoading({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: widget.itemCount,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Container(
              height: widget.itemHeight,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment(_animation.value, 0),
                  end: Alignment(_animation.value + 1, 0),
                  colors: const [
                    Color(0xFFEEEEEE),
                    Color(0xFFE0E0E0),
                    Color(0xFFEEEEEE),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: LoadingWidget(message: loadingMessage),
          ),
      ],
    );
  }
}
