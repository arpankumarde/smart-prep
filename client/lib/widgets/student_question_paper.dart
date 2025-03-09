import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/student_paper_model.dart';
import 'package:smart_prep/pages/students/start_test.dart';

class StudentQuestionPaper extends StatefulWidget {
  final StudentPaperModel paper;
  const StudentQuestionPaper({
    super.key,
    required this.paper,
  });

  @override
  State<StudentQuestionPaper> createState() => _StudentQuestionPaperState();
}

class _StudentQuestionPaperState extends State<StudentQuestionPaper> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.containerBackground,
      shadowColor: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // if (widget.paper.attemptsMade == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StartTest(
                  id: widget.paper.id,
                  title: widget.paper.title,
                ),
              ),
            );
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         'You have already attempted the test',
          //       ),
          //     ),
          //   );
          // }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.paper.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.paper.description,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                        if (widget.paper.attemptsMade > 0)
                          Text(
                            'Attempted',
                            style: TextStyle(
                              color: AppTheme.gradient2,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
