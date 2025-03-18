import 'package:fit_track/model/Exercice.dart';

class ExerciseCategory {
  final String bodyPart;
  final List<Exercise> exercises;

  ExerciseCategory({required this.bodyPart, required this.exercises});

  static Future<List<ExerciseCategory>> fromString(category) {
    return Future.value([
      ExerciseCategory(
        bodyPart: category['bodyPart'],
        exercises:
            category['exercises']
                .map<Exercise>(
                  (exercise) => Exercise(
                    id: exercise['id'],
                    name: exercise['name'],
                    equipment: exercise['equipment'],
                    gifUrl: exercise['gifUrl'],
                    bodyPart: exercise['bodyPart'],
                    target: exercise['target'],
                  ),
                )
                .toList(),
      ),
    ]);
  }
}
