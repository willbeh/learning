import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/exam.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_const.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_dotted_seperator.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class ExamAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Exam exam = Provider.of<Exam>(context);
    VideoState videoState = Provider.of<VideoState>(context);
    Answer answer = Provider.of<Answer>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
            CommonUI.heightPadding(height: 5),
            Text('${videoState.selectedSeries.name}', style: Theme.of(context).textTheme.headline,),
            CommonUI.heightPadding(),
            AppDottedSeparator(color: AppColor.greyDottedLine,),
            CommonUI.heightPadding(),
            Text('${AppTranslate.text(context, 'test_result_title')}', style: Theme.of(context).textTheme.headline,),
            Text('${AppTranslate.text(context, 'test_result_desc')}', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
            CommonUI.heightPadding(),
            _buildScoreCard(context, exam, answer),
            ExamAnswerSegment(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, Exam exam, Answer answer) {
    double width = MediaQuery.of(context).size.width - 40;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Card(
          elevation: 2,
          child: Container(
            width: width/2 - 10,
            child: Column(
              children: <Widget>[
                Container(
                  height: 35,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.display2,
                        children: <TextSpan>[
                          TextSpan(text: '${((answer.correct/answer.answers.length)*100).toInt()}', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '/100', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Center(child: Text('${AppTranslate.text(context, 'test_result_score')}',
                    style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),)),
                ),
              ],
            )
          ),
        ),
        Card(
          elevation: 2,
          child: Container(
            width: width/2 - 10,
            child: Column(
              children: <Widget>[
                Container(
                  height: 35,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.display2,
                        children: <TextSpan>[
                          TextSpan(text: '${answer.correct}', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '/${answer.answers.length}', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Center(child: Text('${AppTranslate.text(context, 'test_result_correct')}',
                    style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ExamAnswerSegment extends StatefulWidget {
  @override
  _ExamAnswerSegmentState createState() => _ExamAnswerSegmentState();
}

class _ExamAnswerSegmentState extends State<ExamAnswerSegment> {
  String _selected = '1';
  Map<String, String> _segments;
  Exam _exam;
  Answer _answer;
  var log = getLogger('_ExamAnswerSegmentState');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_segments == null)
      _segments = {
        '1': '${AppTranslate.text(context, 'test_result_all')}',
        '2': '${AppTranslate.text(context, 'test_result_incorrect')}'
      };
    if(_exam == null)
      _exam = Provider.of<Exam>(context);

    if(_answer == null)
      _answer = Provider.of<Answer>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          CommonUI.heightPadding(),
          _buildSegmentControl(context),
          CommonUI.heightPadding(),
          _buildQuestionList(context),
        ],
      ),
    );
  }

  Widget _buildSegmentControl(BuildContext context) {
    return Container(
      width: 200,
      child: CupertinoSegmentedControl(
        borderColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,

        onValueChanged: (v) {
          setState(() {
            _selected = v as String;
          });
        },
        groupValue: _selected,
        children: _segments.map((k, v) {
          return MapEntry<dynamic, Widget>(k, Text(v,
            style: Theme.of(context).textTheme.display3.copyWith(color: (_selected == k) ? Colors.white : Theme.of(context).primaryColor),));
        }),
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _exam.questions.length,
      separatorBuilder: (context, i) {
        if(_selected == '2') {
          UserAnswer userAnswer = _answer.answers.firstWhere((ans) => ans.qid == _exam.questions[i].code);
          if (listEquals(userAnswer.answer, _exam.questions[i].answer)){
            return Container();
          }
        }
        return CommonUI.heightPadding(height: 30);
      },
      itemBuilder: (context, i) {
        if(_selected == '2') {
          UserAnswer userAnswer = _answer.answers.firstWhere((ans) => ans.qid == _exam.questions[i].code);
          if (listEquals(userAnswer.answer, _exam.questions[i].answer)){
            return Container();
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${i+1}. ${_exam.questions[i].question}', style: Theme.of(context).textTheme.display2.copyWith(fontWeight: FontWeight.w500),),
            CommonUI.heightPadding(height: 10),
            _buildAnswer(context, i),
          ],
        );
      },
    );
  }

  Widget _buildAnswer(BuildContext context, int i){
    return Card(
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _exam.questions[i].options.length,
        separatorBuilder: (context, j) => Divider(height: 1,),
        itemBuilder: (context, j) {
          UserAnswer userAnswer = _answer.answers.firstWhere((ans) => ans.qid == _exam.questions[i].code);
          if(_exam.questions[i].type == AppConstant.single) {
            return _buildAnswerRow(context,
              correct: _exam.questions[i].answer.contains(_exam.questions[i].options[j].code),
              option: _exam.questions[i].options[j].option,
              selected: userAnswer.answer.contains(_exam.questions[i].options[j].code)
            );
          } else if(_exam.questions[i].type == AppConstant.multiple) {
            return _buildAnswerRow(context,
                correct: _exam.questions[i].answer[j] == 'true',
                option: _exam.questions[i].options[j].option,
                selected: userAnswer.answer[j] == 'true',
            );
          }
          return Text('${_exam.questions[i].options[j].option}');
        },
      ),
    );
  }

  Widget _buildAnswerRow(BuildContext context, {bool correct, String option, bool selected}){
    Widget leading = Container(width: 1,);
    if(correct) {
      leading = Icon(Icons.check, color: Colors.green,);
    } else if(!correct && selected) {
      leading = Icon(Icons.clear, color: Colors.red,);
    }

    Color bgColor = Colors.white;
    if(correct && selected) {
      bgColor = Colors.green.withOpacity(0.3);
    } else if(!correct && selected) {
      bgColor = Colors.red.withOpacity(0.3);
    }
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text('$option', style: Theme.of(context).textTheme.display3,)),
          leading
        ],
      ),

    );
  }
}

