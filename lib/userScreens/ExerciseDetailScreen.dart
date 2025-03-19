import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_track/model/Exercice.dart';
import 'package:fit_track/provider/FavoritesProvide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: _buildHeroHeader(theme),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    favoritesProvider.isFavorite(exercise.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    key: ValueKey(favoritesProvider.isFavorite(exercise.id)),
                    color: theme.colorScheme.secondary,
                    size: 30,
                  ),
                ),
                onPressed: () => favoritesProvider.toggleFavorite(exercise),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTitleSection(theme),
                SizedBox(height: 32),
                _buildBodyGrid(theme),
                SizedBox(height: 40),
                _buildMuscleSection(theme),
                SizedBox(height: 32),
                _buildInstructionsSection(theme),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        child: Icon(
          favoritesProvider.isFavorite(exercise.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: theme.colorScheme.onSecondary,
        ),
        onPressed: () => favoritesProvider.toggleFavorite(exercise),
      ),
    );
  }

  Widget _buildHeroHeader(ThemeData theme) {
    return Stack(
      children: [
        Center(
          child: Image.network(
            exercise.gifUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                theme.scaffoldBackgroundColor.withOpacity(0.9),
                theme.scaffoldBackgroundColor.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onBackground,
            shadows: [
              Shadow(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildInfoChip(
              icon: Icons.fitness_center,
              label: exercise.equipment,
              theme: theme,
            ),
            _buildInfoChip(
              icon: Icons.accessibility_new,
              label: exercise.bodyPart,
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withOpacity(0.4),
            theme.colorScheme.surface.withOpacity(0.1),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.secondary),
          SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyGrid(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface.withOpacity(0.1),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.1)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDataPoint(
              label: 'PRIMARY MUSCLE',
              value: exercise.target,
              theme: theme,
            ),
            VerticalDivider(
              color: theme.colorScheme.secondary.withOpacity(0.2),
            ),
            _buildDataPoint(
              label: 'DIFFICULTY',
              value: 'Intermediate',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPoint({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            letterSpacing: 1.2,
            color: theme.colorScheme.secondary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENGAGED MUSCLES',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildMuscleTag(exercise.target, isPrimary: true, theme: theme),
            ...exercise.secondaryMuscles.map(
              (m) => _buildMuscleTag(m, theme: theme),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMuscleTag(
    String muscle, {
    bool isPrimary = false,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors:
              isPrimary
                  ? [
                    theme.colorScheme.secondary.withOpacity(0.8),
                    theme.colorScheme.primary.withOpacity(0.8),
                  ]
                  : [
                    theme.colorScheme.surface.withOpacity(0.4),
                    theme.colorScheme.surface.withOpacity(0.1),
                  ],
        ),
        boxShadow: [
          if (isPrimary)
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Text(
        muscle,
        style: theme.textTheme.bodyLarge?.copyWith(
          color:
              isPrimary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInstructionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXECUTION GUIDE',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 24),
        ...exercise.instructions.asMap().entries.map(
          (entry) => _buildInstructionStep(
            step: entry.key + 1,
            text: entry.value,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep({
    required int step,
    required String text,
    required ThemeData theme,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface.withOpacity(0.05),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.secondary.withOpacity(0.8),
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
