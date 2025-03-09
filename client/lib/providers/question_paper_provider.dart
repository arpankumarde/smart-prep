import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_paper_model.dart';
import 'package:smart_prep/services/question_paper_services.dart';

class QuestionPaperState {
  final bool isLoading;
  final String? error;
  final List<QuestionPaperModel> questionPapers;
  final QuestionPaperModel? selectedQuestionPaper;

  QuestionPaperState({
    this.isLoading = false,
    this.error,
    this.questionPapers = const [],
    this.selectedQuestionPaper,
  });

  QuestionPaperState copyWith({
    bool? isLoading,
    String? error,
    List<QuestionPaperModel>? questionPapers,
    QuestionPaperModel? selectedQuestionPaper,
  }) {
    return QuestionPaperState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      questionPapers: questionPapers ?? this.questionPapers,
      selectedQuestionPaper:
          selectedQuestionPaper ?? this.selectedQuestionPaper,
    );
  }
}

class QuestionPaperNotifier extends StateNotifier<QuestionPaperState> {
  final QuestionPaperServices _questionPaperServices;

  QuestionPaperNotifier(this._questionPaperServices)
      : super(QuestionPaperState());

  Future<void> createQuestionPaper({
    required String title,
    required String description,
    required int questionBankId,
    required int duration,
    required int totalQuestions,
    required String difficultyLevel,
    required int totalMarks,
    required int passingMarks,
    required bool published,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionPaper = await _questionPaperServices.createQuestionPaper(
        title: title,
        description: description,
        questionBankId: questionBankId,
        duration: duration,
        totalQuestions: totalQuestions,
        difficultyLevel: difficultyLevel,
        totalMarks: totalMarks,
        passingMarks: passingMarks,
        published: published,
        token: token,
      );

      state = state.copyWith(
        isLoading: false,
        questionPapers: [...state.questionPapers, questionPaper],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllQuestionPapersByBank({
    required int questionBankId,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionPapers =
          await _questionPaperServices.getAllQuestionPapersByBank(
        questionBankId: questionBankId,
        token: token,
      );

      state = state.copyWith(
        isLoading: false,
        questionPapers: questionPapers,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getQuestionPaperById(int id, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionPaper = await _questionPaperServices.getQuestionPaperById(
        id: id,
        token: token,
      );

      state = state.copyWith(
        isLoading: false,
        selectedQuestionPaper: questionPaper,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateQuestionPaper({
    required int id,
    required String title,
    required String description,
    required int questionBankId,
    required int duration,
    required int totalQuestions,
    required String difficultyLevel,
    required int totalMarks,
    required int passingMarks,
    required bool published,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedQuestionPaper =
          await _questionPaperServices.updateQuestionPaper(
        id: id,
        title: title,
        description: description,
        questionBankId: questionBankId,
        duration: duration,
        totalQuestions: totalQuestions,
        difficultyLevel: difficultyLevel,
        totalMarks: totalMarks,
        passingMarks: passingMarks,
        published: published,
        token: token,
      );

      final updatedList = state.questionPapers.map((qp) {
        return qp.id == id ? updatedQuestionPaper : qp;
      }).toList();

      state = state.copyWith(
        isLoading: false,
        questionPapers: updatedList,
        selectedQuestionPaper: updatedQuestionPaper,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> togglePublishStatus(int id, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _questionPaperServices.togglePublishStatus(
        id: id,
        token: token,
      );

      final updatedList = state.questionPapers.map((qp) {
        if (qp.id == id) {
          return qp.copyWith(published: !qp.published);
        }
        return qp;
      }).toList();

      state = state.copyWith(
        isLoading: false,
        questionPapers: updatedList,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteQuestionPaper(int id, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _questionPaperServices.deleteQuestionPaper(id: id, token: token);

      state = state.copyWith(
        isLoading: false,
        questionPapers:
            state.questionPapers.where((qb) => qb.id != id).toList(),
        selectedQuestionPaper: state.selectedQuestionPaper?.id == id
            ? null
            : state.selectedQuestionPaper,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final questionPaperServicesProvider =
    Provider((ref) => QuestionPaperServices());

final questionPaperProvider =
    StateNotifierProvider<QuestionPaperNotifier, QuestionPaperState>((ref) {
  final questionPaperServices = ref.watch(questionPaperServicesProvider);
  return QuestionPaperNotifier(questionPaperServices);
});
