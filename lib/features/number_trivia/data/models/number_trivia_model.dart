import 'dart:convert';

import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.text, required super.number});

  NumberTriviaModel copyWith({
    String? text,
    int? number,
  }) {
    return NumberTriviaModel(
      text: text ?? this.text,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] as String,
      number: (map['number'] as num).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTriviaModel.fromJson(json) =>
      NumberTriviaModel.fromMap(json as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
