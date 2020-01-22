import 'package:flutter/material.dart';
import '../utils/logger.dart';

class AppFutureBuilder extends StatelessWidget {
  final Future future;
  final Function fn;
  final Function fnLoading;
  final Function fnNone;
  final Function fnError;
  final bool showLoading;

  final log = getLogger('AppFutureBuilder');

  AppFutureBuilder({@required this.future, @required this.fn, this.fnLoading, this.fnNone, this.fnError, this.showLoading = true});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          log.w('snapshot error ${snapshot.error}');
          return (fnError == null) ? AppStreamError(error: 'Error: ${snapshot.error}',) : fnError(context, snapshot.error);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
//            log.d('Connection None');
            return AppStreamNone();
            break;

          case ConnectionState.waiting:
//            log.d('Connection waiting');
            if(fnLoading != null)
              return fnLoading(context);
            if(showLoading)
              return Center(child: CircularProgressIndicator(),);
            break;

          case ConnectionState.done:
            if(!snapshot.hasData) {
              return (fnNone == null) ? AppStreamNone() : fnNone(context);
            }

            return fn(context, snapshot.data);
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