import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_model.dart';
import 'package:smart_prep/services/question_services.dart';

class QuestionState {
  final bool isLoading;
  final String? error;
  final List<QuestionModel> questions;

  QuestionState({
    this.isLoading = false,
    this.error,
    this.questions = const [],
  });

  QuestionState copyWith({
    bool? isLoading,
    String? error,
    List<QuestionModel>? questions,
  }) {
    return QuestionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      questions: questions ?? this.questions,
    );
  }
}

class QuestionNotifier extends StateNotifier<QuestionState> {
  final QuestionServices _questionServices;

  QuestionNotifier(this._questionServices) : super(QuestionState());

  Future<void> addMCQQuestion({
    required int questionPaperId,
    required String questionText,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    required List<String> options,
    required int correctOptionIndex,
    required String? token,
  }) async {
    if (token == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final question = await _questionServices.createMCQQuestion(
        token: token,
        questionPaperId: questionPaperId,
        questionText: questionText,
        difficultyLevel: difficultyLevel,
        marks: marks,
        expectedTimeSeconds: expectedTimeSeconds,
        options: options,
        correctOptionIndex: correctOptionIndex,
      );
      state = state.copyWith(
        isLoading: false,
        questions: [...state.questions, question],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addSAQQuestion({
    required int questionPaperId,
    required String questionText,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    required String modelAnswer,
    required String? token,
  }) async {
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final question = await _questionServices.createSAQQuestion(
        token: token,
        questionPaperId: questionPaperId,
        questionText: questionText,
        difficultyLevel: difficultyLevel,
        marks: marks,
        expectedTimeSeconds: expectedTimeSeconds,
        modelAnswer: modelAnswer,
      );

      state = state.copyWith(
        isLoading: false,
        questions: [...state.questions, question],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getQuestionsByPaper(int questionPaperId, String? token) async {
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions = await _questionServices.getAllQuestionsByPaper(
        token: token,
        questionPaperId: questionPaperId,
      );

      state = state.copyWith(
        isLoading: false,
        questions: questions,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateQuestion({
    required int id,
    required String questionText,
    required String questionType,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    List<String>? options,
    int? correctOptionIndex,
    String? modelAnswer,
    required String? token,
  }) async {
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedQuestion = await _questionServices.updateQuestion(
        token: token,
        id: id,
        questionText: questionText,
        questionType: questionType,
        difficultyLevel: difficultyLevel,
        marks: marks,
        expectedTimeSeconds: expectedTimeSeconds,
        options: options,
        correctOptionIndex: correctOptionIndex,
        modelAnswer: modelAnswer,
      );

      final updatedList = state.questions.map((q) {
        return q.id == id ? updatedQuestion : q;
      }).toList();

      state = state.copyWith(
        isLoading: false,
        questions: updatedList,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteQuestion(int id, String? token) async {
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _questionServices.deleteQuestion(
        token: token,
        id: id,
      );

      state = state.copyWith(
        isLoading: false,
        questions: state.questions.where((q) => q.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Providers
final questionServicesProvider = Provider((ref) => QuestionServices());

final questionProvider =
    StateNotifierProvider<QuestionNotifier, QuestionState>((ref) {
  final questionServices = ref.watch(questionServicesProvider);
  return QuestionNotifier(questionServices);
});
