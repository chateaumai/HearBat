class Sound {
  final String name;
  final String path;

  Sound(this.name, this.path);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
    };
  }

  static Sound fromJson(Map<String, dynamic> json) {
    return Sound(
      json['name'] as String,
      json['path'] as String,
    );
  }
}

class SoundGroup {
  final Sound sound1;
  final Sound sound2;
  final Sound sound3;
  final Sound sound4;

  SoundGroup(this.sound1, this.sound2, this.sound3, this.sound4);

  Map<String, dynamic> toJson() {
    return {
      'sound1': sound1.toJson(),
      'sound2': sound2.toJson(),
      'sound3': sound3.toJson(),
      'sound4': sound4.toJson(),
    };
  }

  static SoundGroup fromJson(Map<String, dynamic> json) {
    return SoundGroup(
      Sound.fromJson(json['sound1'] as Map<String, dynamic>),
      Sound.fromJson(json['sound2'] as Map<String, dynamic>),
      Sound.fromJson(json['sound3'] as Map<String, dynamic>),
      Sound.fromJson(json['sound4'] as Map<String, dynamic>),
    );
  }
}
