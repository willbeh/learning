import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:learning/models/video.service.dart';

class TempVideos extends StatelessWidget {
  final log = getLogger('TempVideos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temp Video'),
      ),
      body: AppStreamBuilder(
        stream: videoFirebaseService.find(),
        fn: _buildPage,
      ),
    );
  }

  Widget _buildPage(BuildContext context, List<Video> videos) {
    return ListView.separated(
      itemCount: videos.length,
      separatorBuilder: (context, i) => const Divider(),
      itemBuilder: (context, i) {
        final Video video = videos[i];
        return ListTile(
          onTap: () => {
            videoFirebaseService.update(id: video.id, data: {
              'data': {
                "uri": "/videos/393863017",
                "name": "Open Space Learning",
                "description": "Open Space Learning",
                "type": "video",
                "link": "https://vimeo.com/393863017/82231eb77f",
                "duration": 17,
                "width": 3840,
                "language": null,
                "height": 2160,
                "embed": {
                  "buttons": {
                    "like": true,
                    "watchlater": true,
                    "share": true,
                    "embed": true,
                    "hd": false,
                    "fullscreen": true,
                    "scaling": true
                  },
                  "logos": {
                    "vimeo": true,
                    "custom": {
                      "active": false,
                      "link": null,
                      "sticky": false
                    }
                  },
                  "title": {
                    "name": "user",
                    "owner": "user",
                    "portrait": "user"
                  },
                  "playbar": true,
                  "volume": true,
                  "speed": false,
                  "color": "00adef",
                  "uri": null,
                  "html": "<iframe src=\"https://player.vimeo.com/video/393863017?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=166420\" width=\"3840\" height=\"2160\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Open Space Learning\"></iframe>",
                  "badges": {
                    "hdr": false,
                    "live": {
                      "streaming": false,
                      "archived": false
                    },
                    "staff_pick": {
                      "normal": false,
                      "best_of_the_month": false,
                      "best_of_the_year": false,
                      "premiere": false
                    },
                    "vod": false,
                    "weekend_challenge": false
                  }
                },
                "created_time": "2020-02-26T07:17:20+00:00",
                "modified_time": "2020-02-26T07:31:16+00:00",
                "release_time": "2020-02-26T07:17:20+00:00",
                "content_rating": [
                  "safe"
                ],
                "license": null,
                "privacy": {
                  "view": "unlisted",
                  "embed": "public",
                  "download": true,
                  "add": true,
                  "comments": "anybody"
                },
                "pictures": {
                  "uri": "/videos/393863017:82231eb77f/pictures/859526037",
                  "active": true,
                  "type": "custom",
                  "sizes": [
                    {
                      "width": 100,
                      "height": 75,
                      "link": "https://i.vimeocdn.com/video/859526037_100x75.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_100x75.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 200,
                      "height": 150,
                      "link": "https://i.vimeocdn.com/video/859526037_200x150.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_200x150.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 295,
                      "height": 166,
                      "link": "https://i.vimeocdn.com/video/859526037_295x166.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_295x166.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 640,
                      "height": 360,
                      "link": "https://i.vimeocdn.com/video/859526037_640x360.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_640x360.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/859526037_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1920,
                      "height": 1080,
                      "link": "https://i.vimeocdn.com/video/859526037_1920x1080.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_1920x1080.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 640,
                      "height": 360,
                      "link": "https://i.vimeocdn.com/video/859526037_640x360.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_640x360.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 960,
                      "height": 540,
                      "link": "https://i.vimeocdn.com/video/859526037_960x540.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_960x540.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/859526037_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1920,
                      "height": 1080,
                      "link": "https://i.vimeocdn.com/video/859526037_1920x1080.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_1920x1080.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/859526037_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F859526037_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    }
                  ],
                  "resource_key": "b3f0ae7bccec5b44c04eaacf69a66d8bcf53fcd6"
                },
                "tags": [
                  {
                    "uri": "/tags/group",
                    "name": "group",
                    "tag": "group",
                    "canonical": "group",
                    "metadata": {
                      "connections": {
                        "videos": {
                          "uri": "/tags/group/videos",
                          "options": [
                            "GET"
                          ],
                          "total": 30800
                        }
                      }
                    },
                    "resource_key": "cd502085e8ae92c8f52cb5e9f21bf6b539545e99"
                  }
                ],
                "stats": {
                  "plays": 0
                },
                "categories": [],
                "metadata": {
                  "connections": {
                    "comments": {
                      "uri": "/videos/393863017:82231eb77f/comments",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 0
                    },
                    "credits": null,
                    "likes": {
                      "uri": "/videos/393863017:82231eb77f/likes",
                      "options": [
                        "GET"
                      ],
                      "total": 0
                    },
                    "pictures": {
                      "uri": "/videos/393863017:82231eb77f/pictures",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 2
                    },
                    "texttracks": {
                      "uri": "/videos/393863017:82231eb77f/texttracks",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 0
                    },
                    "related": null,
                    "recommendations": null,
                    "albums": {
                      "uri": "/videos/393863017:82231eb77f/albums",
                      "options": [
                        "GET",
                        "PATCH"
                      ],
                      "total": 0
                    },
                    "available_albums": {
                      "uri": "/videos/393863017:82231eb77f/available_albums",
                      "options": [
                        "GET"
                      ],
                      "total": 0
                    },
                    "versions": {
                      "uri": "/videos/393863017:82231eb77f/versions",
                      "options": [
                        "GET"
                      ],
                      "total": 1,
                      "current_uri": "/videos/393863017/versions/295869209",
                      "resource_key": "c1f4f2a35aa0984e3df9a1af7223fd3156ed3a11"
                    }
                  },
                  "interactions": {
                    "watchlater": {
                      "uri": "/users/109008672/watchlater/393863017:82231eb77f",
                      "options": [
                        "GET",
                        "PUT",
                        "DELETE"
                      ],
                      "added": false,
                      "added_time": null
                    },
                    "report": {
                      "uri": "/videos/393863017/report",
                      "options": [
                        "POST"
                      ],
                      "reason": [
                        "pornographic",
                        "harassment",
                        "advertisement",
                        "ripoff",
                        "incorrect rating",
                        "spam",
                        "causes harm"
                      ]
                    }
                  }
                },
                "user": {
                  "uri": "/users/109008672",
                  "name": "William Beh",
                  "link": "https://vimeo.com/user109008672",
                  "location": "",
                  "bio": null,
                  "short_bio": null,
                  "created_time": "2020-02-26T07:11:58+00:00",
                  "pictures": {
                    "uri": null,
                    "active": false,
                    "type": "default",
                    "sizes": [
                      {
                        "width": 30,
                        "height": 30,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_30x30.png"
                      },
                      {
                        "width": 75,
                        "height": 75,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_75x75.png"
                      },
                      {
                        "width": 100,
                        "height": 100,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_100x100.png"
                      },
                      {
                        "width": 300,
                        "height": 300,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_300x300.png"
                      },
                      {
                        "width": 72,
                        "height": 72,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_72x72.png"
                      },
                      {
                        "width": 144,
                        "height": 144,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_144x144.png"
                      },
                      {
                        "width": 216,
                        "height": 216,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_216x216.png"
                      },
                      {
                        "width": 288,
                        "height": 288,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_288x288.png"
                      },
                      {
                        "width": 360,
                        "height": 360,
                        "link": "https://i.vimeocdn.com/portrait/defaults-blue_360x360.png"
                      }
                    ],
                    "resource_key": "06cd312fcc3908e2d839aeb00ccaaf434acb0859"
                  },
                  "websites": [],
                  "metadata": {
                    "connections": {
                      "albums": {
                        "uri": "/users/109008672/albums",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "appearances": {
                        "uri": "/users/109008672/appearances",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "categories": {
                        "uri": "/users/109008672/categories",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "channels": {
                        "uri": "/users/109008672/channels",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "feed": {
                        "uri": "/users/109008672/feed",
                        "options": [
                          "GET"
                        ]
                      },
                      "followers": {
                        "uri": "/users/109008672/followers",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "following": {
                        "uri": "/users/109008672/following",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "groups": {
                        "uri": "/users/109008672/groups",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "likes": {
                        "uri": "/users/109008672/likes",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "membership": {
                        "uri": "/users/109008672/membership/",
                        "options": [
                          "PATCH"
                        ]
                      },
                      "moderated_channels": {
                        "uri": "/users/109008672/channels?filter=moderated",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "portfolios": {
                        "uri": "/users/109008672/portfolios",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "videos": {
                        "uri": "/users/109008672/videos",
                        "options": [
                          "GET"
                        ],
                        "total": 1
                      },
                      "watchlater": {
                        "uri": "/users/109008672/watchlater",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "shared": {
                        "uri": "/users/109008672/shared/videos",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "pictures": {
                        "uri": "/users/109008672/pictures",
                        "options": [
                          "GET",
                          "POST"
                        ],
                        "total": 0
                      },
                      "watched_videos": {
                        "uri": "/me/watched/videos",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      },
                      "folders": {
                        "uri": "/me/folders",
                        "options": [
                          "GET",
                          "POST"
                        ],
                        "total": 0
                      },
                      "block": {
                        "uri": "/me/block",
                        "options": [
                          "GET"
                        ],
                        "total": 0
                      }
                    }
                  },
                  "preferences": {
                    "videos": {
                      "privacy": {
                        "view": "anybody",
                        "comments": "anybody",
                        "embed": "public",
                        "download": true,
                        "add": true
                      }
                    }
                  },
                  "content_filter": [
                    "language",
                    "drugs",
                    "violence",
                    "nudity",
                    "safe",
                    "unrated"
                  ],
                  "resource_key": "c1469fab3e71789df3314569fa6df4711a69e71b",
                  "account": "pro"
                },
                "review_page": {
                  "active": false,
                  "link": "https://vimeo.com/user109008672/review/393863017/1770eb057c"
                },
                "parent_folder": null,
                "last_user_action_event_date": "2020-02-26T07:31:16+00:00",
                "files": [
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 3840,
                    "height": 2160,
                    "link": "https://player.vimeo.com/external/393863017.hd.mp4?s=d3574bcea478a95ef763cbca8a2acc57c2ffb465&profile_id=172&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 37675166,
                    "md5": "c2a696c996b21247ba76557484eb5b6d"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link": "https://player.vimeo.com/external/393863017.hd.mp4?s=d3574bcea478a95ef763cbca8a2acc57c2ffb465&profile_id=174&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 6127613,
                    "md5": "3fdba06c4c5f07f8f3c8f6ebf9d7f3fa"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 2560,
                    "height": 1440,
                    "link": "https://player.vimeo.com/external/393863017.hd.mp4?s=d3574bcea478a95ef763cbca8a2acc57c2ffb465&profile_id=170&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 19607500,
                    "md5": "6b4193e93f9df60b4acd45aa48ac53e3"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link": "https://player.vimeo.com/external/393863017.hd.mp4?s=d3574bcea478a95ef763cbca8a2acc57c2ffb465&profile_id=175&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 12018301,
                    "md5": "19336d37150a645627c97638aa62f428"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link": "https://player.vimeo.com/external/393863017.sd.mp4?s=4cbbae71e52cc22699c405f1af0b2fb2bd02efff&profile_id=165&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:19:44+00:00",
                    "fps": 25,
                    "size": 3335079,
                    "md5": "4e8dec9dd0d486333195246fc2fc4640"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link": "https://player.vimeo.com/external/393863017.sd.mp4?s=4cbbae71e52cc22699c405f1af0b2fb2bd02efff&profile_id=164&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:18:05+00:00",
                    "fps": 25,
                    "size": 1132894,
                    "md5": "061859de7d8e444d883773ee08fe3fd4"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 426,
                    "height": 240,
                    "link": "https://player.vimeo.com/external/393863017.sd.mp4?s=4cbbae71e52cc22699c405f1af0b2fb2bd02efff&profile_id=139&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:18:05+00:00",
                    "fps": 25,
                    "size": 699008,
                    "md5": "a856d3c33b48c9df4be30ea045a3bd67"
                  },
                  {
                    "quality": "hls",
                    "type": "video/mp4",
                    "link": "https://player.vimeo.com/external/393863017.m3u8?s=4743677dee6494cb88b56cbec9561fe595c71554&oauth2_token_id=1300266401",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 37675166,
                    "md5": "c2a696c996b21247ba76557484eb5b6d"
                  }
                ],
                "download": [
                  {
                    "quality": "source",
                    "type": "source",
                    "width": 3840,
                    "height": 2160,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671263896?s=393863017_1582745777_82f7be7a96ade9be85b9dd1362bdf772&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearningsource.mp4",
                    "created_time": "2020-02-26T07:17:44+00:00",
                    "fps": 25,
                    "size": 41043735,
                    "md5": "8ae3d4b9b5749ffc98bcb79111f80081"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 3840,
                    "height": 2160,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671265410?s=393863017_1582745777_f957701a723e80fa5a577d5d57449538&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning172.mp4",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 37675166,
                    "md5": "c2a696c996b21247ba76557484eb5b6d"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671265406?s=393863017_1582745777_2980276a10163f53f42be2902147d2d1&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning174.mp4",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 6127613,
                    "md5": "3fdba06c4c5f07f8f3c8f6ebf9d7f3fa"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 2560,
                    "height": 1440,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671265404?s=393863017_1582745777_a8ec33339e8ae35f1bdea93f19fecff5&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning170.mp4",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 19607500,
                    "md5": "6b4193e93f9df60b4acd45aa48ac53e3"
                  },
                  {
                    "quality": "hd",
                    "type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671265402?s=393863017_1582745777_c0853ce14efdfe8aac81566c25763653&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning175.mp4",
                    "created_time": "2020-02-26T07:20:04+00:00",
                    "fps": 25,
                    "size": 12018301,
                    "md5": "19336d37150a645627c97638aa62f428"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671265235?s=393863017_1582745777_0877c91aa3fbc1f09a86e277a520a1d7&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning165.mp4",
                    "created_time": "2020-02-26T07:19:44+00:00",
                    "fps": 25,
                    "size": 3335079,
                    "md5": "4e8dec9dd0d486333195246fc2fc4640"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671264199?s=393863017_1582745777_ef0c5b8248222328b5d48004051f8344&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning164.mp4",
                    "created_time": "2020-02-26T07:18:05+00:00",
                    "fps": 25,
                    "size": 1132894,
                    "md5": "061859de7d8e444d883773ee08fe3fd4"
                  },
                  {
                    "quality": "sd",
                    "type": "video/mp4",
                    "width": 426,
                    "height": 240,
                    "expires": "2020-02-26T10:36:17+00:00",
                    "link": "https://player.vimeo.com/play/1671264194?s=393863017_1582745777_e16cb1ded1c7e269384dbf2121890e0a&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Open%2BSpace%2BLearning139.mp4",
                    "created_time": "2020-02-26T07:18:05+00:00",
                    "fps": 25,
                    "size": 699008,
                    "md5": "a856d3c33b48c9df4be30ea045a3bd67"
                  }
                ],
                "app": {
                  "name": "Parallel Uploader",
                  "uri": "/apps/87099"
                },
                "status": "available",
                "resource_key": "f66a1de401a40b8569945317678f2f5ccddfdeb7",
                "upload": {
                  "status": "complete",
                  "link": null,
                  "upload_link": null,
                  "complete_uri": null,
                  "form": null,
                  "approach": null,
                  "size": null,
                  "redirect_url": null
                },
                "transcode": {
                  "status": "complete"
                }
              }
            }).then((val) {
              log.d('updated');
            }).catchError((error) {
              log.e('error updating $error');
            })
          },
          title: Text(video.vid),
        );
      },
    );
  }
}

class TempVideoDetail extends StatelessWidget {
  final Video video;

  const TempVideoDetail(this.video);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

