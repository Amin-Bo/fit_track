import 'package:fit_track/userScreens/BodyPartScreen.dart';
import 'package:fit_track/userScreens/EquipmentScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseSearchSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Exercises'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChoiceHeader(),
            SizedBox(height: 30),
            _buildSelectionCards(context),
            SizedBox(height: 30),
            _buildSelectedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceHeader() {
    return Column(
      children: [
        Text(
          'How would you like to search?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Select your preferred search method',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSelectionCards(BuildContext context) {
    final searchProvider = Provider.of<ExerciseSearchProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 600 ? 300.0 : double.infinity;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SearchModeCard(
              width: cardWidth,
              title: 'By Body Part',
              icon: Icons.accessibility_new,
              isSelected: searchProvider.searchMode == SearchMode.bodyPart,
              onTap: () => searchProvider.setSearchMode(SearchMode.bodyPart),
            ),
            _SearchModeCard(
              width: cardWidth,
              title: 'By Equipment',
              icon: Icons.fitness_center,
              isSelected: searchProvider.searchMode == SearchMode.equipment,
              onTap: () => searchProvider.setSearchMode(SearchMode.equipment),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedContent() {
    return Expanded(
      child: Consumer<ExerciseSearchProvider>(
        builder: (context, provider, _) {
          if (provider.searchMode == SearchMode.bodyPart) {
            return BodyPartGrid();
          } else {
            return EquipmentList();
          }
        },
      ),
    );
  }
}

class _SearchModeCard extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchModeCard({
    required this.width,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

// Provider
enum SearchMode { bodyPart, equipment }

class ExerciseSearchProvider with ChangeNotifier {
  SearchMode _searchMode = SearchMode.bodyPart;

  SearchMode get searchMode => _searchMode;

  void setSearchMode(SearchMode mode) {
    _searchMode = mode;
    notifyListeners();
  }
}
