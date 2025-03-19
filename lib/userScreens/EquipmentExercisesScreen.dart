import 'package:fit_track/model/Exercice.dart';
import 'package:fit_track/provider/FilterProvider.dart';
import 'package:fit_track/service/UserService.dart';
import 'package:fit_track/userScreens/ExerciseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipmentExercisesScreen extends StatelessWidget {
  final String equipment;
  final String bodyPart;

  const EquipmentExercisesScreen({
    required this.equipment,
    required this.bodyPart,
  });

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final UserService userService = UserService();

    return Scaffold(
      appBar: AppBar(title: Text('Exercices avec $equipment')),
      body: FutureBuilder<List<Exercise>>(
        future:
            equipment != ""
                ? userService.getExercisesByEquipment(equipment: equipment)
                : userService.getExercisesByBodyPart(bodyPart: bodyPart),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun exercice trouvé'));
          }

          final exercises = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return _ExerciseListItem(exercise: exercises[index]);
            },
          );
        },
      ),
    );
  }
}

class _ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseListItem({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.network(
          exercise.gifUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(exercise.name),
        subtitle: Text(exercise.bodyPart),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(exercise: exercise),
            ),
          );
        },
      ),
    );
  }
}
