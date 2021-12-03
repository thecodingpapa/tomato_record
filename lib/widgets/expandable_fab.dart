import 'package:flutter/material.dart';
import 'dart:math';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  static const Duration duration = Duration(milliseconds: 300);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _controller;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1 : 0.0,
      duration: ExpandableFab.duration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          Container(
              height: 56,
              width: 56,
              child: Center(child: _buildTapToCloseFab())),
          _buildTapToOpenFab(),
        ]..insertAll(1, _buildExpandingActionButtons()),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0;
        i < count;
        i++, angleInDegrees += step.toInt()) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees.toDouble(),
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToCloseFab() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      duration: ExpandableFab.duration,
      curve: Curves.easeOut,
      child: FloatingActionButton(
        heroTag: 'btn1',
        onPressed: _toggle,
        mini: true,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
        duration: ExpandableFab.duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          duration: ExpandableFab.duration,
          child: FloatingActionButton(
            heroTag: 'btn2',
            onPressed: _toggle,
            child: const Icon(Icons.close),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double>? progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress!,
      builder: (BuildContext context, Widget? child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180.0),
          progress!.value * maxDistance,
        );
        return Positioned(
          right: offset.dx - 16,
          bottom: offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress!.value) * pi / 2,
            child: Container(height: 56, child: Center(child: child)),
          ),
        );
      },
      child: FadeTransition(
        opacity: progress!,
        child: child,
      ),
    );
  }
}
