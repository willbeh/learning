import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AppCarousel extends StatefulWidget {
  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  int _current = 0;

  List items = [1,2,3,4,5];
  List colors = [Colors.greenAccent, Colors.yellow, Colors.blue, Colors.redAccent, Colors.purpleAccent];

  double aspectRatio = 6/9;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CarouselSlider(
            items: items.map((i) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: colors[i-1]
                  ),
                  child: Center(child: Text('text $i', style: TextStyle(fontSize: 16.0),))
              );
            }).toList(),
            autoPlay: true,
            viewportFraction: 1.0,
            height: 200,

            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },

          ),
          Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for(int i=0; i<items.length; i++)
                    Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == i ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
                      ),
                    )
                ],
              )
          )
        ]
    );
  }
}
