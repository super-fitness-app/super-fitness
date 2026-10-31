import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class HorizontalNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String unitLabel;
  final ValueChanged<int> onChanged;

  const HorizontalNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.unitLabel,
    required this.onChanged,
  });

  @override
  State<HorizontalNumberPicker> createState() => _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late int _selectedValue;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.clamp(
      widget.minValue,
      widget.maxValue,
    );
    final initialPage = _selectedValue - widget.minValue;
    _pageController = PageController(
      viewportFraction: 0.14,
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final newValue = widget.minValue + index;
    setState(() => _selectedValue = newValue);
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.maxValue - widget.minValue + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.unitLabel,
          style: const TextStyle(
            color: AppColors.orangeBase,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final val = widget.minValue + index;
              final isSelected = val == _selectedValue;
              return Center(
                child: Text(
                  '$val',
                  style: TextStyle(
                    color: isSelected ? AppColors.orangeBase : Colors.white60,
                    fontSize: isSelected ? 34 : 20,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        const Icon(
          Icons.arrow_drop_up,
          color: AppColors.orangeBase,
          size: 24,
        ),
      ],
    );
  }
}
