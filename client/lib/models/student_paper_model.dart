class StudentPaperModel {
  final int id;
  final String title;
  final String description;
  final String questionBankName;
  final String creatorName;
  final int duration;
  final int totalQuestions;
  final String difficultyLevel;
  final int totalMarks;
  final int passingMarks;
  final int attemptsMade;
  final bool hasPendingAttempt;

  StudentPaperModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questionBankName,
    required this.creatorName,
    required this.duration,
    required this.totalQuestions,
    required this.difficultyLevel,
    required this.totalMarks,
    required this.passingMarks,
    required this.attemptsMade,
    required this.hasPendingAttempt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'questionBankName': questionBankName,
      'creatorName': creatorName,
      'duration': duration,
      'totalQuestion': totalQuestions,
      'difficultyLevel': difficultyLevel,
      'totalMarks': totalMarks,
      'passingMarks': passingMarks,
      'attemptsMade': attemptsMade,
      'hasPendingAttempt': hasPendingAttempt,
    };
  }

  factory StudentPaperModel.fromMap(Map<String, dynamic> map) {
    return StudentPaperModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      questionBankName: map['questionBankName'] as String,
      creatorName: map['creatorName'] as String,
      duration: map['duration'] as int,
      totalQuestions: map['totalQuestions'] as int,
      difficultyLevel: map['difficultyLevel'] as String,
      totalMarks: map['totalMarks'] as int,
      passingMarks: map['passingMarks'] as int,
      attemptsMade: map['attemptsMade'] as int,
      hasPendingAttempt: map['hasPendingAttempt'] as bool,
    );
  }
}
