import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_prep/constants/constants.dart';
import 'package:smart_prep/models/question_bank_model.dart';

class QuestionBankServices {
  final baseURL = Constants.baseURL;
  Future<QuestionBankModel> createQuestionBank({
    required String name,
    required String subject,
    required String description,
    required bool isPublic,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/question-banks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'subject': subject,
        'description': description,
        'public': isPublic,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return QuestionBankModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<List<QuestionBankModel>> getAllMyQuestionBanks(
      {required String token}) async {
    final response = await http.get(
      Uri.parse('$baseURL/question-banks/my-banks/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedBody as List)
          .map((item) => QuestionBankModel.fromMap(item))
          .toList();
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionBankModel> getQuestionBankById({
    required int id,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseURL/question-banks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionBankModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<QuestionBankModel> updateQuestionBank({
    required int id,
    required String name,
    required String description,
    required bool isPublic,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseURL/question-banks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'public': isPublic,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuestionBankModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<void> deleteQuestionBank({
    required int id,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseURL/question-banks/$id'),
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
