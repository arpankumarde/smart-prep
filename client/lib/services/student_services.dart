import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_prep/constants/constants.dart';
import 'package:smart_prep/models/student_paper_model.dart';

class StudentServices {
  final baseURL = Constants.baseURL;

  Future<List<StudentPaperModel>> getAvailableQuestionPapers({
    required int page,
    required int size,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/available?page=$page&size=$size');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final papers = (data['content'] as List).map((json) {
        return StudentPaperModel.fromMap(json);
      }).toList();
      return papers;
    } else {
      throw Exception(
        'Failed to load available question papers: ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> startQuizAttempt({
    required int questionPaperId,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/start/$questionPaperId');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to start quiz attempt: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getQuizAttemptDetails({
    required int attemptId,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempt/$attemptId/answer');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get quiz attempt details: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> submitAnswer({
    required int attemptId,
    required Map<String, dynamic> answerPayload,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempt/$attemptId/answer');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(answerPayload));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to submit answer: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> submitQuizAttempt({
    required int attemptId,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempt/$attemptId/submit');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to submit quiz attempt: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getQuizResult({
    required int attemptId,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/result/$attemptId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get quiz result: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getStudentAttempts({
    required int page,
    required int size,
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempts?page=$page&size=$size');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get student attempts: ${response.body}');
    }
  }

  Future<List<dynamic>> getCompletedAttempts({
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempts/completed');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).toList();
    } else {
      throw Exception('Failed to get completed attempts: ${response.body}');
    }
  }

  Future<List<dynamic>> getIncompleteAttempts({
    required String token,
  }) async {
    final url = Uri.parse('$baseURL/quiz/attempts/incomplete');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).toList();
    } else {
      throw Exception('Failed to get incomplete attempts: ${response.body}');
    }
  }
}
