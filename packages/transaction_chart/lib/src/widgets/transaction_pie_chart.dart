import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction_chart_config.dart';
import '../utils/chart_utils.dart';

/// An animated pie chart widget for displaying transaction data
class TransactionPieChart extends StatefulWidget {
  /// Current chart data to display
  final List<ChartSectionData> sections;
  
  /// Previous chart data for animation transitions
  final List<ChartSectionData>? previousSections;
  
  /// Chart configuration and styling
  final TransactionChartConfig config;
  
  /// Callback when a section is tapped
  final void Function(ChartSectionData section)? onSectionTap;

  const TransactionPieChart({
    super.key,
    required this.sections,
    this.previousSections,
    this.config = const TransactionChartConfig(),
    this.onSectionTap,
  });

  @override
  State<TransactionPieChart> createState() => _TransactionPieChartState();
}

class _TransactionPieChartState extends State<TransactionPieChart>
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  
  List<ChartSectionData> _currentSections = [];
  List<ChartSectionData> _targetSections = [];
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_animationController);
    
    _currentSections = _processChartData(widget.sections);
    _targetSections = _currentSections;
  }

  @override
  void didUpdateWidget(TransactionPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (_sectionsChanged(oldWidget.sections, widget.sections)) {
      _animateToNewData();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _sectionsChanged(List<ChartSectionData> old, List<ChartSectionData> new_) {
    if (old.length != new_.length) return true;
    for (int i = 0; i < old.length; i++) {
      if (old[i] != new_[i]) return true;
    }
    return false;
  }

  List<ChartSectionData> _processChartData(List<ChartSectionData> sections) {
    final validationError = ChartUtils.validateChartData(sections);
    if (validationError != null) {
      debugPrint('Chart validation error: $validationError');
      return [];
    }
    
    return ChartUtils.calculatePercentages(
      ChartUtils.sortSectionsByValue(sections),
    );
  }

  void _animateToNewData() {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
      _targetSections = _processChartData(widget.sections);
    });
    
    _animationController.reset();
    _animationController.forward().then((_) {
      setState(() {
        _currentSections = _targetSections;
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return _buildAnimatedChart(chartSize);
          },
        );
      },
    );
  }

  Widget _buildAnimatedChart(Size size) {
    final rotationAngle = ChartUtils.calculateRotationAngle(_rotationAnimation.value);
    final fadeProgress = ChartUtils.calculateFadeProgress(_rotationAnimation.value);
    final showOldContent = ChartUtils.shouldShowOldContent(_rotationAnimation.value);
    
    final sectionsToShow = _isAnimating && showOldContent 
        ? _currentSections 
        : _targetSections;

    return Transform.rotate(
      angle: rotationAngle,
      child: Opacity(
        opacity: _isAnimating ? fadeProgress : 1.0,
        child: widget.config.showLegend
            ? _buildChartWithLegend(sectionsToShow, size)
            : _buildChart(sectionsToShow, size),
      ),
    );
  }

  Widget _buildChartWithLegend(List<ChartSectionData> sections, Size size) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildChart(sections, size),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(sections),
        ),
      ],
    );
  }

  Widget _buildChart(List<ChartSectionData> sections, Size size) {
    if (sections.isEmpty) {
      return _buildEmptyChart();
    }

    return PieChart(
      PieChartData(
        sections: _buildPieChartSections(sections),
        centerSpaceRadius: widget.config.centerSpaceRadius,
        sectionsSpace: widget.config.sectionGap,
        pieTouchData: PieTouchData(
          enabled: widget.config.showTooltips,
          touchCallback: _handleChartTouch,
          mouseCursorResolver: (event, response) {
            return response?.touchedSection != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic;
          },
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      width: widget.config.radius * 2,
      height: widget.config.radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: const Center(
        child: Text(
          'Нет данных',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List<ChartSectionData> sections) {
    return sections.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;
      
      final color = section.customColor ?? 
          ChartUtils.getColorByIndex(widget.config.colorPalette, index);
      
      // Only show percentage text if there's more than one section
      final showTitle = sections.length > 1;
      
      return PieChartSectionData(
        value: section.value,
        color: color,
        title: showTitle ? '${section.percentage.toStringAsFixed(1)}%' : '',
        radius: widget.config.radius,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        badgeWidget: section.categoryIcon != null
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  section.categoryIcon!,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : null,
        badgePositionPercentageOffset: 0.8,
      );
    }).toList();
  }

  Widget _buildLegend(List<ChartSectionData> sections) {
    return Container(
      padding: widget.config.legendPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: sections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          
          final color = section.customColor ?? 
              ChartUtils.getColorByIndex(widget.config.colorPalette, index);
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _buildLegendItem(section, color),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(ChartSectionData section, Color color) {
    return GestureDetector(
      onTap: () => widget.onSectionTap?.call(section),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ChartUtils.truncateText(
                    section.categoryName,
                    widget.config.maxCategoryNameLength,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: widget.config.legendTextOverflow,
                ),
                Text(
                  ChartUtils.formatCurrency(section.value),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleChartTouch(FlTouchEvent event, PieTouchResponse? response) {
    if (response?.touchedSection?.touchedSectionIndex != null &&
        widget.config.showTooltips) {
      final sectionIndex = response!.touchedSection!.touchedSectionIndex;
      final sectionsToShow = _isAnimating && 
          ChartUtils.shouldShowOldContent(_rotationAnimation.value) 
              ? _currentSections 
              : _targetSections;
      
      if (sectionIndex < sectionsToShow.length) {
        final section = sectionsToShow[sectionIndex];
        
        if (event is FlTapUpEvent) {
          widget.onSectionTap?.call(section);
        }
        
        // Note: Tooltip display would be handled by fl_chart's built-in system
        // or a custom overlay implementation
      }
    }
  }
}