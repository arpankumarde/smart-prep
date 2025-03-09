import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/student_paper_model.dart';
import 'package:smart_prep/services/student_services.dart';

class StudentState {
  final bool isLoading;
  final String? error;
  final List<StudentPaperModel> availableQuestionPapers;
  final Map<String, dynamic>? quizAttemptDetails;
  final Map<String, dynamic>? quizResult;
  final Map<String, dynamic>? studentAttempts;
  final List<dynamic> completedAttempts;
  final List<dynamic> incompleteAttempts;

  StudentState({
    this.isLoading = false,
    this.error,
    this.availableQuestionPapers = const [],
    this.quizAttemptDetails,
    this.quizResult,
    this.studentAttempts,
    this.completedAttempts = const [],
    this.incompleteAttempts = const [],
  });

  StudentState copyWith({
    bool? isLoading,
    String? error,
    List<StudentPaperModel>? availableQuestionPapers,
    Map<String, dynamic>? quizAttemptDetails,
    Map<String, dynamic>? quizResult,
    Map<String, dynamic>? studentAttempts,
    List<dynamic>? completedAttempts,
    List<dynamic>? incompleteAttempts,
  }) {
    return StudentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      availableQuestionPapers:
          availableQuestionPapers ?? this.availableQuestionPapers,
      quizAttemptDetails: quizAttemptDetails ?? this.quizAttemptDetails,
      quizResult: quizResult ?? this.quizResult,
      studentAttempts: studentAttempts ?? this.studentAttempts,
      completedAttempts: completedAttempts ?? this.completedAttempts,
      incompleteAttempts: incompleteAttempts ?? this.incompleteAttempts,
    );
  }
}

class StudentNotifier extends StateNotifier<StudentState> {
  final StudentServices _service;
  StudentNotifier(this._service) : super(StudentState());

  Future<void> getAvailableQuestionPapers(String token,
      {int page = 0, int size = 10}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final papers = await _service.getAvailableQuestionPapers(
          page: page, size: size, token: token);
      state = state.copyWith(isLoading: false, availableQuestionPapers: papers);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> startQuizAttempt(int questionPaperId, String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final details = await _service.startQuizAttempt(
          questionPaperId: questionPaperId, token: token);
      state = state.copyWith(isLoading: false, quizAttemptDetails: details);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getQuizAttemptDetails(int attemptId, String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final details = await _service.getQuizAttemptDetails(
          attemptId: attemptId, token: token);
      state = state.copyWith(isLoading: false, quizAttemptDetails: details);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAnswer(String token,
      {required int attemptId,
      required Map<String, dynamic> answerPayload}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _service.submitAnswer(
          attemptId: attemptId, answerPayload: answerPayload, token: token);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitQuizAttempt(int attemptId, String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result =
          await _service.submitQuizAttempt(attemptId: attemptId, token: token);
      state = state.copyWith(isLoading: false, quizResult: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getQuizResult(int attemptId, String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result =
          await _service.getQuizResult(attemptId: attemptId, token: token);
      state = state.copyWith(isLoading: false, quizResult: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getStudentAttempts(String token,
      {int page = 0, int size = 10}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final attempts = await _service.getStudentAttempts(
          page: page, size: size, token: token);
      state = state.copyWith(isLoading: false, studentAttempts: attempts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getCompletedAttempts(String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final attempts = await _service.getCompletedAttempts(token: token);
      state = state.copyWith(isLoading: false, completedAttempts: attempts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getIncompleteAttempts(String token) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final attempts = await _service.getIncompleteAttempts(token: token);
      state = state.copyWith(isLoading: false, incompleteAttempts: attempts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final studentsServicesProvider = Provider((ref) => StudentServices());

final studentNotifierProvider =
    StateNotifierProvider<StudentNotifier, StudentState>(
  (ref) {
    final service = ref.watch(studentsServicesProvider);
    return StudentNotifier(service);
  },
);
