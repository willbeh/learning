import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/exam.dart';
import 'package:learning/models/exam.service.dart';
import 'package:learning/models/question.dart' as q;
import 'package:learning/models/question.service.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_const.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/models/answer.service.dart';
import 'package:learning/widgets/common_ui.dart';
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

    Stream examStream = examFirebaseService.findOne(query: examFirebaseService.colRef.where('sid', isEqualTo: videoState.selectedSeries.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppTranslate.text(context, 'test_title')}'),
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
        child: ExamQuestions(),
      ),
    );
  }
}

class ExamQuestions extends StatefulWidget {
  @override
  _ExamQuestionsState createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  final log = getLogger('_ExamQuestionsState');
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  Exam _exam;
  Answer _answer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _exam = Provider.of<Exam>(context);
    _answer = Provider.of<Answer>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

//    _exam = widget.exam;
  }

  @override
  Widget build(BuildContext context) {
    if(_exam == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 4,
          child: LinearProgressIndicator(
            value: (_currentPage)/_exam.questions.length,
            backgroundColor: AppColor.greyLight,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) {
              setState(() {
                _currentPage = i;
              });
            },
            children: <Widget>[
              _buildFirstPage(context, _exam),
              for(int i=0; i< _exam.questions.length; i++)
                _buildQuestion(context, _exam.questions[i]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _buildPageNav(context),
        ),
      ],
    );
  }

  Widget _buildPageNav(BuildContext context) {
    if(_currentPage == 0) {
      // first page question description button
      return Center(
        child: AppButton.roundedButton(context,
            height: 48,
            child: Text('${AppTranslate.text(context, 'test_get_started')}', style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white),),

            onPressed: () => _moveUp()
        ),
      );
    } else {
      Color btnColor = (_answer.answers.length < _currentPage) ? Colors.grey : Theme.of(context).primaryColor;
      // navigation previous, page num and next
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text('${AppTranslate.text(context, 'previous')}', style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor),),
            onPressed: () => _moveDown(),
          ),
          Text('$_currentPage/${_exam.questions.length}'),
          AppButton.roundedButton(context,
            height: 48,
            color: btnColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${AppTranslate.text(context, (_currentPage == _exam.questions.length) ? 'test_submit' : 'next')}', style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white),),
                CommonUI.widthPadding(width: 10),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_forward, color: btnColor,),
                )
              ],
            ),
            width: 100,
            onPressed: () {
              if(_answer.answers.length < _currentPage){
                return null;
              }
              if(_currentPage < _exam.questions.length) {
                return _moveUp();
              } else {
                return _submitAnswer();
              }
            }
          )
        ],
      );
    }
  }

  Widget _buildFirstPage(BuildContext context, Exam exam){
    VideoState videoState = Provider.of<VideoState>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TODO get authors
            Text('Someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
            CommonUI.heightPadding(height: 5),
            Text('${videoState.selectedSeries.name}', style: Theme.of(context).textTheme.headline,),
            CommonUI.heightPadding(),
            CachedNetworkImage(
              imageUrl: exam.image,
            ),
            CommonUI.heightPadding(),
            Text('${exam.desc}'),
            CommonUI.heightPadding(),

          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, Question question) {
    if(question.type == AppConstant.single) {
      return _buildSingleQuestion(context, question);
    } else if (question.type == AppConstant.multiple) {
      return _buildMultiQuestion(context, question);
    } else {
      return Container();
    }
  }

  Widget _buildSingleQuestion(BuildContext context, Question question) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${question.question}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(),
            Card(
              elevation: 2,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: question.options.length,
                separatorBuilder: (context, i) => Divider(color: Colors.grey,),
                itemBuilder: (context, i) {
                  return RadioListTile(
                    value: question.options[i].code,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _getAnswer(question.options[i].code, question.code),
                    title: Text('${question.options[i].option}'),
                    onChanged: (val) {
                      _updateAnswer(question.code, [val]);
                      Future.delayed(Duration(milliseconds: 300), () => _moveUp());
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMultiQuestion(BuildContext context, Question question) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${question.question}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(),
            Card(
              elevation: 2,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: question.options.length,
                separatorBuilder: (context, i) => Divider(color: Colors.grey,),
                itemBuilder: (context, i) {
                  return CheckboxListTile(
                    value: _getMutipleAnswer(question.code, question.options[i].code, i),
                    title: Text('${question.options[i].option}'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                      _updateMutipleAnswer(question.code, i, question.options.length, val);
                    },
                    activeColor: Colors.white,
                    checkColor: Theme.of(context).primaryColor,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _updateAnswer(String qid, List<String> answer){
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
      answerFirebaseService.update(id: _answer.id, data: _answer.toJson());
    }
  }
  
  _getAnswer(String code, String qid) {
    for(int i=0; i<_answer.answers.length; i++){
      if(_answer.answers[i].qid == qid){
        return _answer.answers[i].answer[0];
      }
    }
    return null;
  }

  _getMutipleAnswer(String qid, String code, int i){
    for(int x=0; x<_answer.answers.length; x++){
      if(_answer.answers[x].qid == qid){
        return _answer.answers[x].answer[i] == 'true';
      }
    }

    return false;
  }

  _updateMutipleAnswer(String qid, int i, int total, bool val){
    bool exist = false;

    for(int x=0; x<_answer.answers.length; x++){
      if(_answer.answers[x].qid == qid){
        exist = true;
        _answer.answers[x].answer[i] = val.toString();
        break;
      }
    }

    if(!exist){
      List<String> answer = [];
      for(int j=0; j<total; j++){
        answer.add((j == i) ? 'true' : 'false');
      }
      _answer.answers.add(UserAnswer(qid: qid, answer: answer));
    }

    if(_answer.id != null && _answer.id != '') {
      answerFirebaseService.update(id: _answer.id, data: _answer.toJson());
    }
  }

  _submitAnswer(){
    // if not all question is answered, the prompt message and bring to unanswered question
    if(_answer.answers.length < _exam.questions.length){
      CommonUI.alertBox(context, title: 'Answer all question', titleColor: AppColor.redAlert, msg: 'Please answer all questions',
          actions: [
            AppButton.roundedButton(context,
              height: 28,
              text: 'Continue',
              paddingVertical: 5,
              textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                for(int i=0; i< _exam.questions.length-1; i++){
                  if (!_answer.answers.any((a) => a.qid == _exam.questions[i].code)){
                    _controller.animateToPage(i+1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
              height: 28,
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
              height: 28,
              text: 'Continue',
              paddingVertical: 5,
              width: 100,
              textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
              onPressed: () {
                _checkAnswers();
                _answer.status = 'completed';
                _answer.correct = _checkAnswers();
                _answer.min = 10;// widget.video.min;
                answerFirebaseService.update(id: _answer.id, data: _answer.toJson());
//                if(Provider.of<VideoState>(context, listen: false).selectedWatch != null){
//                  watchFirebaseService.update(
//                      id: Provider.of<VideoState>(context, listen: false).selectedWatch.id,
//                      data: {'test': true}
//                  ).catchError((error) => log.d('error WatchService update $error'));
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
    for(int i = 0; i<_exam.questions.length; i++){
      Question question = _exam.questions[i];
      UserAnswer answer = _answer.answers.where((a) => a.qid == question.code).first;
      if(answer.answer == question.answer){
        count = count + 1;
      }
    }

    // TODO update function

//    final HttpsCallable callable = CloudFunctions(region: 'asia-northeast1').getHttpsCallable(
//      functionName: 'updateResult',
//    );
//
//    callable.call(<String, dynamic>{ 'vid': _answer.sid, 'min': 10, 'questions': _questions.map((q) => q.toJson()).toList(), 'answer': _answer.toJson() }
//    ).then((res) {
//      log.d('OK ${res.toString()}');
//    }).catchError((error){
//      log.w('updateResult error $error}');
//    });
    return count;
  }

  _moveDown(){
    if(_controller.page > 0){
      _controller.animateToPage(_controller.page.toInt() - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn);
    }
  }

  _moveUp(){
    _controller.animateToPage(_controller.page.toInt() + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  // temp generate questions
  _getQues(BuildContext context) async{
    List<q.Question> questions = await questionFirebaseService.find(
        query: questionFirebaseService.colRef.where('vid', isEqualTo: '382117382').orderBy('order')
    ).first;

    questions.forEach((question) {
      Map qm = question.toJson();
      qm['code'] = qm['id'];
      qm.remove('id');
      qm.remove('vid');
      qm.remove('status');
      qm.remove('order');
      qm.remove('correct');
      qm.remove('wrong');
      qm['type'] = AppConstant.single;
      qm['answer'] = [qm['answer']];
      List options = qm['options'];
      List no = [];

      for(int i=0; i<options.length; i++) {
        Map m = qm['options'][i];
        m.remove('type');
        m.remove('selected');
        no.add(m);
      }

      qm['options'] = no;

      Question ques = Question.fromJson(qm);
      _exam.questions.add(ques);
    });

    log.d('${_exam.toJson()}');

    examFirebaseService.update(id: _exam.id, data: _exam.toJson());


  }
}

