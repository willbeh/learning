import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/watch.dart';
import 'package:provider/provider.dart';

class MyVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Video'),
      ),
      body: _buildMyVideosList(context),
    );
  }

  Widget _buildMyVideosList(BuildContext context){
    final List<Watch> watchs = Provider.of(context);
    if(watchs == null) {
      return Container(
        child: const Text('None'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: watchs.length,
      separatorBuilder: (context, i) => const Divider(),
      itemBuilder: (context, i) {
        final Watch watch = watchs[i];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: watch.vpicture,
          ),
          title: Text('${watch.vname} - ${watch.date}'),
          subtitle: Text((watch.status == 'completed') ? 'Completed' : '${(watch.furthest/watch.vduration * 100.0).toStringAsPrecision(2)}%'),
          trailing: (watch.status == 'completed') ? CircleAvatar( radius: 15, backgroundColor: Colors.green,child: Icon(Icons.done_outline, size: 18,),) : Container(width: 10,),
        );
      },

    );
  }
}
