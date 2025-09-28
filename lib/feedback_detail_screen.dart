import 'package:flutter/material.dart';
import 'feedback_repository.dart';

class FeedbackDetailScreen extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackDetailScreen({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedback.title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Rating: ${feedback.rating}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(feedback.message,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text('Submitted: ${feedback.createdAt.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
