import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_paper_model.dart';
import 'package:smart_prep/models/question_model.dart';
import 'package:smart_prep/providers/question_provider.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/question_paper_details.dart';
import 'package:smart_prep/widgets/teacher_question.dart';

class TeacherQuestionPaperPage extends ConsumerStatefulWidget {
  final QuestionPaperModel questionPaper;
  const TeacherQuestionPaperPage({
    super.key,
    required this.questionPaper,
  });

  @override
  ConsumerState<TeacherQuestionPaperPage> createState() =>
      _TeacherQuestionPaperPageState();
}

class _TeacherQuestionPaperPageState
    extends ConsumerState<TeacherQuestionPaperPage> {
  QuestionModel question = QuestionModel(
    id: 0,
    questionText: '',
    questionType: 'MCQ',
    difficultyLevel: 'INTERMEDIATE',
    marks: 1,
    expectedTimeSeconds: 60,
    options: ['', '', '', ''],
    correctOptionIndex: 0,
    modelAnswer: '',
    questionPaperId: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await SecureStorageService().readToken();
      if (token == null) return;

      ref
          .read(questionProvider.notifier)
          .getQuestionsByPaper(widget.questionPaper.id, token);
    });
  }

  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        QuestionModel localQuestion = question.copyWith();
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Add Question'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: localQuestion.questionType,
                      items: ['MCQ', 'SAQ']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          localQuestion =
                              localQuestion.copyWith(questionType: value!);
                        });
                      },
                      decoration: InputDecoration(labelText: 'Question Type'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Question Text'),
                      onChanged: (value) {
                        localQuestion =
                            localQuestion.copyWith(questionText: value);
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: localQuestion.difficultyLevel,
                      items: ['INTERMEDIATE', 'BEGINNER', 'ADVANCED']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          localQuestion =
                              localQuestion.copyWith(difficultyLevel: value!);
                        });
                      },
                      decoration:
                          InputDecoration(labelText: 'Difficulty Level'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Marks'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        localQuestion =
                            localQuestion.copyWith(marks: int.parse(value));
                      },
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Expected Time (seconds)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        localQuestion = localQuestion.copyWith(
                            expectedTimeSeconds: int.parse(value));
                      },
                    ),
                    if (localQuestion.questionType == 'MCQ') ...[
                      for (int i = 0; i < 4; i++)
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Option ${i + 1}'),
                          onChanged: (value) {
                            localQuestion.options![i] = value;
                          },
                        ),
                      DropdownButtonFormField<int>(
                        value: localQuestion.correctOptionIndex,
                        items: List.generate(4, (index) => index)
                            .map((index) => DropdownMenuItem(
                                  value: index,
                                  child: Text('Option ${index + 1}'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            localQuestion = localQuestion.copyWith(
                                correctOptionIndex: value!);
                          });
                        },
                        decoration:
                            InputDecoration(labelText: 'Correct Option'),
                      ),
                    ],
                    if (localQuestion.questionType == 'SAQ')
                      TextField(
                        decoration: InputDecoration(labelText: 'Model Answer'),
                        onChanged: (value) {
                          localQuestion =
                              localQuestion.copyWith(modelAnswer: value);
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final questionNotifier =
                        ref.read(questionProvider.notifier);
                    final token = await SecureStorageService().readToken();
                    if (token == null) return;
                    try {
                      if (localQuestion.questionType == 'MCQ') {
                        questionNotifier.addMCQQuestion(
                            questionPaperId: widget.questionPaper.id,
                            questionText: localQuestion.questionText,
                            difficultyLevel: localQuestion.difficultyLevel,
                            marks: localQuestion.marks,
                            expectedTimeSeconds:
                                localQuestion.expectedTimeSeconds,
                            options: localQuestion.options!,
                            correctOptionIndex:
                                localQuestion.correctOptionIndex!,
                            token: token);
                      } else {
                        questionNotifier.addSAQQuestion(
                            questionPaperId: widget.questionPaper.id,
                            questionText: localQuestion.questionText,
                            difficultyLevel: localQuestion.difficultyLevel,
                            marks: localQuestion.marks,
                            expectedTimeSeconds:
                                localQuestion.expectedTimeSeconds,
                            modelAnswer: localQuestion.modelAnswer!,
                            token: token);
                      }
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add question: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditQuestionDialog(QuestionModel originalQuestion) {
    QuestionModel localQuestion = originalQuestion.copyWith();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Question'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: localQuestion.questionType,
                      items: ['MCQ', 'SAQ']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          localQuestion =
                              localQuestion.copyWith(questionType: value!);
                        });
                      },
                      decoration: InputDecoration(labelText: 'Question Type'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Question Text'),
                      controller: TextEditingController(
                          text: localQuestion.questionText),
                      onChanged: (value) {
                        localQuestion =
                            localQuestion.copyWith(questionText: value);
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: localQuestion.difficultyLevel,
                      items: ['INTERMEDIATE', 'BEGINNER', 'ADVANCED']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          localQuestion =
                              localQuestion.copyWith(difficultyLevel: value!);
                        });
                      },
                      decoration:
                          InputDecoration(labelText: 'Difficulty Level'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Marks'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: localQuestion.marks.toString()),
                      onChanged: (value) {
                        localQuestion =
                            localQuestion.copyWith(marks: int.parse(value));
                      },
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Expected Time (seconds)'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: localQuestion.expectedTimeSeconds.toString()),
                      onChanged: (value) {
                        localQuestion = localQuestion.copyWith(
                            expectedTimeSeconds: int.parse(value));
                      },
                    ),
                    if (localQuestion.questionType == 'MCQ') ...[
                      for (int i = 0; i < 4; i++)
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Option ${i + 1}'),
                          controller: TextEditingController(
                              text: localQuestion.options![i]),
                          onChanged: (value) {
                            localQuestion.options![i] = value;
                          },
                        ),
                      DropdownButtonFormField<int>(
                        value: localQuestion.correctOptionIndex,
                        items: List.generate(4, (index) => index)
                            .map((index) => DropdownMenuItem(
                                  value: index,
                                  child: Text('Option ${index + 1}'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            localQuestion = localQuestion.copyWith(
                                correctOptionIndex: value!);
                          });
                        },
                        decoration:
                            InputDecoration(labelText: 'Correct Option'),
                      ),
                    ],
                    if (localQuestion.questionType == 'SAQ')
                      TextField(
                        decoration: InputDecoration(labelText: 'Model Answer'),
                        controller: TextEditingController(
                            text: localQuestion.modelAnswer),
                        onChanged: (value) {
                          localQuestion =
                              localQuestion.copyWith(modelAnswer: value);
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final questionNotifier =
                        ref.read(questionProvider.notifier);
                    final token = await SecureStorageService().readToken();
                    if (token == null) return;
                    try {
                      await questionNotifier.updateQuestion(
                        id: localQuestion.id,
                        questionText: localQuestion.questionText,
                        questionType: localQuestion.questionType,
                        difficultyLevel: localQuestion.difficultyLevel,
                        marks: localQuestion.marks,
                        expectedTimeSeconds: localQuestion.expectedTimeSeconds,
                        options: localQuestion.questionType == 'MCQ'
                            ? localQuestion.options
                            : null,
                        correctOptionIndex: localQuestion.questionType == 'MCQ'
                            ? localQuestion.correctOptionIndex
                            : null,
                        modelAnswer: localQuestion.questionType == 'SAQ'
                            ? localQuestion.modelAnswer
                            : null,
                        token: token,
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to update question: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Text(
              'NO',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final token = await SecureStorageService().readToken();
              if (token == null) return;
              ref.read(questionProvider.notifier).deleteQuestion(id, token);
              Navigator.of(context).pop();
            },
            icon: Text(
              'YES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionState = ref.watch(questionProvider);
    if (questionState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${questionState.error}")),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question Paper',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _showAddQuestionDialog();
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            QuestionPaperDetails(questionPaper: widget.questionPaper),
            SizedBox(height: 25),
            Expanded(
              child: questionState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : questionState.questions.isEmpty
                      ? Center(child: Text("No questions found"))
                      : ListView.builder(
                          itemCount: questionState.questions.length,
                          itemBuilder: (context, index) {
                            final question = questionState.questions[index];
                            return TeacherQuestion(
                              index: index + 1,
                              question: question,
                              onEditOptions: () {
                                _showEditQuestionDialog(question);
                              },
                              onDelete: () {
                                _delete(question.id);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
