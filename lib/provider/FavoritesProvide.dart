// filepath: c:\Users\aminb\Desktop\FitTrack\fit_track\lib\provider\FavoritesProvider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_track/model/Exercice.dart';
import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Exercise> _favorites = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoritesProvider();

  bool isFavorite(String exerciseId) {
    return _favorites.any((ex) => ex.id == exerciseId);
  }

  Future<void> toggleFavorite(Exercise exercise) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (isFavorite(exercise.id)) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(exercise.id)
          .delete();
      _favorites.removeWhere((ex) => ex.id == exercise.id);
    } else {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(exercise.id)
          .set(exercise.toMap());
      _favorites.add(exercise);
    }
    notifyListeners();
  }

  Future<List<Exercise>> loadFavorites() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .get();
    _favorites.clear();
    _favorites.addAll(
      snapshot.docs.map((doc) => Exercise.fromFirestore(doc.data(), doc.id)),
    );
    notifyListeners();
    return _favorites;
  }
}
