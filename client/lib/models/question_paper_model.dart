class QuestionPaperModel {
  final int id;
  final String title;
  final String description;
  final int? questionBankId;
  final String questionBankName;
  final int creatorId;
  final String creatorName;
  final int duration;
  final String difficultyLevel;
  final int totalQuestions;
  final int totalMarks;
  final int passingMarks;
  final bool published;
  final String createdAt;
  final String updatedAt;

  QuestionPaperModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questionBankId,
    required this.questionBankName,
    required this.creatorId,
    required this.creatorName,
    required this.duration,
    required this.difficultyLevel,
    required this.totalQuestions,
    required this.totalMarks,
    required this.passingMarks,
    required this.published,
    required this.createdAt,
    required this.updatedAt,
  });

  QuestionPaperModel copyWith({
    int? id,
    String? title,
    String? description,
    int? questionBankId,
    String? questionBankName,
    int? creatorId,
    String? creatorName,
    int? duration,
    String? difficultyLevel,
    int? totalQuestions,
    int? totalMarks,
    int? passingMarks,
    bool? published,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuestionPaperModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questionBankId: questionBankId ?? this.questionBankId,
      questionBankName: questionBankName ?? this.questionBankName,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      duration: duration ?? this.duration,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalMarks: totalMarks ?? this.totalMarks,
      passingMarks: passingMarks ?? this.passingMarks,
      published: published ?? this.published,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'questionBankId': questionBankId,
      'questionBankName': questionBankName,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'duration': duration,
      'difficultyLevel': difficultyLevel,
      'totalQuestions': totalQuestions,
      'totalMarks': totalMarks,
      'passingMarks': passingMarks,
      'published': published,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory QuestionPaperModel.fromMap(Map<String, dynamic> map) {
    return QuestionPaperModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      questionBankId: map['questionBankId'] as int,
      questionBankName: map['questionBankName'] as String,
      creatorId: map['creatorId'] as int,
      creatorName: map['creatorName'] as String,
      duration: map['duration'] as int,
      difficultyLevel: map['difficultyLevel'] as String,
      totalQuestions: map['totalQuestions'] as int,
      totalMarks: map['totalMarks'] as int,
      passingMarks: map['passingMarks'] as int,
      published: map['published'] as bool,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }
}
