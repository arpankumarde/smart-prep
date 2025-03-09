import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/question_bank_model.dart';
import 'package:smart_prep/services/question_bank_services.dart';

class QuestionBankState {
  final bool isLoading;
  final String? error;
  final List<QuestionBankModel> questionBanks;
  final QuestionBankModel? selectedQuestionBank;

  QuestionBankState({
    this.isLoading = false,
    this.error,
    this.questionBanks = const [],
    this.selectedQuestionBank,
  });

  QuestionBankState copyWith({
    bool? isLoading,
    String? error,
    List<QuestionBankModel>? questionBanks,
    QuestionBankModel? selectedQuestionBank,
  }) {
    return QuestionBankState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      questionBanks: questionBanks ?? this.questionBanks,
      selectedQuestionBank: selectedQuestionBank ?? this.selectedQuestionBank,
    );
  }
}

class QuestionBankNotifier extends StateNotifier<QuestionBankState> {
  final QuestionBankServices _questionBankServices;

  QuestionBankNotifier(this._questionBankServices) : super(QuestionBankState());

  Future<void> createQuestionBank({
    required String name,
    required String subject,
    required String description,
    required bool isPublic,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionBank = await _questionBankServices.createQuestionBank(
          name: name,
          subject: subject,
          description: description,
          isPublic: isPublic,
          token: token);

      state = state.copyWith(
        isLoading: false,
        questionBanks: [...state.questionBanks, questionBank],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllMyQuestionBanks({required String token}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionBanks =
          await _questionBankServices.getAllMyQuestionBanks(token: token);


      state = state.copyWith(
        isLoading: false,
        questionBanks: questionBanks,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getQuestionBankById(int id, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questionBank =
          await _questionBankServices.getQuestionBankById(id: id, token: token);

      state = state.copyWith(
        isLoading: false,
        selectedQuestionBank: questionBank,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateQuestionBank({
    required int id,
    required String name,
    required String description,
    required bool isPublic,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedQuestionBank =
          await _questionBankServices.updateQuestionBank(
              id: id,
              name: name,
              description: description,
              isPublic: isPublic,
              token: token);

      final updatedList = state.questionBanks.map((qb) {
        return qb.id == id ? updatedQuestionBank : qb;
      }).toList();

      state = state.copyWith(
        isLoading: false,
        questionBanks: updatedList,
        selectedQuestionBank: updatedQuestionBank,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteQuestionBank(int id, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _questionBankServices.deleteQuestionBank(id: id, token: token);

      state = state.copyWith(
        isLoading: false,
        questionBanks: state.questionBanks.where((qb) => qb.id != id).toList(),
        selectedQuestionBank: state.selectedQuestionBank?.id == id
            ? null
            : state.selectedQuestionBank,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final questionBankServicesProvider = Provider((ref) => QuestionBankServices());

final questionBankProvider =
    StateNotifierProvider<QuestionBankNotifier, QuestionBankState>((ref) {
  final questionBankServices = ref.watch(questionBankServicesProvider);
  return QuestionBankNotifier(questionBankServices);
});
