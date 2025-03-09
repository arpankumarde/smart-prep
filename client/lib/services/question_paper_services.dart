import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_prep/constants/constants.dart';
import 'package:smart_prep/models/question_paper_model.dart';

class QuestionPaperServices {
  final baseURL = Constants.baseURL;

  Future<QuestionPaperModel> createQuestionPaper({
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
    final response = await http.post(
      Uri.parse('$baseURL/question-papers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'questionBankId': questionBankId,
        'duration': duration,
        'totalQuestions': totalQuestions,
        'difficultyLevel': difficultyLevel,
        'totalMarks': totalMarks,
        'passingMarks': passingMarks,
        'published': published,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return QuestionPaperModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<List<QuestionPaperModel>> getAllQuestionPapersByBank({
    required int questionBankId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseURL/question-papers/bank/$questionBankId/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedBody as List)
          .map((item) => QuestionPaperModel.fromMap(item))
          .toList();
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionPaperModel> getQuestionPaperById({
    required int id,
    required String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseURL/question-papers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionPaperModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionPaperModel> updateQuestionPaper({
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
    final response = await http.put(
      Uri.parse('$baseURL/question-papers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'questionBankId': questionBankId,
        'duration': duration,
        'totalQuestions': totalQuestions,
        'difficultyLevel': difficultyLevel,
        'totalMarks': totalMarks,
        'passingMarks': passingMarks,
        'published': published,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionPaperModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<void> togglePublishStatus({
    required int id,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseURL/question-papers/$id/publish'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final decodedBody = jsonDecode(response.body);
      throw Exception(decodedBody);
    }
  }

  Future<void> deleteQuestionPaper({
    required int id,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseURL/question-papers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final decodedBody = jsonDecode(response.body);
      throw Exception(decodedBody);
    }
  }
}
