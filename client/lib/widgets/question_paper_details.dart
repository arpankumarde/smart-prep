import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/models/question_paper_model.dart';

class QuestionPaperDetails extends StatelessWidget {
  final QuestionPaperModel questionPaper;
  const QuestionPaperDetails({
    super.key,
    required this.questionPaper,
  });
  RichText customText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: AppTheme.gradient2,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.containerBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customText('Paper : ', questionPaper.title),
          customText('Description: ', questionPaper.description),
          customText('Difficulty : ', questionPaper.difficultyLevel),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                  'Questions : ', questionPaper.totalQuestions.toString()),
              customText('Duration : ', questionPaper.duration.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText('Total : ', questionPaper.totalMarks.toString()),
              customText('Passing : ', questionPaper.passingMarks.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
