import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_paper_model.dart';
import 'package:smart_prep/providers/question_paper_provider.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/teacher_question_paper.dart';

class TeacherQuestionPaperListPage extends ConsumerStatefulWidget {
  final int id;
  final String title;
  const TeacherQuestionPaperListPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  ConsumerState<TeacherQuestionPaperListPage> createState() =>
      _TeacherQuestionPaperListPageState();
}

class _TeacherQuestionPaperListPageState
    extends ConsumerState<TeacherQuestionPaperListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await SecureStorageService().readToken();
      if (token == null) return;

      ref.read(questionPaperProvider.notifier).getAllQuestionPapersByBank(
            questionBankId: widget.id,
            token: token,
          );
    });
  }

  void _showQuestionPaperDialog(BuildContext context,
      {QuestionPaperModel? questionPaper}) {
    final TextEditingController titleController =
        TextEditingController(text: questionPaper?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: questionPaper?.description ?? '');
    final TextEditingController durationController =
        TextEditingController(text: questionPaper?.duration.toString() ?? '');
    final TextEditingController totalQuestionsController =
        TextEditingController(
            text: questionPaper?.totalQuestions.toString() ?? '');
    final TextEditingController totalMarksController =
        TextEditingController(text: questionPaper?.totalMarks.toString() ?? '');
    final TextEditingController passingMarksController = TextEditingController(
        text: questionPaper?.passingMarks.toString() ?? '');
    final TextEditingController difficultyController =
        TextEditingController(text: questionPaper?.difficultyLevel ?? '');

    bool isPublished = questionPaper?.published ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(questionPaper == null
                  ? "Create Question Paper"
                  : "Edit Question Paper"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                    TextField(
                      controller: durationController,
                      decoration:
                          InputDecoration(labelText: "Duration (in minutes)"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: totalQuestionsController,
                      decoration: InputDecoration(labelText: "Total Questions"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: totalMarksController,
                      decoration: InputDecoration(labelText: "Total Marks"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: passingMarksController,
                      decoration: InputDecoration(labelText: "Passing Marks"),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: 'EASY',
                      items: ['EASY', 'HARD', 'MEDIUM']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          difficultyController.text = value!.trimRight();
                        });
                      },
                      decoration:
                          InputDecoration(labelText: 'Difficulty Level'),
                    ),
                    if (questionPaper != null)
                      Row(
                        children: [
                          Checkbox(
                            value: isPublished,
                            onChanged: (value) {
                              setState(() {
                                isPublished = value!;
                              });
                            },
                          ),
                          Text("Published"),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final token = await SecureStorageService().readToken();
                    if (token == null) return;

                    if (questionPaper == null) {
                      ref
                          .read(questionPaperProvider.notifier)
                          .createQuestionPaper(
                            title: titleController.text,
                            description: descriptionController.text,
                            questionBankId: widget.id,
                            duration:
                                int.tryParse(durationController.text) ?? 0,
                            totalQuestions:
                                int.tryParse(totalQuestionsController.text) ??
                                    0,
                            totalMarks:
                                int.tryParse(totalMarksController.text) ?? 0,
                            passingMarks:
                                int.tryParse(passingMarksController.text) ?? 0,
                            difficultyLevel:
                                difficultyController.text.toUpperCase(),
                            published: true,
                            token: token,
                          );
                    } else {
                      ref
                          .read(questionPaperProvider.notifier)
                          .updateQuestionPaper(
                            id: questionPaper.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            questionBankId: widget.id,
                            duration:
                                int.tryParse(durationController.text) ?? 0,
                            totalQuestions:
                                int.tryParse(totalQuestionsController.text) ??
                                    0,
                            totalMarks:
                                int.tryParse(totalMarksController.text) ?? 0,
                            passingMarks:
                                int.tryParse(passingMarksController.text) ?? 0,
                            difficultyLevel: difficultyController.text,
                            published: isPublished,
                            token: token,
                          );
                    }

                    Navigator.pop(context);
                  },
                  child: Text(questionPaper == null ? "Create" : "Update"),
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
              ref
                  .read(questionPaperProvider.notifier)
                  .deleteQuestionPaper(id, token);
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
    final questionPaperState = ref.watch(questionPaperProvider);
    if (questionPaperState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${questionPaperState.error}")),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _showQuestionPaperDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: questionPaperState.isLoading
          ? Center(child: CircularProgressIndicator())
          : questionPaperState.questionPapers.isEmpty
              ? Center(child: Text("No question papers found"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: questionPaperState.questionPapers.length,
                    itemBuilder: (context, index) {
                      final qp = questionPaperState.questionPapers[index];
                      return TeacherQuestionPaper(
                        questionPaper: qp,
                        onEdit: () {
                          _showQuestionPaperDialog(context, questionPaper: qp);
                        },
                        onDelete: () {
                          _delete(qp.id);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
