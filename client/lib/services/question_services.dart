import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_prep/constants/constants.dart';
import 'package:smart_prep/models/question_model.dart';

class QuestionServices {
  final baseURL = Constants.baseURL;

  Future<QuestionModel> createMCQQuestion({
    required String token,
    required int questionPaperId,
    required String questionText,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    required List<String> options,
    required int correctOptionIndex,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/questions/paper/$questionPaperId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': 'MCQ',
        'difficultyLevel': difficultyLevel,
        'marks': marks,
        'expectedTimeSeconds': expectedTimeSeconds,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
      }),
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return QuestionModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionModel> createSAQQuestion({
    required String token,
    required int questionPaperId,
    required String questionText,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    required String modelAnswer,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/questions/paper/$questionPaperId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': 'SAQ',
        'difficultyLevel': difficultyLevel,
        'marks': marks,
        'expectedTimeSeconds': expectedTimeSeconds,
        'modelAnswer': modelAnswer,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return QuestionModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<Map<String, dynamic>> getQuestionsByPaper({
    required String token,
    required int questionPaperId,
    int page = 0,
    int size = 10,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$baseURL/questions/paper/$questionPaperId?page=$page&size=$size'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<List<QuestionModel>> getAllQuestionsByPaper({
    required String token,
    required int questionPaperId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseURL/questions/paper/$questionPaperId/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedBody as List)
          .map((item) => QuestionModel.fromMap(item))
          .toList();
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionModel> getQuestionById({
    required String token,
    required int id,
  }) async {
    final response = await http.get(
      Uri.parse('$baseURL/questions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionModel> updateQuestion({
    required String token,
    required int id,
    required String questionText,
    required String questionType,
    required String difficultyLevel,
    required int marks,
    required int expectedTimeSeconds,
    List<String>? options,
    int? correctOptionIndex,
    String? modelAnswer,
  }) async {
    final response = await http.put(
      Uri.parse('$baseURL/questions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': questionType,
        'difficultyLevel': difficultyLevel,
        'marks': marks,
        'expectedTimeSeconds': expectedTimeSeconds,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'modelAnswer': modelAnswer,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<void> deleteQuestion({
    required String token,
    required int id,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseURL/questions/$id'),
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
