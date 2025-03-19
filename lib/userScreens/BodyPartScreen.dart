import 'package:fit_track/service/UserService.dart';
import 'package:fit_track/userScreens/EquipmentExercisesScreen.dart';
import 'package:flutter/material.dart';

class BodyPartGrid extends StatelessWidget {
  List<String> bodyParts = [];
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: userService.fetchBodyPartsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No body parts available'));
        } else {
          bodyParts = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: bodyParts.length,
            itemBuilder: (context, index) {
              return _BodyPartCard(
                bodyPart: bodyParts[index],
                onTap:
                    () => _navigateToEquipmentExercises(
                      context,
                      bodyParts[index],
                    ),
              );
            },
          );
        }
      },
    );
  }

  void _navigateToEquipmentExercises(BuildContext context, String equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                EquipmentExercisesScreen(bodyPart: equipment, equipment: ""),
      ),
    );
  }
}

class _BodyPartCard extends StatelessWidget {
  final String bodyPart;
  final VoidCallback onTap;

  const _BodyPartCard({required this.bodyPart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: _BodyPartIllustration(bodyPart: bodyPart)),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    bodyPart.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyPartIllustration extends StatelessWidget {
  final String bodyPart;

  const _BodyPartIllustration({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    final iconMap = {
      'back': Icons.accessibility_new,
      'cardio': Icons.favorite_border,
      'chest': Icons.man,
      'lower arms': Icons.touch_app,
      'lower legs': Icons.directions_walk,
      'neck': Icons.headset,
      'shoulders': Icons.arrow_upward,
      'upper arms': Icons.fitness_center,
      'upper legs': Icons.directions_run,
      'waist': Icons.arrow_circle_down,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Icon(
            iconMap[bodyPart.toLowerCase()] ?? Icons.help_outline,
            size: constraints.maxWidth * 0.5,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
        );
      },
    );
  }
}
