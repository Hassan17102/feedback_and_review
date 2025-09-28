// lib/feedback_list_screen.dart
import 'package:flutter/material.dart';
import 'feedback_repository.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  FeedbackListScreenState createState() => FeedbackListScreenState();
}

class FeedbackListScreenState extends State<FeedbackListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback List')),
      body: StreamBuilder<List<FeedbackItem>>(
        stream: FeedbackRepository.instance.streamAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feedbacks = snapshot.data!;
          if (feedbacks.isEmpty) {
            return const Center(child: Text('No feedback yet'));
          }
          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              return ListTile(
                title: Text(fb.title),
                subtitle: Text(
                  'Rating: ${fb.rating} • ${fb.message}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Use the named route and pass the FeedbackItem as the argument
                  Navigator.pushNamed(context, '/feedbackDetail', arguments: fb);
                },
              );
            },
          );
        },
      ),
    );
  }
}
