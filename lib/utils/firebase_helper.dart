import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Insert
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

  /// Fetches data
  static Future<int> getUserScore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null && doc.data()!['score'] is int) {
      return doc.data()!['score'] as int;
    }
    return 0;
  }

  /// Update user score
  static Future<void> updateUserScore(String uid, int sessionScore) async {
    final userDoc = _firestore.collection('users').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      if (!snapshot.exists) {
        transaction.set(userDoc, {
          'score': sessionScore,
          'updated_at': FieldValue.serverTimestamp(),
        });
      } else {
        final currentScore = snapshot.get('score') ?? 0;
        transaction.update(userDoc, {
          'score': currentScore + sessionScore,
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Sync score with online/offline
  static Future<void> syncScore(String uid, int sessionScore) async {
    final connectivity = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();

    if (connectivity != ConnectivityResult.none) {
      // Online: fetch localScore
      final localScore = prefs.getInt('local_score') ?? 0;

      if (localScore > 0) {
        final userDoc = _firestore.collection('users').doc(uid);
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(userDoc);
          if (!snapshot.exists) {
            transaction.set(userDoc, {
              'score': localScore,
              'updated_at': FieldValue.serverTimestamp(),
            });
          } else {
            final currentScore = snapshot.get('score') ?? 0;
            transaction.update(userDoc, {
              'score': currentScore + localScore,
              'updated_at': FieldValue.serverTimestamp(),
            });
          }
        });

        // Clear
        await prefs.setInt('local_score', 0);
      }
    } else {
      // Offline sync later
      final storedScore = prefs.getInt('local_score') ?? 0;
      await prefs.setInt('local_score', storedScore + sessionScore);
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
