import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/pages/students/study_materials_page.dart';
import 'package:smart_prep/providers/question_provider.dart';
import 'package:smart_prep/providers/student_providers.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/gradient_button.dart';
import 'package:smart_prep/widgets/student_question.dart';

class StudentQuestionPaperPage extends ConsumerStatefulWidget {
  final int id;
  final int attemptID;
  final String title;
  const StudentQuestionPaperPage({
    super.key,
    required this.id,
    required this.attemptID,
    required this.title,
  });

  @override
  ConsumerState<StudentQuestionPaperPage> createState() =>
      _StudentQuestionPaperPageState();
}

class _StudentQuestionPaperPageState
    extends ConsumerState<StudentQuestionPaperPage> {
  List<String> questionTexts = [];
  List<String> modelAnswers = [];

  List<String> studentAnswers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await SecureStorageService().readToken();
      if (token == null) return;
      await ref
          .read(questionProvider.notifier)
          .getQuestionsByPaper(widget.id, token);
    });
  }

  void _confirm() {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Confirm Submit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            icon: const Text(
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
              await ref
                  .read(studentNotifierProvider.notifier)
                  .submitQuizAttempt(widget.attemptID, token);
              Navigator.pop(dialogContext);
              await ref
                  .read(studentNotifierProvider.notifier)
                  .getAvailableQuestionPapers(token);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StudyMaterialsPage(),
                ),
              );
            },
            icon: const Text(
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

    if (questionState.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    questionTexts = [];
    modelAnswers = [];

    studentAnswers = List.filled(questionState.questions.length, '');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: questionState.questions.length,
                  itemBuilder: (context, index) {
                    final question = questionState.questions[index];

                    questionTexts.add(question.questionText);
                    modelAnswers.add(question.modelAnswer ?? '');
                    return StudentQuestion(
                      index: index + 1,
                      attemptID: widget.attemptID,
                      question: question,
                      onAnswerSubmitted: (answer) {
                        studentAnswers[index] = answer;
                      },
                    );
                  },
                ),
              ),
              GradientButton(
                text: 'Submit',
                onPressed: () {
                  _confirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
