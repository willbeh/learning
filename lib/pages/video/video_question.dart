//import 'package:flutter/material.dart';
//
//class VideoQuestion extends StatefulWidget {
//  final Function continueVideo;
//  final int orientation;
//
//  VideoQuestion({this.continueVideo, this.orientation});
//  @override
//  _VideoQuestionState createState() => _VideoQuestionState();
//}
//
//class _VideoQuestionState extends State<VideoQuestion> {
//  String _selectedAnswer = '';
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimatedOpacity(
//      opacity: 0.9,
//      duration: Duration(seconds: 2),
//      child: Container(
//        decoration: BoxDecoration(
//          color: Colors.black,
//          borderRadius: BorderRadius.circular(20),
//        ),
//        child: Column(
//          children: <Widget>[
//            _buildQuestion('What is the best solution?'),
//            Expanded(
//              child: Column(
//                children: <Widget>[
//                  _buildAnswer('Green Apple'),
//                  _buildAnswer('Red Strawberry'),
//                ],
//              ),
//            ),
//            _buildSubmit()
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _buildQuestion(String question){
//    return Container(
//      padding: EdgeInsets.symmetric(vertical: widget.orientation == 0 ? 40 : 13, horizontal: 20),
//      decoration: BoxDecoration(
//        color: Colors.blue,
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(20),
//          topRight: Radius.circular(20),
//        )
//      ),
//      child: Center(
//          child: Text('$question', style: Theme.of(context).textTheme.title,),
//      )
//    );
//  }
//
//  Widget _buildAnswer(String answer){
//    return Row(
//      children: <Widget>[
//        Radio(
//          value: answer,
//          groupValue: _selectedAnswer,
//          onChanged: (val) {
//            setState(() {
//              _selectedAnswer = val;
//            });
//          },
//        ),
//        Text('$answer', style: Theme.of(context).textTheme.subhead,),
//      ],
//    );
//  }
//
//  Widget _buildSubmit(){
//    return Container(
//        padding: EdgeInsets.symmetric(vertical: widget.orientation == 0 ? 20 : 13, horizontal: 20),
//        decoration: BoxDecoration(
//            color: Colors.blue,
//            borderRadius: BorderRadius.only(
//              bottomRight: Radius.circular(20),
//              bottomLeft: Radius.circular(20),
//            )
//        ),
//        child: InkWell(
//          onTap: widget.continueVideo,
//          child: Center(
//            child: Text('SUBMIT', style: Theme.of(context).textTheme.title,),
//          ),
//        )
//    );
//  }
//}
