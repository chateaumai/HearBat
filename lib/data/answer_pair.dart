import 'dart:math';

class Answer {
  final String answer;
  final String? path;
  final String? image;

  Answer(this.answer, this.path, this.image);

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'path': path,
      'image': image,
    };
  }

  static Answer fromJson(Map<String, dynamic> json) {
    return Answer(
      json['answer'] as String,
      json['path'] as String?,
      json['image'] as String?,
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
      'answers': [answer1.toJson(), answer2.toJson(), answer3.toJson(), answer4.toJson()]
    };
  }

  static AnswerGroup fromJson(Map<String, dynamic> json) {
    return AnswerGroup(
      Answer.fromJson(json['answers'][0] as Map<String, dynamic>),
      Answer.fromJson(json['answers'][1] as Map<String, dynamic>),
      Answer.fromJson(json['answers'][2] as Map<String, dynamic>),
      Answer.fromJson(json['answers'][3] as Map<String, dynamic>),
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

class Module {
  final List<AnswerGroup> answerGroups;
  Module(this.answerGroups);

  static Module fromJson(Map<String, dynamic> json) {
    return Module((json['answerGroups'] as List).map((item) => AnswerGroup.fromJson(item)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'answerGroups': answerGroups.map((group) => group.toJson()).toList(),
    };
  }
}

class Chapter {
  final Map<String, Module> modules;
  Chapter(this.modules);

  static final Chapter _empty = Chapter({});

  factory Chapter.empty() {
    return _empty;
  }
  static Chapter fromJson(Map<String, dynamic> json) {
    return Chapter(
      {for (var module in json['modules']) module['name'] : Module.fromJson(module) }
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modules': modules.map((id, module) => MapEntry(id, module.toJson())),
    };
  }
}

class SpeechModule {
  final List<String> speechGroups;
  SpeechModule(this.speechGroups);

  static SpeechModule fromJson(Map<String, dynamic> json) {
    return SpeechModule(
      [for (var item in json['speechGroups']) item.toString()]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speechGroups': speechGroups.map((group) => group).toList(),
    };
  }
}

class SpeechChapter {
  final Map<String, SpeechModule> speechModules;
  SpeechChapter(this.speechModules);

 static final SpeechChapter _empty = SpeechChapter({});

 factory SpeechChapter.empty() {
   return _empty;
 }

 static SpeechChapter fromJson(Map<String, dynamic> json) {
   return SpeechChapter(
     {for (var module in json['modules']) module['name'] : SpeechModule.fromJson(module)}
   );
 }

 Map<String, dynamic> toJson() {
   return {
     'modules': speechModules.map((id, module) => MapEntry(id, module.toJson()))
   };
 }
}
