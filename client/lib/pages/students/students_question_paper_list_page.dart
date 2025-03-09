import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/providers/student_providers.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/student_question_paper.dart';

class StudentsQuestionPaperListPage extends ConsumerStatefulWidget {
  const StudentsQuestionPaperListPage({super.key});

  @override
  ConsumerState<StudentsQuestionPaperListPage> createState() =>
      _StudentsQuestionPaperListPageState();
}

class _StudentsQuestionPaperListPageState
    extends ConsumerState<StudentsQuestionPaperListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await SecureStorageService().readToken();
      if (token == null) return;
      ref
          .read(studentNotifierProvider.notifier)
          .getAvailableQuestionPapers(token);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentNotifierProvider);
    if (studentState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${studentState.error}")),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text('Question Papers')),
      body: studentState.isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : studentState.availableQuestionPapers.isEmpty
              ? Center(child: Text("No question papers found"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: studentState.availableQuestionPapers.length,
                    itemBuilder: (context, index) {
                      final paper =
                          studentState.availableQuestionPapers.elementAt(index);
                      return StudentQuestionPaper(
                        paper: paper,
                      );
                    },
                  ),
                ),
    );
  }
}
