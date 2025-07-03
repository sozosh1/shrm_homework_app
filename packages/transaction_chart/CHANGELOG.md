# Changelog

## [1.0.0] - 2024-01-XX

### Added
- Initial release of the Transaction Chart package
- `TransactionPieChart` widget with advanced animation system
- `TransactionChartConfig` for comprehensive customization
- `ChartUtils` with helper functions for data processing and formatting
- Sophisticated 360-degree rotation animation with 180-degree transition point
- Custom tooltips with values rounded to 2 decimal places
- Text overflow handling with ellipsis for long category names
- Interactive section tap callbacks
- Legend display with color indicators and category icons
- Support for emoji category icons as chart badges
- Responsive design that adapts to different screen sizes
- Comprehensive test suite with widget and unit tests
- Example application demonstrating all features

### Features
- **Advanced Animation System**: 
  - Clockwise rotation around chart center
  - Fade out effect (0-180 degrees) for old content
  - Fade in effect (180-360 degrees) for new content
  - Seamless data transition at 180-degree point
  - Legend rotates with chart during animation

- **Visual Enhancements**:
  - 10-color default palette with custom color support
  - Professional tooltip styling with shadows
  - Text shadows for percentage labels
  - Configurable chart dimensions and spacing
  - Empty state handling with user-friendly message

- **Data Processing**:
  - Automatic percentage calculation
  - Data validation with error handling
  - Sorting by value for better visual hierarchy
  - Currency formatting with 2 decimal precision
  - Percentage formatting with 1 decimal precision

- **Customization Options**:
  - Chart radius and center space configuration
  - Animation duration and curve customization
  - Color palette and styling options
  - Text overflow and truncation settings
  - Legend and tooltip visibility controls

### Dependencies
- flutter: SDK
- fl_chart: ^0.69.0

### Supported Platforms
- iOS
- Android
- Web
- macOS
- Windows
- Linux