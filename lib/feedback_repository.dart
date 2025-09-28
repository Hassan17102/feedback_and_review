import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a feedback item stored in Firestore.
class FeedbackItem {
  final String id;
  final String title;
  final String message;
  final double rating;
  final DateTime createdAt;

  FeedbackItem({
    required this.id,
    required this.title,
    required this.message,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FeedbackItem.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document ${doc.id} contains no data');
    }

    // Handle Firestore timestamp conversion
    DateTime created;
    final ts = data['createdAt'];
    if (ts is Timestamp) {
      created = ts.toDate();
    } else if (ts is String) {
      created = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      created = DateTime.now();
    }

    final rawRating = data['rating'];
    final rating = (rawRating is int)
        ? rawRating.toDouble()
        : (rawRating as double?) ?? 0.0;

    return FeedbackItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      rating: rating,
      createdAt: created,
    );
  }
}

/// Firestore-backed repository (singleton)
class FeedbackRepository {
  FeedbackRepository._private();
  static final FeedbackRepository instance = FeedbackRepository._private();

  static const String _collection = 'feedbacks';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Listen to all feedback in real-time
  Stream<List<FeedbackItem>> streamAll() {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) =>
        FeedbackItem.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>))
        .toList());
  }

  /// Add a new feedback
  Future<String> add({
    required String title,
    required String message,
    required double rating,
  }) async {
    final docRef = await _db.collection(_collection).add({
      'title': title,
      'message': message,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Update existing feedback
  Future<void> update({
    required String id,
    String? title,
    String? message,
    double? rating,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (message != null) data['message'] = message;
    if (rating != null) data['rating'] = rating;
    if (data.isEmpty) return;

    data['createdAt'] = FieldValue.serverTimestamp(); // keep list order updated
    await _db.collection(_collection).doc(id).update(data);
  }

  /// Delete a feedback by ID
  Future<void> delete(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  /// Get one feedback by ID
  Future<FeedbackItem?> getById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return FeedbackItem.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
  }
}
