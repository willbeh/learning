import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/question.dart';
import 'package:learning/services/firestore/answer_service.dart';
import 'package:learning/services/firestore/question_service.dart';
import 'package:learning/services/firestore/watch_service.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatelessWidget {
  final log = getLogger('ExamPage');

  @override
  Widget build(BuildContext context) {
    String vid = '382521859';
    String title = 'Exam';
    FirebaseUser user = Provider.of(context);
    VideoState videoState = Provider.of(context);

    if(videoState != null && videoState.selectedVideoId != null){
      vid = videoState.selectedVideoId;
      title = videoState.selectedVideo.data.name;
    }

    var answerStream = AnswerService.findByUId(uid: user.uid, vid: vid);
    var questionStream = QuestionService.findByVId(id: vid);
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Question>>.value(value: questionStream, lazy: false,
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
  List<Question> _questions;

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
        _questions = questions;
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
            if(_answer != null)
              _buildPageScroll(questions),
          ],
        );
      },
    );
  }

  Widget _buildPageScroll(List<Question> questions){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if(_answer.status == 'completed')
            Text('${_answer.correct}/${questions.length} correct', style: Theme.of(context).textTheme.display2,),
          if(_answer.status != 'completed')
            Text('${questions.length} Questions', style: Theme.of(context).textTheme.display2,),
          CommonUI.widthPadding(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if(_currentPage > 0)
                RaisedButton(
                  child: Icon(Icons.keyboard_arrow_up, color: Colors.white,),
                  onPressed: () => _moveUp(),
                  color: Theme.of(context).primaryColor,
                ),
              CommonUI.widthPadding(width: 2),
              if(_currentPage < (questions.length - 1))
                RaisedButton(
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                  onPressed: () => _moveNext(),
                  color: Theme.of(context).primaryColor,
                ),
              if(_currentPage == (questions.length - 1) && _answer.status != 'completed')
                RaisedButton(
                  child: Text('Submit', style: TextStyle(fontWeight: FontWeight.w600),),
                  onPressed: () => _submitAnswer(),
                  color: Colors.yellow,
                ),
              if(_currentPage == (questions.length - 1) && _answer.status == 'completed')
                RaisedButton(
                  child: Icon(Icons.check, color: Colors.white,),
                  onPressed: () => null,
                  color: Colors.green,
                ),
            ],
          )
        ],
      ),
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

  _submitAnswer(){
    // if not all question is answered, the prompt message and bring to unanswered question
    if(_answer.answers.length < _questions.length){
      CommonUI.alertBox(context, title: 'Answer all question', titleColor: AppColor.redAlert, msg: 'Please answer all questions',
        actions: [
          AppButton.roundedButton(context,
            text: 'Continue',
            paddingVertical: 5,
            textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              for(int i=0; i< _questions.length-1; i++){
                if (!_answer.answers.any((a) => a.qid == _questions[i].id)){
                  _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                  break;
                }
              }
            },
          )
        ]
      );
    } else {
      CommonUI.alertBox(context, title: 'Submit Question', titleColor: Theme.of(context).primaryColor, msg: 'Continue to submit question?',
          actions: [
            AppButton.roundedButton(context,
              text: 'Cancel',
              paddingVertical: 5,
              width: 100,
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.display4.copyWith(color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            AppButton.roundedButton(context,
              text: 'Continue',
              paddingVertical: 5,
              width: 100,
              textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
              onPressed: () {
                _checkAnswers();
//                AnswerService.update(id: _answer.id, data: {'status': 'completed', 'correct': _checkAnswers()});
//                if(Provider.of<VideoState>(context, listen: false).selectedWatch != null){
//                  WatchService.update(
//                    id: Provider.of<VideoState>(context, listen: false).selectedWatch.id,
//                    data: {'test': true}
//                  );
//                }
                Navigator.pop(context);
              },
            )
          ]
      );
    }
  }

  _checkAnswers(){
    int count = 0;
    for(int i = 0; i<_questions.length; i++){
      Question question = _questions[i];
      UserAnswer answer = _answer.answers.where((a) => a.qid == question.id).first;
      if(answer.answer == question.answer){
        count = count + 1;
      }
    }

    final HttpsCallable callable = CloudFunctions(region: 'asia-northeast1').getHttpsCallable(
      functionName: 'updateResult',
    );

    log.d('${{ 'vid': _answer.vid }}');
    _questions.forEach((q) {
      log.d('${q.toJson()}');
    });
    log.d('${{ 'answer': _answer.toJson() }}');

    callable.call(<String, dynamic>{ 'vid': _answer.vid, 'questions': _questions.map((q) => q.toJson()).toList(), 'answer': _answer.toJson() }
    ).then((res) {
      log.d('OK ${res.toString()}');
    }).catchError((error){
      log.w('updateResult error $error}');
    });
    return count;
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
    Color boxColor = Theme.of(context).primaryColor;
    if (widget.answer?.status == 'completed') {
      if(_answer == widget.question.answer){
        boxColor = Colors.green.shade300;
      } else {
        boxColor = Colors.red.shade300;
      }
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.i}) ${widget.question.question}'),
              for(int i=0; i<widget.question.options.length; i++)
                GestureDetector(
                  onTap: () {
                    if(widget.answer.status != 'completed' && _answer != widget.question.options[i].code) {
                      setState(() {
                        _answer = widget.question.options[i].code;
                      });
                      widget.updateAnswer(widget.question.id, widget.question.options[i].code);
                      if(widget.moveNext != null)
                        Future.delayed(Duration(milliseconds: 300), () => widget.moveNext());
                    } else {
                      if(widget.moveNext != null)
                        widget.moveNext();
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: (_answer == widget.question.options[i].code) ? Curves.decelerate : Curves.fastOutSlowIn,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.greyLight),
                        color: (_answer == widget.question.options[i].code) ? boxColor : Colors.white
                    ),
                    child: (widget.answer.status != null && widget.answer.status != 'completed') ?
                    Text('${widget.question.options[i].option}', style: TextStyle(color: (_answer == widget.question.options[i].code) ? Colors.white : Colors.black),) :
                    Row(
                      children: <Widget>[
                        Expanded(child: Text('${widget.question.options[i].option}', style: TextStyle(color: (_answer == widget.question.options[i].code) ? Colors.white : Colors.black),)),
                        if(_answer != widget.question.options[i].code && widget.question.options[i].code == widget.question.answer)
                          Icon(Icons.check_circle, color: Colors.green, size: 20,),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

