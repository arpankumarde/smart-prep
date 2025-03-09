import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/question_model.dart';

class TeacherQuestion extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final VoidCallback onEditOptions;
  final VoidCallback onDelete;

  const TeacherQuestion({
    super.key,
    required this.index,
    required this.question,
    required this.onEditOptions,
    required this.onDelete,
  });

  @override
  State<TeacherQuestion> createState() => _TeacherQuestionState();
}

class _TeacherQuestionState extends State<TeacherQuestion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.containerBackground,
      shadowColor: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          if (widget.question.questionType == 'MCQ') {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.index}. ${widget.question.questionText}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: _isExpanded &&
                                  widget.question.questionType == 'MCQ'
                              ? null
                              : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.question.questionType),
                            Text(widget.question.difficultyLevel),
                            Text('${widget.question.marks.toString()} Marks'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.question.questionType != 'MCQ')
                    IconButton(
                      icon: const Icon(Icons.edit, size: 24),
                      onPressed: () {
                        widget.onEditOptions();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent, size: 24),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
              if (widget.question.questionType == 'MCQ' && _isExpanded) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      List.generate(widget.question.options!.length, (index) {
                    final option = index == 0
                        ? 'A'
                        : index == 1
                            ? 'B'
                            : index == 2
                                ? 'C'
                                : 'D';
                    return Text(
                      '$option:  ${widget.question.options![index]}',
                      style: TextStyle(fontSize: 15),
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onEditOptions,
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text('Edit Options'),
                    )
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
