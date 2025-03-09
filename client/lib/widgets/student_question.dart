import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/question_model.dart';
import 'package:smart_prep/providers/student_providers.dart';
import 'package:smart_prep/services/secure_storage_service.dart';

class StudentQuestion extends ConsumerStatefulWidget {
  final int index;
  final int attemptID;
  final QuestionModel question;
  /// Callback to deliver the student entered answer to the parent.
  final ValueChanged<String>? onAnswerSubmitted;

  const StudentQuestion({
    super.key,
    required this.index,
    required this.attemptID,
    required this.question,
    this.onAnswerSubmitted,
  });

  @override
  ConsumerState<StudentQuestion> createState() => _StudentQuestionState();
}

class _StudentQuestionState extends ConsumerState<StudentQuestion> {
  bool _isExpanded = false;
  bool _isAnswered = false;
  int? _selectedOption;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnswered) return;
    if (widget.question.questionType.toUpperCase() == 'MCQ') {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    } else if (widget.question.questionType.toUpperCase() == 'SAQ') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.containerBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Answer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.question.questionText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Write your answer here...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 44, 44, 44),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Marks: ${widget.question.marks}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        final answer = _answerController.text;
                        final payload = {
                          "questionId": widget.question.id,
                          "textAnswer": answer,
                        };
                        final token = await SecureStorageService().readToken();
                        if (token == null) return;
                        await ref
                            .read(studentNotifierProvider.notifier)
                            .submitAnswer(
                              token,
                              attemptId: widget.attemptID,
                              answerPayload: payload,
                            );
                        setState(() {
                          _isAnswered = true;
                        });
                        // Pass answer to parent.
                        widget.onAnswerSubmitted?.call(answer);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save Answer',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _submitMCQAnswer(int selectedIndex) async {
    final payload = {
      "questionId": widget.question.id,
      "selectedOptionIndex": selectedIndex,
    };
    final token = await SecureStorageService().readToken();
    if (token == null) return;
    await ref.read(studentNotifierProvider.notifier).submitAnswer(
          token,
          attemptId: widget.attemptID,
          answerPayload: payload,
        );
    // Retrieve the answer option text.
    final answer = widget.question.options![selectedIndex];
    setState(() {
      _isAnswered = true;
    });
    // Return answer to parent.
    widget.onAnswerSubmitted?.call(answer);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMCQ = widget.question.questionType.toUpperCase() == 'MCQ';

    return Card(
      color: _isAnswered
          ? const Color.fromARGB(255, 31, 29, 29)
          : AppTheme.containerBackground,
      shadowColor: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.index}. ${widget.question.questionText}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type: ${widget.question.questionType}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Diff: ${widget.question.difficultyLevel}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${widget.question.marks} Marks',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              if (isMCQ && _isExpanded)
                Column(
                  children: widget.question.options!
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    return RadioListTile<int>(
                      title: Text(option),
                      value: index,
                      groupValue: _selectedOption,
                      onChanged: _isAnswered
                          ? null
                          : (value) async {
                              setState(() {
                                _selectedOption = value;
                              });
                              await _submitMCQAnswer(value!);
                            },
                      activeColor: Colors.blue,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}