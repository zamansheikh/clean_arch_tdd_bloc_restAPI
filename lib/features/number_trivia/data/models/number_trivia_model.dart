import 'dart:convert';

import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.text, required super.number});

  // Method to create a copy of the model with new values
  NumberTriviaModel copyWith({
    String? text,
    int? number,
  }) {
    return NumberTriviaModel(
      text: text ?? this.text,
      number: number ?? this.number,
    );
  }

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'number': number,
    };
  }

  // Create a model from a map
  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] as String,
      number: (map['number'] as num).toInt(),
    );
  }

  // Convert the model to JSON string
  String toJson() => json.encode(toMap());

  // Create a model from a JSON string
  factory NumberTriviaModel.fromJson(String source) =>
      NumberTriviaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
