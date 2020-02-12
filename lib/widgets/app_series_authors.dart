import 'package:flutter/material.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/models/profile.service.dart';
import 'package:learning/states/app_state.dart';
import 'package:provider/provider.dart';

class AppSeriesAuthors extends StatelessWidget {
  final List<String> ids;

  const AppSeriesAuthors(this.ids);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.display3.copyWith(color: Colors.grey);
    return FutureBuilder(
      future: _getProfile(context),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.hasData) {
          return Text('${snapshot.data.join(', ')}', style: style,);
        }

        return Text('/', style: style,);
      },
    );
  }

  Future<List<String>> _getProfile(BuildContext context) async{
    final AppState appState = Provider.of(context);
    final List<String> names = [];

    for(final String id in ids) {
      final Profile profile = appState.profiles.firstWhere((profile) => profile.id == id, orElse: () => null);
      if(profile != null) {
        names.add(profile.name);
      } else {
        final Profile p = await profileFirebaseService.findById(id: id).first;
        if(p != null){
          appState.profiles.add(p);
          names.add(p.name);
        }
      }
    }

    return names;
  }
}
