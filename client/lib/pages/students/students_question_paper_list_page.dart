import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/providers/student_providers.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/student_question_paper.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _urlLaunch(String baseURL) async {
    try {
      final url = Uri.parse(baseURL);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to launch Doubt Clearing Chat',
          ),
        ),
      );
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _urlLaunch('https://smart-prep.netlify.app/home');
        },
        shape: CircleBorder(),
        child: Icon(Icons.chat),
      ),
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
