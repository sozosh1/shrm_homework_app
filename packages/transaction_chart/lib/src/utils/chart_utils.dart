import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/transaction_chart_config.dart';

/// Utility functions for chart data processing and calculations
class ChartUtils {
  /// Calculates percentages for chart sections from raw values
  static List<ChartSectionData> calculatePercentages(
    List<ChartSectionData> sections,
  ) {
    if (sections.isEmpty) return [];

    final totalValue = sections.fold<double>(
      0,
      (sum, section) => sum + section.value,
    );

    if (totalValue == 0) return sections;

    return sections.map((section) {
      final percentage = (section.value / totalValue) * 100;
      return ChartSectionData(
        categoryName: section.categoryName,
        value: section.value,
        percentage: percentage,
        categoryIcon: section.categoryIcon,
        customColor: section.customColor,
      );
    }).toList();
  }

  /// Formats a currency value to 2 decimal places
  static String formatCurrency(double value, {String symbol = '₽'}) {
    return '${value.toStringAsFixed(2)} $symbol';
  }

  /// Formats a percentage to 1 decimal place
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Truncates text with ellipsis if it exceeds maxLength
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Gets a color from the palette by index with cycling
  static Color getColorByIndex(List<Color> palette, int index) {
    if (palette.isEmpty) return Colors.grey;
    return palette[index % palette.length];
  }

  /// Calculates the center point for rotation animation
  static Offset calculateChartCenter(Size size) {
    return Offset(size.width / 2, size.height / 2);
  }

  /// Calculates animation progress for fade effects
  /// Returns fade out progress (1.0 to 0.0) for first half (0.0 to 0.5)
  /// Returns fade in progress (0.0 to 1.0) for second half (0.5 to 1.0)
  static double calculateFadeProgress(double animationValue) {
    if (animationValue <= 0.5) {
      // First half: fade out (1.0 -> 0.0)
      return 1.0 - (animationValue * 2);
    } else {
      // Second half: fade in (0.0 -> 1.0)
      return (animationValue - 0.5) * 2;
    }
  }

  /// Calculates rotation angle in radians for the animation
  /// Returns 0 to 2π (full rotation)
  static double calculateRotationAngle(double animationValue) {
    return animationValue * 2 * math.pi;
  }

  /// Determines if we should show old content (first half) or new content (second half)
  static bool shouldShowOldContent(double animationValue) {
    return animationValue <= 0.5;
  }

  /// Sorts chart sections by value in descending order
  static List<ChartSectionData> sortSectionsByValue(
    List<ChartSectionData> sections,
  ) {
    final sortedSections = List<ChartSectionData>.from(sections);
    sortedSections.sort((a, b) => b.value.compareTo(a.value));
    return sortedSections;
  }

  /// Validates chart data and returns error message if invalid
  static String? validateChartData(List<ChartSectionData> sections) {
    if (sections.isEmpty) {
      return 'Chart sections cannot be empty';
    }

    for (final section in sections) {
      if (section.value < 0) {
        return 'Chart values cannot be negative';
      }
      if (section.categoryName.isEmpty) {
        return 'Category names cannot be empty';
      }
    }

    final totalValue = sections.fold<double>(
      0,
      (sum, section) => sum + section.value,
    );

    if (totalValue == 0) {
      return 'Total value cannot be zero';
    }

    return null; // No errors
  }

  /// Creates a custom tooltip widget
  static Widget buildTooltipWidget(
    ChartSectionData section,
    TransactionChartConfig config,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.tooltipBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            truncateText(section.categoryName, config.maxCategoryNameLength),
            style: config.tooltipTextStyle ?? 
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(section.value),
            style: config.tooltipTextStyle?.copyWith(
              fontWeight: FontWeight.normal,
            ) ?? 
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
          ),
          Text(
            formatPercentage(section.percentage),
            style: config.tooltipTextStyle?.copyWith(
              fontWeight: FontWeight.normal,
            ) ?? 
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}