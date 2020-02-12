import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/logger.dart';

class AppFutureBuilder extends StatelessWidget {
  final Future future;
  final Function fn;
  final Function fnLoading;
  final Function fnNone;
  final Function fnError;
  final bool showLoading;

  final Logger log = getLogger('AppFutureBuilder');

  AppFutureBuilder({@required this.future, @required this.fn, this.fnLoading, this.fnNone, this.fnError, this.showLoading = true});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          log.w('snapshot error ${snapshot.error}');
          return (fnError == null) ? AppStreamError(error: 'Error: ${snapshot.error}',) : fnError(context, snapshot.error) as Widget;
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
//            log.d('Connection None');
            return AppStreamNone();
            break;

          case ConnectionState.waiting:
//            log.d('Connection waiting');
            if(fnLoading != null) {
              return fnLoading(context) as Widget;
            }
            if(showLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }
            break;

          case ConnectionState.done:
            if(!snapshot.hasData) {
              return (fnNone == null) ? AppStreamNone() : fnNone(context) as Widget;
            }

            return fn(context, snapshot.data) as Widget;
            break;

          case ConnectionState.active:
            if(!snapshot.hasData) {
              return (fnNone == null) ? AppStreamNone() : fnNone(context) as Widget;
            }

            return fn(context, snapshot.data) as Widget;
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
    // ignore: avoid_unnecessary_containers
    return Container(
      child: const Center(
        child: Text('No item'),
      ),
    );
  }
}

class AppStreamWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,),
      ),
    );
  }
}

class AppStreamError extends StatelessWidget {
  final String error;

  const AppStreamError({this.error = ''});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: Text(error),
      ),
    );
  }
}