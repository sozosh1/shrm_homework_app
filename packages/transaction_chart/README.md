# Transaction Chart Package

A Flutter package for displaying animated transaction pie charts with sophisticated animation effects.

## Features

- **Advanced Animation**: 360-degree rotation with fade out/in effects at 180-degree transition point
- **Interactive Elements**: Touch support with section tap callbacks
- **Custom Tooltips**: Displays values rounded to 2 decimal places
- **Text Overflow Handling**: Automatic ellipsis for long category names
- **Responsive Design**: Adapts to different screen sizes
- **Customizable Appearance**: Color palettes, fonts, and styling options

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  transaction_chart:
    path: packages/transaction_chart
```

## Usage

```dart
import 'package:transaction_chart/transaction_chart.dart';

// Create chart data
final chartData = [
  ChartSectionData(
    categoryName: 'Food',
    value: 300.50,
    percentage: 50.0,
    categoryIcon: '🍔',
  ),
  ChartSectionData(
    categoryName: 'Transport',
    value: 200.25,
    percentage: 33.3,
    categoryIcon: '🚗',
  ),
];

// Display the chart
TransactionPieChart(
  sections: chartData,
  config: TransactionChartConfig(
    showLegend: true,
    showTooltips: true,
    animationDuration: Duration(milliseconds: 1000),
  ),
  onSectionTap: (section) {
    print('Tapped: ${section.categoryName}');
  },
)
```

## Configuration Options

The `TransactionChartConfig` class provides extensive customization:

- `radius`: Chart radius (default: 100.0)
- `centerSpaceRadius`: Center space radius (default: 40.0)
- `animationDuration`: Animation duration (default: 1000ms)
- `showLegend`: Show/hide legend (default: true)
- `showTooltips`: Enable tooltips (default: true)
- `maxCategoryNameLength`: Max characters before ellipsis (default: 20)
- `colorPalette`: Custom color scheme

## Animation Behavior

The chart features a sophisticated animation system:

1. **0-180 degrees**: Old content rotates and fades out
2. **180 degrees**: Transition point - old content disappears, new content appears
3. **180-360 degrees**: New content rotates and fades in
4. **360 degrees**: Animation completes with new data fully visible

## License

This package is part of the SHRM homework app project.