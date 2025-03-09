import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/pages/students/student_question_paper_page.dart';
import 'package:smart_prep/providers/student_providers.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/gradient_button.dart';

class StartTest extends ConsumerStatefulWidget {
  final int id;
  final String title;
  const StartTest({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  ConsumerState<StartTest> createState() => _StartTestState();
}

class _StartTestState extends ConsumerState<StartTest> {
  @override
  Widget build(BuildContext context) {
    final studentsNotifier = ref.watch(studentNotifierProvider.notifier);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: GradientButton(
          text: 'Start Test',
          onPressed: () async {
            final token = await SecureStorageService().readToken();
            if (token == null) return;
            try {
              await studentsNotifier.startQuizAttempt(widget.id, token);
              final currentState = ref.read(studentNotifierProvider);
              final quizAttemptDetails = currentState.quizAttemptDetails;
 
              if (quizAttemptDetails != null &&
                  quizAttemptDetails['id'] != null) {
                final attemptID = quizAttemptDetails['id'];
       
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StudentQuestionPaperPage(
                      id: widget.id,
                      attemptID: attemptID,
                      title: widget.title,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text("Quiz attempt not created. Please try again."),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
