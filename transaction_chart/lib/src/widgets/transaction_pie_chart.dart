import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction_chart_config.dart';
import '../utils/chart_utils.dart';

class TransactionPieChart extends StatefulWidget {
  final TransactionChartConfig config;

  const TransactionPieChart({super.key, required this.config});

  @override
  State<TransactionPieChart> createState() => _TransactionPieChartState();
}

class _TransactionPieChartState extends State<TransactionPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  List<PieChartSectionData> _previousSections = [];
  List<PieChartSectionData> _currentSections = [];
  bool _showingNewData = false;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _currentSections = _buildSections(widget.config);

    if (widget.config.animate) {
      _animationController.forward();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showingNewData = false;
        });
      }
    });

    _animationController.addListener(() {
      if (_animationController.value >= 0.5 && !_showingNewData) {
        setState(() {
          _showingNewData = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(TransactionPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.data != oldWidget.config.data && widget.config.animate) {
      _previousSections = _currentSections;
      _currentSections = _buildSections(widget.config);
      _showingNewData = false;
      _animationController.reset();
      _animationController.forward();
    } else if (widget.config.data != oldWidget.config.data) {
      _currentSections = _buildSections(widget.config);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<PieChartSectionData> _buildSections(TransactionChartConfig config) {
    return config.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == _touchedIndex;

      return PieChartSectionData(
        color: ChartUtils.getColor(index), 
        value: data.percentage,
        title: '',
        radius: 10, 
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCenterLegend() {
    final dataToShow = widget.config.data;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          dataToShow.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: ChartUtils.getColor(
                        index,
                      ), 
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${data.percentage.toStringAsFixed(0)}% ${ChartUtils.truncateText(data.categoryName, 20)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTooltip(
    String categoryName,
    double percentage,
    double amount,
    String currency,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(2)}%',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '${amount.toStringAsFixed(2)} $currency',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final rotation = _rotationAnimation.value;
          final isFirstHalf = _animationController.value < 0.5;
          final opacity =
              isFirstHalf ? _fadeOutAnimation.value : _fadeInAnimation.value;
          final sectionsToShow =
              isFirstHalf || !_showingNewData
                  ? (_previousSections.isEmpty
                      ? _currentSections
                      : _previousSections)
                  : _currentSections;

          return Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: widget.config.animate ? opacity : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: sectionsToShow,
                      sectionsSpace: 2, 
                      centerSpaceRadius:
                          90, 
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex =
                                pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                          });
                        },
                        mouseCursorResolver: (
                          FlTouchEvent event,
                          pieTouchResponse,
                        ) {
                          return pieTouchResponse?.touchedSection != null
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic;
                        },
                      ),
                    ),
                  ),
                  // Легенда в центре круга
                  Container(
                    width: 160, 
                    height: 160,
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: -rotation,
                      child: _buildCenterLegend(),
                    ),
                  ),
                  
                  if (_touchedIndex >= 0 &&
                      _touchedIndex < widget.config.data.length)
                    Positioned(
                      top: 10,
                      child: Transform.rotate(
                        angle: -rotation,
                        child: _buildTooltip(
                          widget.config.data[_touchedIndex].categoryName,
                          widget.config.data[_touchedIndex].percentage,
                          widget.config.data[_touchedIndex].amount,
                          widget.config.currency,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
