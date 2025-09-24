import 'package:flutter/material.dart';

enum RotationgMenuItemState { hidden, displayed, selected }

class RotatingMenu extends StatefulWidget {
  final List<Widget> children;
  final int displayedChildren;
  final Widget separator;
  final double defaultScale;
  final double selectedScale;
  final double defaultOpacity;
  final double selectedOpacity;
  final Duration animationDuration;

  const RotatingMenu({
    super.key,
    required this.children,
    int? displayedChildren,
    this.separator = const SizedBox(width: 20),
    this.defaultScale = 1.0,
    this.selectedScale = 1.8,
    this.defaultOpacity = 0.6,
    this.selectedOpacity = 1.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : displayedChildren = displayedChildren != null && displayedChildren <= children.length ? displayedChildren : children.length;

  @override
  State<RotatingMenu> createState() => RotatingMenuState();
}

class RotatingMenuState extends State<RotatingMenu> {
  int selectedIndex = 0;

  Widget get selected => widget.children[selectedIndex];

  int _getIndexOffset(int offset) {
    return (selectedIndex + offset + widget.children.length) % widget.children.length;
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
    int leftChildren = (widget.children.length - 1) ~/ 2;
    int rightChildren = widget.children.length - 1 - leftChildren;
    int leftDisplayedChildren = (widget.displayedChildren - 1) ~/ 2;
    int rightDisplayedChildren = widget.displayedChildren - 1 - leftDisplayedChildren;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftChildren > leftDisplayedChildren)
          _buildMenuItem(_getIndexOffset(-leftDisplayedChildren - 1), RotationgMenuItemState.hidden),
        widget.separator,
        for (int i = -leftDisplayedChildren; i <= rightDisplayedChildren; i++) ...[
          _buildMenuItem(_getIndexOffset(i), i == 0 ? RotationgMenuItemState.selected : RotationgMenuItemState.displayed),
          if (i < rightDisplayedChildren) widget.separator
        ],
        widget.separator,
        if (rightChildren > rightDisplayedChildren)
          _buildMenuItem(_getIndexOffset(rightDisplayedChildren + 1), RotationgMenuItemState.hidden),
      ],
    );
  }

  Widget _buildMenuItem(int index, RotationgMenuItemState menuState) {
    final Map<RotationgMenuItemState, double> scaleByState = {
      RotationgMenuItemState.hidden: 0.0,
      RotationgMenuItemState.displayed: widget.defaultScale,
      RotationgMenuItemState.selected: widget.selectedScale,
    };
    final Map<RotationgMenuItemState, double> opacityByState = {
      RotationgMenuItemState.hidden: widget.defaultOpacity,
      RotationgMenuItemState.displayed: widget.defaultOpacity,
      RotationgMenuItemState.selected: widget.selectedOpacity,
    };
    return AnimatedScale(
      key: ValueKey("item-$index"),
      scale: scaleByState[menuState]!,
      duration: widget.animationDuration,
      child: AnimatedOpacity(
        opacity: opacityByState[menuState]!,
        duration: widget.animationDuration,
        child: widget.children[index],
      ),
    );
  }
}
