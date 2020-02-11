import 'package:flutter/material.dart';
import 'package:learning/app_color.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/models/exam.dart';
import 'package:learning/states/video_state.dart';
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
          ],
        ),
      ),
    );
  }
}
