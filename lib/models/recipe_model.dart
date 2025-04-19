import 'dart:convert';

class RecipeModel {
  final int? id;
  final String? title;
  final String? image;
  final int? readyInMinutes;
  final List<String?>? extendedIngredients;
  final String? instructions;

  RecipeModel({
    this.id,
    this.title,
    this.image,
    this.readyInMinutes,
    this.extendedIngredients,
    this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'readyInMinutes': readyInMinutes,
      'ingredients': extendedIngredients?.join(', '),
      'instructions': instructions,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      readyInMinutes: map['readyInMinutes'],
      extendedIngredients: map['ingredients'] != null ? (map['ingredients'] as String).split(', ').map((e) => e.trim()).toList() : [],
      instructions: map['instructions'],
    );
  }
}
