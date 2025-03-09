import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_bank_model.dart';
import 'package:smart_prep/providers/question_bank_provider.dart';
import 'package:smart_prep/services/secure_storage_service.dart';
import 'package:smart_prep/widgets/teacher_question_bank.dart';

class TeacherQuestionBankListPage extends ConsumerStatefulWidget {
  const TeacherQuestionBankListPage({super.key});

  @override
  ConsumerState<TeacherQuestionBankListPage> createState() =>
      _TeacherQuestionBankListPageState();
}

class _TeacherQuestionBankListPageState
    extends ConsumerState<TeacherQuestionBankListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final token = await SecureStorageService().readToken();
        if (token == null) return;
        ref
            .read(questionBankProvider.notifier)
            .getAllMyQuestionBanks(token: token);
      },
    );
  }

  void _showQuestionBankDialog(BuildContext context,
      {QuestionBankModel? questionBank}) {
    final TextEditingController nameController =
        TextEditingController(text: questionBank?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: questionBank?.description ?? '');
    final TextEditingController subjectController = TextEditingController();

    bool isPublic = questionBank?.public ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(questionBank == null
                  ? "Create Question Bank"
                  : "Edit Question Bank"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  if (questionBank == null)
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(labelText: "Subject"),
                    ),
                  Row(
                    children: [
                      Checkbox(
                        value: isPublic,
                        onChanged: (value) {
                          setState(() {
                            isPublic = value!;
                          });
                        },
                      ),
                      Text("Public"),
                    ],
                  ),
                ],
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

                    if (questionBank == null) {
                      ref
                          .read(questionBankProvider.notifier)
                          .createQuestionBank(
                            name: nameController.text,
                            subject: subjectController.text.isEmpty
                                ? "All"
                                : subjectController.text,
                            description: descriptionController.text,
                            isPublic: isPublic,
                            token: token,
                          );
                    } else {
                      ref
                          .read(questionBankProvider.notifier)
                          .updateQuestionBank(
                            id: questionBank.id,
                            name: nameController.text,
                            description: descriptionController.text,
                            isPublic: isPublic,
                            token: token,
                          );
                    }

                    Navigator.pop(context);
                  },
                  child: Text(questionBank == null ? "Create" : "Update"),
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
                  .read(questionBankProvider.notifier)
                  .deleteQuestionBank(id, token);
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
    final questionBankState = ref.watch(questionBankProvider);
    if (questionBankState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${questionBankState.error}")),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text('Question Banks')),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _showQuestionBankDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: questionBankState.isLoading
          ? Center(child: CircularProgressIndicator())
          : questionBankState.questionBanks.isEmpty
              ? Center(child: Text("No question banks found"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: questionBankState.questionBanks.length,
                    itemBuilder: (context, index) {
                      final questionBank =
                          questionBankState.questionBanks[index];
                      return TeacherQuestionBank(
                        questionBank: questionBank,
                        onEdit: () {
                          _showQuestionBankDialog(context,
                              questionBank: questionBank);
                        },
                        onDelete: () {
                          _delete(questionBank.id);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
