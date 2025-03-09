class QuestionBankModel {
  final int id;
  final String name;
  final String description;
  final int creatorId;
  final String creatorName;
  final String createdAt;
  final String updatedAt;
  final bool public;

  QuestionBankModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.creatorName,
    required this.createdAt,
    required this.updatedAt,
    required this.public,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'public': public,
    };
  }

  factory QuestionBankModel.fromMap(Map<String, dynamic> map) {
    return QuestionBankModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      creatorId: map['creatorId'] as int,
      creatorName: map['creatorName'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      public: map['public'] as bool,
    );
  }
}
