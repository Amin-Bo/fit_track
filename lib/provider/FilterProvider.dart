import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterProvider with ChangeNotifier {
  // Listes des filtres sélectionnés
  List<String> _selectedBodyParts = [];
  List<String> _selectedEquipment = [];

  // Référence Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FilterProvider();

  // Getters
  List<String> get selectedBodyParts => _selectedBodyParts;
  List<String> get selectedEquipment => _selectedEquipment;
  bool get hasActiveFilters =>
      _selectedBodyParts.isNotEmpty || _selectedEquipment.isNotEmpty;

  void clearFilters() {
    _selectedBodyParts.clear();
    _selectedEquipment.clear();
    notifyListeners();
  }
}

// Modèle d'exercice
class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String imageUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.imageUrl,
  });

  factory Exercise.fromFirestore(String id, Map<String, dynamic> data) {
    return Exercise(
      id: id,
      name: data['name'] ?? '',
      bodyPart: data['bodyPart'] ?? '',
      equipment: data['equipment'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
