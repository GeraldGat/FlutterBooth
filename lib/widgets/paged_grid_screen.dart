import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/config/extensions/app_config_icon_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';

class _ActionItem {
  final bool isEnabled;
  final VoidCallback callback;

  const _ActionItem({required this.isEnabled, required this.callback});
}

class PagedGridScreen extends ConsumerStatefulWidget {
  final int totalItemCount;
  final Widget Function(AppConfig config, int index) itemContentBuilder;
  final Widget Function(AppConfig config) backgroundBuilder;
  final Future<void> Function(int index) onItemSelected;
  final void Function(int index)? onItemDoubleTap;

  const PagedGridScreen({
    super.key,
    required this.totalItemCount,
    required this.itemContentBuilder,
    required this.backgroundBuilder,
    required this.onItemSelected,
    this.onItemDoubleTap,
  });

  @override
  ConsumerState<PagedGridScreen> createState() => _PagedGridScreenState();
}

class _PagedGridScreenState extends ConsumerState<PagedGridScreen> {
  int currentPage = 0;
  int selectedIndex = 1;

  int get pageItemCount {
    final start = currentPage * 4;
    final end = (start + 4).clamp(0, widget.totalItemCount);
    return end - start;
  }

  List<_ActionItem> get actionList {
    final count = pageItemCount;
    return [
      _ActionItem(isEnabled: currentPage > 0, callback: _previousPage),
      _ActionItem(isEnabled: count > 0, callback: _performSelectedAction),
      _ActionItem(isEnabled: count > 1, callback: _performSelectedAction),
      _ActionItem(isEnabled: count > 2, callback: _performSelectedAction),
      _ActionItem(isEnabled: count > 3, callback: _performSelectedAction),
      _ActionItem(isEnabled: (currentPage + 1) * 4 < widget.totalItemCount, callback: _nextPage),
      _ActionItem(isEnabled: true, callback: _closeScreen),
    ];
  }

  void _previousPage() {
    setState(() { currentPage--; });
  }

  void _nextPage() {
    setState(() { currentPage++; });
  }

  void _closeScreen() {
    if (mounted) Navigator.of(context).pop();
  }

  void _performSelectedAction() {
    final index = currentPage * 4 + (selectedIndex - 1);
    widget.onItemSelected(index);
  }

  int _getNextAvailableIndex(int step) {
    int nextIndex = selectedIndex;

    for (int i = 0; i < actionList.length; i++) {
      nextIndex = (nextIndex + step + actionList.length) % actionList.length;
      if (actionList[nextIndex].isEnabled) {
        return nextIndex;
      }
    }

    return selectedIndex;
  }

  void _handlePrev() {
    setState(() => selectedIndex = _getNextAvailableIndex(-1));
  }

  void _handleNext() {
    setState(() => selectedIndex = _getNextAvailableIndex(1));
  }

  void _handleEnter() {
    final action = actionList[selectedIndex];
    if (action.isEnabled) {
      action.callback();
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.totalItemCount > 0 ? 1 : 6;
  }

  @override
  void didUpdateWidget(PagedGridScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalItemCount != oldWidget.totalItemCount) {
      currentPage = 0;
      selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    final screenSize = MediaQuery.of(context).size;
    final availableWidth = screenSize.width - (96 + 10) * 2;
    final availableHeight = screenSize.height * 0.9;
    double imageHeight = (availableHeight - spacing) / 2;
    double imageWidth = imageHeight * 3 / 2;

    if (availableWidth < (imageWidth * 2 + spacing)) {
      imageWidth = (availableWidth - spacing) / 2;
      imageHeight = imageWidth * 2 / 3;
    }

    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) => FbKeyboardActions(
        onPrevious: _handlePrev,
        onNext: _handleNext,
        onConfirm: _handleEnter,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              widget.backgroundBuilder(config),

              if (actionList[0].isEnabled)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: _previousPage,
                      icon: config.prevIcon(
                        width: 96,
                        height: 96,
                        colorFilter:
                            ColorFilter.mode(selectedIndex == 0 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),

              Center(
                child: SizedBox(
                  width: imageWidth * 2 + spacing,
                  height: imageHeight * 2 + spacing,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: pageItemCount,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index + 1),
                        onDoubleTap: widget.onItemDoubleTap != null
                            ? () => widget.onItemDoubleTap!(currentPage * 4 + index)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? config.mainColor
                                  : Colors.transparent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: widget.itemContentBuilder(config, currentPage * 4 + index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (actionList[5].isEnabled)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: _nextPage,
                      icon: config.nextIcon(
                        width: 96,
                        height: 96,
                        colorFilter:
                            ColorFilter.mode(selectedIndex == 5 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: _closeScreen,
                  icon: config.closeIcon(
                    width: 96,
                    height: 96,
                    colorFilter:
                        ColorFilter.mode(selectedIndex == 6 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading config: $error')),
      ),
    );
  }
}
