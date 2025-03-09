import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/services/gen_ai_services.dart';

final genAiServiceProvider = Provider<GenAiService>((ref) {
  return GenAiService();
});

final analyseStudentProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, data) async {
  final service = ref.watch(genAiServiceProvider);
  return await service.analyseStudent(data);
});

final studyMaterialProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, data) async {
  final service = ref.watch(genAiServiceProvider);
  return await service.studyMaterial(data);
});

final transcriptProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, data) async {
  final service = ref.watch(genAiServiceProvider);
  return await service.getTranscript(data);
});

final generateQuestionProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, data) async {
  final service = ref.watch(genAiServiceProvider);
  return await service.generateQuestion(data);
});
