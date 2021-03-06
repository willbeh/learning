import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/banner.dart';
import 'package:learning/models/banner.service.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_loading_container.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:learning/states/app_state.dart';

class AppCarousel extends StatelessWidget {
  final Logger log = getLogger('AppCarousel');

  @override
  Widget build(BuildContext context) {
    final List<AppBanner> banners = Provider.of<AppState>(context).banners;
    if(banners == null || banners.isEmpty) {
      return AppStreamBuilder(
        stream: bannerFirebaseService.find(
            query: bannerFirebaseService.colRef.where(
                'status', isEqualTo: 'published'),
            orderField: 'order'
        ),
        fn: _buildCarousel,
        fnLoading: _buildLoading,
      );
    } else {
      return AppCarouselBanner(banners);
    }
  }

  Widget _buildCarousel(BuildContext context, List<AppBanner> banners) {
    if(Provider.of<AppState>(context, listen: false).banners != banners){
      Provider.of<AppState>(context, listen: false).banners = banners;
    }
    return AppCarouselBanner(banners);
  }

  Widget _buildLoading(BuildContext context) {
    return AppLoadingContainer(
      height: 200,
      width: MediaQuery.of(context).size.width,
    );
  }
}

class AppCarouselBanner extends StatefulWidget {
  final List<AppBanner> banners;

  const AppCarouselBanner(this.banners);

  @override
  _AppCarouselBannerState createState() => _AppCarouselBannerState();
}

class _AppCarouselBannerState extends State<AppCarouselBanner> {
  int _current = 0;

  double aspectRatio = 6/9;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CarouselSlider(
            items: widget.banners.map((banner) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            banner.image,
                          )
                      )
                  ),
              );
            }).toList(),
            pauseAutoPlayOnTouch: const Duration(seconds: 3),
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
                  for(int i=0; i<widget.banners.length; i++)
                    Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == i ? Theme.of(context).primaryColor : Colors.white
                      ),
                    )
                ],
              )
          )
        ]
    );
  }
}
