import 'package:flutter/material.dart';
import '../utils/logger.dart';

class AppStreamBuilder extends StatelessWidget {
  final Stream stream;
  final Function fn;
  final Function fnNone;
  bool showLoading;

  final log = getLogger('AppStreamBuilder');

  AppStreamBuilder({@required this.stream, @required this.fn, this.fnNone, this.showLoading = true});

  @override
  Widget build(BuildContext context) {
//    final Trace myTrace = FirebasePerformance.instance.newTrace(stream.toString());
//    myTrace.start();

    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
//          myTrace.putAttribute('error', snapshot.error.toString());
//          myTrace.incrementMetric('ConnectionState_error', 1);
//          myTrace.stop();
          log.w('snapshot error ${snapshot.error}');
          return AppStreamError(error: 'Error: ${snapshot.error}',);
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
//            myTrace.incrementMetric('ConnectionState_none', 1);
//            myTrace.stop();
            return AppStreamNone();
            break;

          case ConnectionState.waiting:
//            myTrace.incrementMetric('ConnectionState_waiting', 1);
//            return AppStreamWait();
            if(showLoading)
              return Center(child: CircularProgressIndicator(),);
            break;

          case ConnectionState.done:
//            myTrace.incrementMetric('ConnectionState_done', 1);
//            myTrace.stop();
            return Text('\$${snapshot.data} (closed)');
            break;

          case ConnectionState.active:
//            myTrace.incrementMetric('ConnectionState_active', 1);
            if(!snapshot.hasData) {
              return (fnNone == null) ? AppStreamNone() : fnNone(context);
            }

//            if(snapshot.data is List)
//              myTrace.putAttribute('snapshot_length', snapshot.data?.length.toString());
//            myTrace.stop();
//            if (snapshot.data.length == 0) {
//              return AppStreamNone();
//            }
            return fn(context, snapshot.data);
            break;
        }
        return Container();
      },
    );
  }
}

class AppStreamNone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('No item'),
      ),
    );
  }
}

class AppStreamWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,),
      ),
    );
  }
}

class AppStreamError extends StatelessWidget {
  final String error;

  AppStreamError({this.error = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(error),
      ),
    );
  }
}