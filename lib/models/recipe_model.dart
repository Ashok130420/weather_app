import 'dart:convert';

class RecipeModel {
  final int? id;
  final String? title;
  final String? image;
  final int? readyInMinutes;
  final List<String?>? ingredients;
  final String? instructions;

  RecipeModel({
    this.id,
    this.title,
    this.image,
    this.readyInMinutes,
    this.ingredients,
    this.instructions,
  });

  // Convert object to a Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'readyInMinutes': readyInMinutes,
      'ingredients': ingredients?.join(', '),
      'instructions': instructions,
    };
  }

  // Create object from a Map from database
  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      readyInMinutes: map['readyInMinutes'],
      ingredients: map['ingredients'] != null ? (map['ingredients'] as String).split(', ').map((e) => e.trim()).toList() : [],
      instructions: map['instructions'],
    );
  }
}
