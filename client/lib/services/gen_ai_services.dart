import 'dart:convert';
import 'package:http/http.dart' as http;

class GenAiService {
  final String baseUrl = "http://localhost:10000";

  Future<Map<String, dynamic>> analyseStudent(String data) async {
    final url = Uri.parse(
        '$baseUrl/analyse-student-1/?data=${Uri.encodeComponent(data)}');
    final response = await http.get(url);
    return jsonDecode(response.body)['response'];
  }

  Future<Map<String, dynamic>> studyMaterial(String data) async {
    final url =
        Uri.parse('$baseUrl/study-material/?data=${Uri.encodeComponent(data)}');
    final response = await http.get(url);
    return jsonDecode(response.body)['response'];
  }

  Future<Map<String, dynamic>> getTranscript(String data) async {
    final url =
        Uri.parse('$baseUrl/get-transcript/?data=${Uri.encodeComponent(data)}');
    final response = await http.get(url);
    return jsonDecode(response.body)['response'];
  }

  Future<Map<String, dynamic>> generateQuestion(String data) async {
    final url = Uri.parse(
        '$baseUrl/generate-question/?data=${Uri.encodeComponent(data)}');
    final response = await http.get(url);
    return jsonDecode(response.body)['response'];
  }
}
