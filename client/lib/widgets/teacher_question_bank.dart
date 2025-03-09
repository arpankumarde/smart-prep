import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/question_bank_model.dart';
import 'package:smart_prep/pages/teacher/teacher_question_paper_list_page.dart';

class TeacherQuestionBank extends ConsumerStatefulWidget {
  final QuestionBankModel questionBank;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TeacherQuestionBank({
    super.key,
    required this.questionBank,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  ConsumerState<TeacherQuestionBank> createState() =>
      _TeacherQuestionBankState();
}

class _TeacherQuestionBankState extends ConsumerState<TeacherQuestionBank> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.containerBackground,
      shadowColor: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TeacherQuestionPaperListPage(
                id: widget.questionBank.id,
                title: widget.questionBank.name,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.questionBank.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.questionBank.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 24),
                onPressed: () {
                  widget.onEdit();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent, size: 24),
                onPressed: () {
                  widget.onDelete();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
