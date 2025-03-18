import 'package:fit_track/model/Exercice.dart';
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
