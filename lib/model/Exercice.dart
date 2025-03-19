// Modèle d'exercice
class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String target;
  List<String> secondaryMuscles;
  List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.target,
    this.secondaryMuscles = const [],
    this.instructions = const [],
  });

  factory Exercise.fromFirestore(Map<String, dynamic> data, String id) {
    return Exercise(
      id: id == "" ? data['id'] : id ?? '',
      name: data['name'] ?? '',
      bodyPart: data['bodyPart'] ?? '',
      equipment: data['equipment'] ?? '',
      gifUrl: data['gifUrl'] ?? '',
      target: data['target'] ?? '',
      secondaryMuscles: List<String>.from(data['secondaryMuscles'] ?? []),
      instructions: List<String>.from(data['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }
}
