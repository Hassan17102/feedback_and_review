import 'package:flutter/material.dart';
class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // Dummy metrics (replace with real calculations later)
    final totalFeedback = 124;
    final averageRating = 4.2;
    final positivePercent = 78;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _MetricCard(title: 'Total', value: totalFeedback.toString()),
                  const SizedBox(width: 12),
                  _MetricCard(
                    title: 'Avg Rating',
                    value: averageRating.toStringAsFixed(1),
                  ),
                  const SizedBox(width: 12),
                  _MetricCard(title: 'Positive %', value: '$positivePercent%'),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trend (last 7 days)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      // Simple placeholder "chart" using LinearProgressIndicator rows
                      _miniBarRow('Day 1', 0.6),
                      _miniBarRow('Day 2', 0.75),
                      _miniBarRow('Day 3', 0.45),
                      _miniBarRow('Day 4', 0.9),
                      _miniBarRow('Day 5', 0.5),
                      _miniBarRow('Day 6', 0.7),
                      _miniBarRow('Day 7', 0.8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: Text(
                    'Replace these placeholders with real charts (e.g. charts_flutter) and Firestore queries.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export CSV (placeholder)')),
        ),
        child: const Icon(Icons.file_download),
      ),
    );
  }

  Widget _miniBarRow(String label, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.white12,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(pct * 100).round()}%',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  const _MetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
