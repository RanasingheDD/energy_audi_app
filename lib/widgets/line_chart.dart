import 'package:energy_app/data/line_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartCard extends StatefulWidget {
  const LineChartCard({super.key});

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<FlSpot> animatedSpots = [];
  bool isLoading = true; // State for loading
  double? minX, maxX, minY, maxY; // Dynamic bounds for chart

  final data = LineData();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Fetch data asynchronously
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await data.fetchDataAndMap(); // Fetch data and populate spots
      if (data.spots.isNotEmpty) {
        // Calculate dynamic chart bounds
        minX = data.spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
        maxX = data.spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
        minY = data.spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
        maxY = data.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

        // Initialize animation
        _animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        )..addListener(() {
            setState(() {
              // Calculate number of points to display
              final numOfPoints = (data.spots.length * _animation.value).toInt();
              animatedSpots = data.spots.take(numOfPoints).toList();
            });
          });

        _animationController.forward(); // Start animation
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Steps Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading spinner
              : AspectRatio(
                  aspectRatio: 16 / 6,
                  child: LineChart(
                 LineChartData(
  lineTouchData: const LineTouchData(handleBuiltInTouches: true),
  gridData: const FlGridData(show: true), // Show gridlines for debugging
  titlesData: FlTitlesData(
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
       interval: ((maxX ?? 120) - (minX ?? 0.1)) / 10 > 0
    ? ((maxX ?? 120) - (minX ?? 0.1)) / 10
    : 1, // Ensure interval is at least 1
 // Dynamic interval
        getTitlesWidget: (value, meta) {
          return data.bottomTitle.containsKey(value.toInt())
              ? SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    data.bottomTitle[value.toInt()]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                )
              : Text(value.toStringAsFixed(1), // Default label
                  style: TextStyle(fontSize: 10, color: Colors.grey[300]));
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: ((maxX ?? 120) - (minX ?? 0.1)) / 10 > 0
    ? ((maxX ?? 120) - (minX ?? 0.1)) / 10
    : 1, // Ensure interval is at least 1
 // Dynamic interval
        getTitlesWidget: (value, meta) {
          return data.leftTitle.containsKey(value.toInt())
              ? Text(
                  data.leftTitle[value.toInt()]!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                )
              : Text(value.toStringAsFixed(1), // Default label
                  style: TextStyle(fontSize: 10, color: Colors.grey[300]));
        },
      ),
    ),
  ),
  borderData: FlBorderData(
    show: true,
    border: Border.all(color: const Color(0xff37434d), width: 1),
  ),
  lineBarsData: [
    LineChartBarData(
      color: Colors.white,
      barWidth: 2.5,
      belowBarData: BarAreaData(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
        show: true,
      ),
      dotData: const FlDotData(show: false),
      spots: animatedSpots,
    ),
  ],
  minX: minX ?? 0,
  maxX: maxX ?? 120,
  minY: minY ?? -5,
  maxY: maxY ?? 105,
)

                  ),
                ),
        ],
      ),
    );
  }
}
