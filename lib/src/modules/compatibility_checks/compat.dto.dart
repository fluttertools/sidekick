import 'dart:convert';

/// Check for required programs
class CompatibilityCheck {
  /// Git Install Status
  bool git;

  /// Cohocolately Install Status
  bool choco;

  /// Brew Install Status
  bool brew;

  bool waiting;

  /// Constructor
  CompatibilityCheck({
    required this.git,
    required this.choco,
    required this.brew,
    this.waiting = false,
  });

  ///
  factory CompatibilityCheck.notReady() {
    return CompatibilityCheck(
      brew: false,
      choco: false,
      git: false,
      waiting: true,
    );
  }

  /// check if the basic programs are installed
  bool get ready {
    return git;
  }

  CompatibilityCheck copyWith({
    bool? git,
    bool? fvm,
    bool? choco,
    bool? brew,
  }) {
    return CompatibilityCheck(
      git: git ?? this.git,
      choco: choco ?? this.choco,
      brew: brew ?? this.brew,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'git': git,
      'choco': choco,
      'brew': brew,
    };
  }

  factory CompatibilityCheck.fromMap(Map<String, dynamic> map) {
    return CompatibilityCheck(
      git: map['git'] ?? false,
      choco: map['choco'] ?? false,
      brew: map['brew'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompatibilityCheck.fromJson(String source) =>
      CompatibilityCheck.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompatibilityCheck(git: $git, choco: $choco, brew: $brew)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompatibilityCheck &&
        other.git == git &&
        other.choco == choco &&
        other.brew == brew;
  }

  @override
  int get hashCode {
    return git.hashCode ^ choco.hashCode ^ brew.hashCode;
  }
}
