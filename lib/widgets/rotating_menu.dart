import 'package:flutter/material.dart';

enum RotatingMenuItemState { hidden, displayed, selected }

class RotatingMenuItem {
  final Widget child;
  final VoidCallback? onPressed;

  const RotatingMenuItem({
    required this.child,
    this.onPressed,
  });
}

class RotatingMenu extends StatefulWidget {
  final List<RotatingMenuItem> items;
  final int displayedChildren;
  final Widget separator;
  final double defaultScale;
  final double selectedScale;
  final double defaultOpacity;
  final double selectedOpacity;
  final Duration animationDuration;

  const RotatingMenu({
    super.key,
    required this.items,
    int? displayedChildren,
    this.separator = const SizedBox(width: 20),
    this.defaultScale = 1.0,
    this.selectedScale = 1.8,
    this.defaultOpacity = 0.6,
    this.selectedOpacity = 1.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : displayedChildren = displayedChildren != null && displayedChildren <= items.length ? displayedChildren : items.length;

  @override
  State<RotatingMenu> createState() => RotatingMenuState();
}

class RotatingMenuState extends State<RotatingMenu> {
  int selectedIndex = 0;

  VoidCallback? get selectedCallback => widget.items[selectedIndex].onPressed;

  int _getIndexOffset(int offset) {
    return (selectedIndex + offset + widget.items.length) % widget.items.length;
  }

  void movePrevious() {
    setState(() {
      selectedIndex = _getIndexOffset(-1);
    });
  }

  void moveNext() {
    setState(() {
      selectedIndex = _getIndexOffset(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    int leftChildren = (widget.items.length - 1) ~/ 2;
    int rightChildren = widget.items.length - 1 - leftChildren;
    int leftDisplayedChildren = (widget.displayedChildren - 1) ~/ 2;
    int rightDisplayedChildren = widget.displayedChildren - 1 - leftDisplayedChildren;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftChildren > leftDisplayedChildren)
          _buildMenuItem(_getIndexOffset(-leftDisplayedChildren - 1), RotatingMenuItemState.hidden),
        widget.separator,
        for (int i = -leftDisplayedChildren; i <= rightDisplayedChildren; i++) ...[
          _buildMenuItem(_getIndexOffset(i), i == 0 ? RotatingMenuItemState.selected : RotatingMenuItemState.displayed),
          if (i < rightDisplayedChildren) widget.separator
        ],
        widget.separator,
        if (rightChildren > rightDisplayedChildren)
          _buildMenuItem(_getIndexOffset(rightDisplayedChildren + 1), RotatingMenuItemState.hidden),
      ],
    );
  }

  Widget _buildMenuItem(int index, RotatingMenuItemState menuState) {
    final Map<RotatingMenuItemState, double> scaleByState = {
      RotatingMenuItemState.hidden: 0.0,
      RotatingMenuItemState.displayed: widget.defaultScale,
      RotatingMenuItemState.selected: widget.selectedScale,
    };
    final Map<RotatingMenuItemState, double> opacityByState = {
      RotatingMenuItemState.hidden: widget.defaultOpacity,
      RotatingMenuItemState.displayed: widget.defaultOpacity,
      RotatingMenuItemState.selected: widget.selectedOpacity,
    };
    return AnimatedScale(
      key: ValueKey("item-$index"),
      scale: scaleByState[menuState]!,
      duration: widget.animationDuration,
      child: AnimatedOpacity(
        opacity: opacityByState[menuState]!,
        duration: widget.animationDuration,
        child: widget.items[index].child,
      ),
    );
  }
}
