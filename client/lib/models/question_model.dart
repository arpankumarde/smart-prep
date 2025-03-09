class QuestionModel {
  final int id;
  final String questionText;
  final String questionType;
  final String difficultyLevel;
  final int marks;
  final int expectedTimeSeconds;
  final List<String>? options;
  final int? correctOptionIndex;
  final String? modelAnswer;
  final int questionPaperId;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.difficultyLevel,
    required this.marks,
    required this.expectedTimeSeconds,
    this.options,
    this.correctOptionIndex,
    this.modelAnswer,
    required this.questionPaperId,
    required this.createdAt,
    required this.updatedAt,
  });

  QuestionModel copyWith({
    int? id,
    String? questionText,
    String? questionType,
    String? difficultyLevel,
    int? marks,
    int? expectedTimeSeconds,
    List<String>? options,
    int? correctOptionIndex,
    String? modelAnswer,
    int? questionPaperId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      marks: marks ?? this.marks,
      expectedTimeSeconds: expectedTimeSeconds ?? this.expectedTimeSeconds,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      modelAnswer: modelAnswer ?? this.modelAnswer,
      questionPaperId: questionPaperId ?? this.questionPaperId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      questionText: map['questionText'],
      questionType: map['questionType'],
      difficultyLevel: map['difficultyLevel'],
      marks: map['marks'],
      expectedTimeSeconds: map['expectedTimeSeconds'],
      options:
          map['options'] != null ? List<String>.from(map['options']) : null,
      correctOptionIndex: map['correctOptionIndex'],
      modelAnswer: map['modelAnswer'],
      questionPaperId: map['questionPaperId'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'questionType': questionType,
      'difficultyLevel': difficultyLevel,
      'marks': marks,
      'expectedTimeSeconds': expectedTimeSeconds,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'modelAnswer': modelAnswer,
      'questionPaperId': questionPaperId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }


}
