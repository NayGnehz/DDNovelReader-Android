import 'package:flutter/material.dart';

/// One navigation action per completed swipe. Short drags and cancelled
/// gestures do nothing; the dominant axis decides diagonal gestures.
class ReaderGestures extends StatefulWidget {
  const ReaderGestures({
    super.key,
    required this.child,
    required this.onPreviousSentence,
    required this.onNextSentence,
    required this.onPreviousPage,
    required this.onNextPage,
    this.onTapUp,
  });

  final Widget child;
  final VoidCallback onPreviousSentence;
  final VoidCallback onNextSentence;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final GestureTapUpCallback? onTapUp;

  @override
  State<ReaderGestures> createState() => _ReaderGesturesState();
}

class _ReaderGesturesState extends State<ReaderGestures> {
  Offset _distance = Offset.zero;
  static const double _threshold = 48;

  void _finish(DragEndDetails details) {
    final delta = _distance;
    _distance = Offset.zero;
    if (delta.dx.abs() > delta.dy.abs()) {
      if (delta.dx.abs() < _threshold) return;
      if (delta.dx < 0) {
        widget.onNextPage();
      } else {
        widget.onPreviousPage();
      }
    } else {
      if (delta.dy.abs() < _threshold) return;
      if (delta.dy < 0) {
        widget.onPreviousSentence();
      } else {
        widget.onNextSentence();
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: widget.onTapUp,
        onPanDown: (_) => _distance = Offset.zero,
        onPanUpdate: (details) => _distance += details.delta,
        onPanEnd: _finish,
        onPanCancel: () => _distance = Offset.zero,
        child: widget.child,
      );
}
