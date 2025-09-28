import 'package:cloud_firestore/cloud_firestore.dart';
// If files are in lib/ root
// import 'feedback_detail_screen.dart';
// import 'feedback_form_screen.dart';
// import '/repository/feedback_list_screen.dart';


class FeedbackRepository {
  // Singleton pattern for global access
  FeedbackRepository._privateConstructor();
  static final FeedbackRepository instance = FeedbackRepository._privateConstructor();

  // Reference to the "feedbacks" collection in Firestore
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('feedbacks');

  /// Adds a new feedback to Firestore with a server timestamp.
  Future<void> add(Map<String, dynamic> data) async {
    try {
      final feedbackData = {
        ...data,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _collection.add(feedbackData);
    } catch (e) {
      // Handle or log error as needed
      rethrow;
    }
  }

  /// Streams all feedback documents as a list of [FeedbackItem],
  /// ordered by timestamp descending.
  Stream<List<FeedbackItem>> streamAll() {
    return _collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FeedbackItem.fromDocument(doc);
      }).toList();
    });
  }
}

/// Model class representing a feedback item.
class FeedbackItem {
  final String id;
  final String title;
  final String message;
  final int rating;
  final DateTime timestamp;

  FeedbackItem({
    required this.id,
    required this.title,
    required this.message,
    required this.rating,
    required this.timestamp,
  });

  factory FeedbackItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackItem(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      rating: (data['rating'] is num) ? (data['rating'] as num).toInt() : 0,
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
