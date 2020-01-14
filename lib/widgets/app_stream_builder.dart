import 'package:flutter/material.dart';
import '../utils/logger.dart';

class AppStreamBuilder extends StatelessWidget {
  final Stream stream;
  final Function fn;
  final Function fnNone;
  final bool showLoading;

  final log = getLogger('AppStreamBuilder');

  AppStreamBuilder({@required this.stream, @required this.fn, this.fnNone, this.showLoading = true});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          log.w('snapshot error ${snapshot.error}');
          return AppStreamError(error: 'Error: ${snapshot.error}',);
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            log.d('Connection None');
            return AppStreamNone();
            break;

          case ConnectionState.waiting:
            if(showLoading)
              return Center(child: CircularProgressIndicator(),);
            break;

          case ConnectionState.done:
            return Text('\$${snapshot.data} (closed)');
            break;

          case ConnectionState.active:
            if(!snapshot.hasData) {
              return (fnNone == null) ? AppStreamNone() : fnNone(context);
            }

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