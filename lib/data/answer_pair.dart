import 'dart:math';

class Answer {
  final String answer;
  final String path;

  Answer(this.answer, this.path);

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'path': path,
    };
  }

  static Answer fromJson(Map<String, dynamic> json) {
    return Answer(
      json['answer'] as String,
      json['path'] as String,
    );
  }
}

class AnswerGroup {
  final Answer answer1;
  final Answer answer2;
  final Answer answer3;
  final Answer answer4;

  AnswerGroup(this.answer1, this.answer2, this.answer3, this.answer4);

  Map<String, dynamic> toJson() {
    return {
      'answer1': answer1.toJson(),
      'answer2': answer2.toJson(),
      'answer3': answer3.toJson(),
      'answer4': answer4.toJson(),
    };
  }

  static AnswerGroup fromJson(Map<String, dynamic> json) {
    return AnswerGroup(
      Answer.fromJson(json['answer1'] as Map<String, dynamic>),
      Answer.fromJson(json['answer2'] as Map<String, dynamic>),
      Answer.fromJson(json['answer3'] as Map<String, dynamic>),
      Answer.fromJson(json['answer4'] as Map<String, dynamic>),
    );
  }

  Answer getRandomAnswer(AnswerGroup currentGroup) {
    Random random = Random();
    int number = random.nextInt(4);

    switch (number) {
      case 0:
        return currentGroup.answer1;
      case 1:
        return currentGroup.answer2;
      case 2:
        return currentGroup.answer3;
      case 3:
        return currentGroup.answer4;
      default:
        return currentGroup.answer1;
    }
  }
}
