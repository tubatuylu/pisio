import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Dinamik Porsiyon Ayarlayıcı Bileşeni
class PortionStepperWidget extends StatelessWidget {
  final int currentServings;
  final ValueChanged<int> onServingsChanged;
  final int minServings;
  final int maxServings;

  const PortionStepperWidget({
    super.key,
    required this.currentServings,
    required this.onServingsChanged,
    this.minServings = 1,
    this.maxServings = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people_alt_outlined,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$currentServings Kişilik',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          // Azalt Butonu
          InkWell(
            onTap: currentServings > minServings
                ? () => onServingsChanged(currentServings - 1)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentServings > minServings
                    ? AppColors.primaryLight
                    : AppColors.borderLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.remove,
                size: 18,
                color: currentServings > minServings
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Arttır Butonu
          InkWell(
            onTap: currentServings < maxServings
                ? () => onServingsChanged(currentServings + 1)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentServings < maxServings
                    ? AppColors.primaryLight
                    : AppColors.borderLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
                size: 18,
                color: currentServings < maxServings
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
