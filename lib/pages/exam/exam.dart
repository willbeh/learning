import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/question.dart';
import 'package:learning/services/firestore/answer_service.dart';
import 'package:learning/services/firestore/question_service.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/logger.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatelessWidget {
  final log = getLogger('ExamPage');

  @override
  Widget build(BuildContext context) {
    String vid = '382521859';
    String title = 'Exam';
    FirebaseUser user = Provider.of(context);
    VimeoState vimeoState = Provider.of(context);

    if(vimeoState != null && vimeoState.selectedVideoId != null){
      vid = vimeoState.selectedVideoId;
      title = vimeoState.selectedVideo.name;
    }

    log.d('vid $vid');

    var answerStream = AnswerService.findByUId(uid: user.uid, vid: vid);
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Question>>(create: (_) => QuestionService.find(), lazy: false,
            catchError: (_, error) {
              log.d('QuestionService error $error');
              return;
            },
          ),
          StreamProvider<Answer>.value(value: answerStream, lazy: false,
            catchError: (_, error) {
              if(error.toString().contains('No element'))
                AnswerService.insert({
                  'uid': user.uid,
                  'vid': vid,
                  'status': 'draft',
                  'answers': [],
                });
              log.d('answerStream error $error');
              return;
            },
          ),
        ],
        child: ExamDetail(),
      ),
    );
  }
}

class ExamDetail extends StatefulWidget {
  @override
  _ExamDetailState createState() => _ExamDetailState();
}

class _ExamDetailState extends State<ExamDetail> {

  final PageController _controller = PageController(initialPage: 0);
  var log = getLogger('_ExamDetailState');
  int _currentPage = 0;
  Answer _answer;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _answer = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Question>>(
      builder: (_, questions, child) {
        if(questions == null || questions.length == 0)
          return Center(child: CircularProgressIndicator(),);

        return Column(
          children: <Widget>[
            if(_controller != null)
              LinearProgressIndicator(
                value: (_currentPage+1)/questions.length,
                backgroundColor: AppColor.greyLight,
              ),
            Expanded(
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                onPageChanged: (i) {
                  setState(() {
                    _currentPage = i;
                  });
                },
                children: <Widget>[
                  for(int i=0; i<questions.length; i++)
                    ExamQuestion(
                      i: i+1,
                      question: questions[i],
                      answer: _answer,
                      moveUp: (i > 0) ? _moveUp : null,
                      moveNext: ((i+1) < questions.length) ? _moveNext: null,
                      updateAnswer: _updateAnswer,
                    ) ,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _updateAnswer(String qid, String answer){
    bool exist = false;
    for(int i=0; i<_answer.answers.length; i++){
      if(_answer.answers[i].qid == qid){
        exist = true;
        _answer.answers[i].answer = answer;
        break;
      }
    }
    if(!exist){
      _answer.answers.add(UserAnswer(qid: qid, answer: answer));
    }

    if(_answer.id != null && _answer.id != '') {
      AnswerService.update(id: _answer.id, data: _answer.toJson());
    }
//    log.d('answer - ${_answer.answers.length} - ${_answer.toJson()}');
  }

  _moveUp(){
    if(_controller.page > 0){
      _controller.animateToPage(_controller.page.toInt() - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn);
    }
  }

  _moveNext(){
    _controller.animateToPage(_controller.page.toInt() + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }
}


class ExamQuestion extends StatefulWidget {
  final int i;
  final Question question;
  final Answer answer;
  final Function moveUp;
  final Function moveNext;
  final Function updateAnswer;

  ExamQuestion({this.i, @required this.question, this.answer, this.moveUp, this.moveNext, this.updateAnswer});
  @override
  _ExamQuestionState createState() => _ExamQuestionState();
}

class _ExamQuestionState extends State<ExamQuestion> {
  String _answer;
  var log = getLogger('_ExamQuestionState');

  @override
  void initState() {
    super.initState();
    if(widget.answer != null){
      for(int i=0; i<widget.answer.answers.length; i++) {
        if(widget.answer.answers[i].qid == widget.question.id) {
          _answer = widget.answer.answers[i].answer;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.i}) ${widget.question.question}'),
              for(int i=0; i<widget.question.answers.length; i++)
                ListTile(
                  title: Text(widget.question.answers[i].answer),
                  leading: Radio(
                    value: widget.question.answers[i].ansCode,
                    groupValue: _answer,
                    onChanged: (value) {
                      setState(() { _answer = value; });
                      widget.updateAnswer(widget.question.id, value);
                      if(widget.moveNext != null)
                        Future.delayed(Duration(milliseconds: 300), () => widget.moveNext());
                    },
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if(widget.moveUp != null)
                  RaisedButton(
                    child: Icon(Icons.keyboard_arrow_up),
                    onPressed: () => widget.moveUp(),
                    color: Theme.of(context).primaryColor,
                  ),
                if(widget.moveNext != null)
                  RaisedButton(
                    child: Icon(Icons.keyboard_arrow_down),
                    onPressed: () => widget.moveNext(),
                    color: Theme.of(context).primaryColor,
                  ),
                if(widget.moveNext == null)
                  RaisedButton(
                    child: Icon(Icons.done),
                    onPressed: () => null,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkAnswer(String answer) async{
    log.d('checkAnswer');
    final HttpsCallable callable = CloudFunctions(region: 'asia-northeast1').getHttpsCallable(
      functionName: 'checkAnswer',
    );
    log.d('callable');
    HttpsCallableResult resp = await callable.call(<String, dynamic>{
      'qid': 'YOUR_PARAMETER_VALUE',
      'answer': 'answer'
    }).catchError((error) {
      log.w('call error $error');
    });
    log.d('resp $resp');
  }
}

