import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FirebaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new user document in Firestore with full name, email, and initial score = 0
  static Future<void> createUserData(
      String uid, String email, String firstName, String lastName) async {
    await _firestore.collection('users').doc(uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'score': 0,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Updates the user score in Firestore
  static Future<void> updateUserScore(String uid, int score) async {
    await _firestore.collection('users').doc(uid).update({
      'score': score,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Fetches the user score from Firestore
  static Future<int> getUserScore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null && doc.data()!['score'] is int) {
      return doc.data()!['score'] as int;
    }
    return 0;
  }

  /// Syncs the user score if online (placeholder for any additional logic)
  static Future<void> syncScore(String uid) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      // You can implement additional logic here if needed
      // For example, syncing local score to Firestore
    }
  }

  /// Fetches user profile data
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data();
    }
    return null;
  }
}
