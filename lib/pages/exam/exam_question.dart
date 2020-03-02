import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/exam.dart';
import 'package:learning/models/series_watch.service.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_const.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/models/answer.service.dart';
import 'package:learning/widgets/app_series_authors.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class ExamQuestions extends StatefulWidget {
  @override
  _ExamQuestionsState createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  final Logger log = getLogger('_ExamQuestionsState');
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
            value: _currentPage/_exam.questions.length,
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
          padding: const EdgeInsets.all(20),
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
      final Color btnColor = (_answer.answers.length < _currentPage) ? Colors.grey : Theme.of(context).primaryColor;
      // navigation previous, page num and next
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () => _moveDown(),
            child: Text('${AppTranslate.text(context, 'previous')}', style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,),),
          ),
          Text('$_currentPage/${_exam.questions.length}', style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,),),
          AppButton.roundedButton(context,
              height: 48,
              color: btnColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${AppTranslate.text(context, (_currentPage == _exam.questions.length) ? 'test_submit' : 'next')}',
                    style: Theme.of(context).textTheme.display2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(_currentPage < _exam.questions.length)
                    CommonUI.widthPadding(width: 10),
                  if(_currentPage < _exam.questions.length)
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_forward, color: btnColor,),
                    )
                ],
              ),
              width: 90,
              onPressed: () {
                if(_answer.answers.length < _currentPage){
                  return;
                }
                if(_currentPage < _exam.questions.length) {
                  _moveUp();
                } else {
                  _submitAnswer();
                }
              }
          )
        ],
      );
    }
  }

  Widget _buildFirstPage(BuildContext context, Exam exam){
    final VideoState videoState = Provider.of<VideoState>(context);

    return SingleChildScrollView(
      key: UniqueKey(),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppSeriesAuthors(videoState.selectedSeries.authors),
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
    if(question.type == constSingle) {
      return _buildSingleQuestion(context, question);
    } else if (question.type == constMultiple) {
      return _buildMultiQuestion(context, question);
    } else {
      return Container();
    }
  }

  Widget _buildSingleQuestion(BuildContext context, Question question) {
    return SingleChildScrollView(
      key: UniqueKey(),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${question.question}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(),
            Card(
              elevation: 2,
              child: ListView.separated(
                key: UniqueKey(),
                shrinkWrap: true,
                itemCount: question.options.length,
                separatorBuilder: (context, i) => const Divider(color: Colors.grey,),
                itemBuilder: (context, i) {
                  return RadioListTile(
                    value: question.options[i].code,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _getAnswer(question.options[i].code, question.code),
                    title: Text('${question.options[i].option}'),
                    onChanged: (val) {
                      _updateAnswer(question.code, [val as String]);
                      Future.delayed(const Duration(milliseconds: 300), () => _moveUp());
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
      key: UniqueKey(),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${question.question}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(),
            Card(
              elevation: 2,
              child: ListView.separated(
                key: UniqueKey(),
                shrinkWrap: true,
                itemCount: question.options.length,
                separatorBuilder: (context, i) => const Divider(color: Colors.grey,),
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

  void _updateAnswer(String qid, List<String> answer){
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

  String _getAnswer(String code, String qid) {
    for(int i=0; i<_answer.answers.length; i++){
      if(_answer.answers[i].qid == qid){
        return _answer.answers[i].answer[0];
      }
    }
    return null;
  }

  bool _getMutipleAnswer(String qid, String code, int i){
    for(int x=0; x<_answer.answers.length; x++){
      if(_answer.answers[x].qid == qid){
        return _answer.answers[x].answer[i] == 'true';
      }
    }

    return false;
  }

  void _updateMutipleAnswer(String qid, int i, int total, bool val){
    bool exist = false;

    for(int x=0; x<_answer.answers.length; x++){
      if(_answer.answers[x].qid == qid){
        exist = true;
        _answer.answers[x].answer[i] = val.toString();
        break;
      }
    }

    if(!exist){
      final List<String> answer = [];
      for(int j=0; j<total; j++){
        answer.add((j == i) ? 'true' : 'false');
      }
      _answer.answers.add(UserAnswer(qid: qid, answer: answer));
    }

    if(_answer.id != null && _answer.id != '') {
      answerFirebaseService.update(id: _answer.id, data: _answer.toJson());
    }
  }

  void _submitAnswer(){
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
                    _controller.animateToPage(i+1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
                final VideoState videoState = Provider.of<VideoState>(context, listen: false);
                // update answer
                _answer.status = constCompleted;
                _answer.correct = _checkAnswers();
                _answer.min = _exam.min;// widget.video.min;
                _answer.pass = _answer.correct >= _answer.min;
                _answer.completed = DateTime.now();
                answerFirebaseService.update(id: _answer.id, data: _answer.toJson());

                // update series watch
                series_watchFirebaseService.update(
                  id: videoState.selectedSeriesWatch.id,
                  data: {
                    'test': true,
                    'completed': DateTime.now()
                  },
                );

                // call function to update result in series
                _updateResult();

                // close alert
                Navigator.pop(context);
              },
            )
          ]
      );
    }
  }

  int _checkAnswers(){
    int count = 0;
    for(int i = 0; i<_exam.questions.length; i++){
      final Question question = _exam.questions[i];
      final UserAnswer answer = _answer.answers.firstWhere((a) => a.qid == question.code);
      if(listEquals(answer.answer, question.answer)){
        count = count + 1;
      }
    }
    return count;
  }

  // call function to update the series result
  void _updateResult() {
    final HttpsCallable callable = CloudFunctions(region: 'asia-northeast1').getHttpsCallable(
      functionName: 'updateResult',
    );

    callable.call(<String, dynamic>{ 'sid': _answer.sid, 'min': _answer.min, 'correct': _answer.correct }
    ).then((res) {
      log.d('OK ${res.toString()}');
    }).catchError((error){
      log.w('updateResult error $error}');
    });
  }

  void _moveDown(){
    if(_controller.page > 0) {
      _controller.animateToPage(_controller.page.toInt() - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn);
    }
  }

  void _moveUp(){
    if(_currentPage < _exam.questions.length) {
      _controller.animateToPage(_controller.page.toInt() + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn);
    }
  }

  // temp generate questions
//  _getQues(BuildContext context) async{
//    List<q.Question> questions = await questionFirebaseService.find(
//        query: questionFirebaseService.colRef.where('vid', isEqualTo: '382117382').orderBy('order')
//    ).first;
//
//    questions.forEach((question) {
//      Map qm = question.toJson();
//      qm['code'] = qm['id'];
//      qm.remove('id');
//      qm.remove('vid');
//      qm.remove('status');
//      qm.remove('order');
//      qm.remove('correct');
//      qm.remove('wrong');
//      qm['type'] = AppConstant.single;
//      qm['answer'] = [qm['answer']];
//      List options = qm['options'];
//      List no = [];
//
//      for(int i=0; i<options.length; i++) {
//        Map m = qm['options'][i];
//        m.remove('type');
//        m.remove('selected');
//        no.add(m);
//      }
//
//      qm['options'] = no;
//
//      Question ques = Question.fromJson(qm);
//      _exam.questions.add(ques);
//    });
//
//    log.d('${_exam.toJson()}');
//
//    examFirebaseService.update(id: _exam.id, data: _exam.toJson());
//  }
}