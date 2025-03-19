// filepath: c:\Users\aminb\Desktop\FitTrack\fit_track\lib\userScreens\FavoritesScreen.dart
import 'package:fit_track/provider/FavoritesProvide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Exercice.dart';
import 'ExerciseDetailScreen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoritesFuture = favoritesProvider.loadFavorites();

    return Scaffold(
      body: FutureBuilder<List<Exercise>>(
        future: favoritesFuture,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }
          // else
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No favorites yet!', style: TextStyle(fontSize: 18)),
            );
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final exercise = favorites[index];
                return _FavoriteExerciseCard(exercise: exercise);
              },
            );
          }
        },
      ),
    );
  }
}

class _FavoriteExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const _FavoriteExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(exercise: exercise),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  exercise.gifUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      exercise.bodyPart,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      exercise.equipment,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
