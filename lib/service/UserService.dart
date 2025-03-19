// filepath: c:\Users\aminb\Desktop\FitTrack\fit_track\lib\service\UserService.dart
import 'dart:convert';
import 'package:fit_track/model/Exercice.dart';
import 'package:fit_track/model/ExerciseCategory.dart';
import 'package:fit_track/provider/FilterProvider.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl = 'https://exercisedb.p.rapidapi.com/exercises';

  final headers = {
    "x-rapidapi-key": "98f769d21emsh4114ce34c44b4ebp1d2573jsne2e1944b1dde",
    "x-rapidapi-host": "exercisedb.p.rapidapi.com",
  };
  Future<List<String>> fetchBodyPartsList() async {
    final response = await http.get(
      Uri.parse('$apiUrl/bodyPartList'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load exercise categories');
    }
  }

  Future<List<String>> fetchEquipmentsList() async {
    final response = await http.get(
      Uri.parse('$apiUrl/equipmentList'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load exercise categories');
    }
  }

  Future<List<Exercise>> getExercisesByEquipment({
    required String equipment,
  }) async {
    final response = await http.get(
      Uri.parse('$apiUrl/equipment/$equipment?limit=20&offset=0'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Exercise> exercises =
          data
              .map(
                (exercise) => Exercise.fromFirestore(
                  exercise as Map<String, dynamic>,
                  "",
                ),
              )
              .toList();
      return exercises;
    } else {
      throw Exception('Failed to load exercises by equipment');
    }
  }

  Future<List<Exercise>> getExercisesByBodyPart({
    required String bodyPart,
  }) async {
    final response = await http.get(
      Uri.parse('$apiUrl/bodyPart/$bodyPart?limit=20&offset=0'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Exercise> exercises =
          data
              .map(
                (exercise) => Exercise.fromFirestore(
                  exercise as Map<String, dynamic>,
                  "",
                ),
              )
              .toList();
      return exercises;
    } else {
      throw Exception('Failed to load exercises by equipment');
    }
  }
}
