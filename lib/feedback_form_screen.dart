import 'package:flutter/material.dart';
import 'feedback_repository.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  FeedbackFormScreenState createState() => FeedbackFormScreenState();
}

class FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  double _rating = 5.0;
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (form.validate()) {
      form.save();
      setState(() => _isLoading = true);
      try {
        await FeedbackRepository.instance.add(
          title: _title,
          message: _message,
          rating: _rating,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully')),
        );

        form.reset();
        setState(() => _rating = 5.0);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _title = value?.trim() ?? '',
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              spacing,
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onSaved: (value) => _message = value?.trim() ?? '',
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Please enter a message'
                    : null,
              ),
              spacing,
              DropdownButtonFormField<double>(
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                ),
                value: _rating,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _rating = value);
                  }
                },
                items: [1, 2, 3, 4, 5]
                    .map((level) => DropdownMenuItem<double>(
                  value: level.toDouble(),
                  child: Text(level.toString(),
                      style: Theme.of(context).textTheme.bodyMedium),
                ))
                    .toList(),
              ),
              spacing,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Submit', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
