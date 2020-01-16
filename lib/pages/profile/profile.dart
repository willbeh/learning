import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/widgets/app_avatar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
//            SliverAppBar(
//              title: Text('Profile'),
//              pinned: true,
//              backgroundColor: Colors.purple[700],
//              brightness: Brightness.dark,
//            ),
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 200),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(height: 250, child: Text('ii'),),
                  Container(height: 250, child: Text('ii'),),
                  Container(height: 250, child: Text('ii'),),
                  Container(height: 250, child: Text('ii'),),
                ],
              ),
            )
          ]
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    FirebaseUser user = Provider.of(context);

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        CurvedShape(height: 60, radius: 55,),
        Container(
          color: Colors.white.withOpacity(shrinkOffset / expandedHeight),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                height: 130 * (1 - shrinkOffset / expandedHeight),
//                padding: EdgeInsets.only(top: 50 * (1 - shrinkOffset / expandedHeight)),
                child: Opacity(
                  opacity: (1 - shrinkOffset / expandedHeight),
                  child: Center(child: AppAvatar(image: user?.photoUrl, radius: 40 * (1 - shrinkOffset / expandedHeight), text: '${user?.email[0].toUpperCase()}',)),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 56,
          padding: EdgeInsets.only(top: 80) * (1 - shrinkOffset / expandedHeight),
          child: Center(
            child: Text('${user.displayName}',
              style: Theme.of(context).textTheme.title, //.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
              maxLines: (shrinkOffset / expandedHeight == 1) ? 1 : 2,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: (shrinkOffset / expandedHeight > 0.6) ? Colors.black: Colors.white,),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CurvedShape extends StatelessWidget {
  final double height;
  final double radius;

  CurvedShape({this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _MyPainter(height, radius),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final double height;
  final double radius;

  _MyPainter(this.height, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.purple[700];

    Offset circleCenter = Offset(size.width / 2, size.height - radius);

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.25);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Offset leftCurveControlPoint = Offset(circleCenter.dx * 0.5, size.height - radius * 1.5);
    Offset rightCurveControlPoint = Offset(circleCenter.dx * 1.6, size.height - radius);

    final arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX = circleCenter.dx + radius * cos(arcStartAngle);
    final avatarLeftPointY = circleCenter.dy + radius * sin(arcStartAngle);
    Offset avatarLeftPoint = Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    final arcEndAngle = -5 / 180 * pi;
    final avatarRightPointX = circleCenter.dx + radius * cos(arcEndAngle);
    final avatarRightPointY = circleCenter.dy + radius * sin(arcEndAngle);
    Offset avatarRightPoint = Offset(avatarRightPointX, avatarRightPointY - 50); // the right point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx, topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy - 50, avatarLeftPoint.dx, avatarLeftPoint.dy - 50)
      ..arcToPoint(avatarRightPoint, radius: Radius.circular(radius))
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy - 50, bottomRight.dx, bottomRight.dy - 50)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}