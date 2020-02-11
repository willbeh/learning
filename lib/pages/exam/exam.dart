import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/exam.dart';
import 'package:learning/models/exam.service.dart';
import 'package:learning/pages/exam/exam_answer.dart';
import 'package:learning/pages/exam/exam_question.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_const.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/models/answer.service.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatelessWidget {
  final log = getLogger('ExamPage');

  @override
  Widget build(BuildContext context) {
    VideoState videoState = Provider.of<VideoState>(context, listen: false);
    FirebaseUser user = Provider.of(context);

    var answerStream = answerFirebaseService.findOne(
      query: answerFirebaseService.colRef.where('uid', isEqualTo: user.uid).where('sid', isEqualTo: videoState.selectedSeries.id ),
    );

    Stream<Exam> examStream = examFirebaseService.findOne(query: examFirebaseService.colRef.where('sid', isEqualTo: videoState.selectedSeries.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('(${AppTranslate.text(context, 'test_title')}) ${videoState.selectedSeries.name}'),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<Exam>.value(value: examStream, lazy: false,
            catchError: (_, error) {
              log.d('examStream error $error');
              return;
            },
          ),
          StreamProvider<Answer>.value(value: answerStream, lazy: false,
            catchError: (_, error) {
              if(error.toString().contains('No element')) {
                // create an answer if it does not exist
                Answer tempAnswer = Answer(
                    uid: user.uid,
                    sid: videoState.selectedSeries.id,
                    status: '',
                    answers: []
                );
                answerFirebaseService.insert(data: tempAnswer.toJson());
              }
              log.d('answerStream error $error');
              return;
            },
          )
        ],
        child: Consumer<Answer>(
          builder: (_, answer, child) {
            if(answer == null)
              return Container();
            return (answer.status == AppConstant.completed) ? ExamAnswer() :
              ExamQuestions();
          },
        ),
//        child: (Provider.of<Answer>(context, listen: false) == null || Provider.of<Answer>(context, listen: false).status != AppConstant.completed) ? ExamQuestions() : ExamAnswer(),
      ),
    );
  }
}

