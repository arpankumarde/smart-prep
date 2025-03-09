import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/question_paper_model.dart';
import 'package:smart_prep/pages/teacher/teacher_question_paper_page.dart';

class TeacherQuestionPaper extends StatefulWidget {
  final QuestionPaperModel questionPaper;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TeacherQuestionPaper({
    super.key,
    required this.questionPaper,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TeacherQuestionPaper> createState() => _TeacherQuestionPaperState();
}

class _TeacherQuestionPaperState extends State<TeacherQuestionPaper> {
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
              builder: (context) => TeacherQuestionPaperPage(
                questionPaper: widget.questionPaper,
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
                      widget.questionPaper.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      widget.questionPaper.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
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
