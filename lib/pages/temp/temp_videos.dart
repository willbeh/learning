import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:learning/models/video.service.dart';

class TempVideos extends StatelessWidget {

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
                "uri": "/videos/396364131",
                "name": "Sales Team",
                "description": null,
                "type": "video",
                "link": "https://vimeo.com/396364131/dd374c2b36",
                "duration": 0,
                "width": 400,
                "language": null,
                "height": 300,
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
                  "html": "<iframe src=\"https://player.vimeo.com/video/396364131?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=166420\" width=\"400\" height=\"300\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Sales Team\"></iframe>",
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
                "created_time": "2020-03-09T03:03:12+00:00",
                "modified_time": "2020-03-09T03:03:41+00:00",
                "release_time": "2020-03-09T03:03:12+00:00",
                "content_rating": [
                  "unrated"
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
                  "uri": "/videos/396364131:dd374c2b36/pictures/863088456",
                  "active": true,
                  "type": "custom",
                  "sizes": [
                    {
                      "width": 100,
                      "height": 75,
                      "link": "https://i.vimeocdn.com/video/863088456_100x75.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_100x75.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 200,
                      "height": 150,
                      "link": "https://i.vimeocdn.com/video/863088456_200x150.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_200x150.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 295,
                      "height": 166,
                      "link": "https://i.vimeocdn.com/video/863088456_295x166.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_295x166.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 640,
                      "height": 360,
                      "link": "https://i.vimeocdn.com/video/863088456_640x360.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_640x360.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/863088456_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1920,
                      "height": 1080,
                      "link": "https://i.vimeocdn.com/video/863088456_1920x1080.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_1920x1080.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 640,
                      "height": 360,
                      "link": "https://i.vimeocdn.com/video/863088456_640x360.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_640x360.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 960,
                      "height": 540,
                      "link": "https://i.vimeocdn.com/video/863088456_960x540.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_960x540.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/863088456_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1920,
                      "height": 1080,
                      "link": "https://i.vimeocdn.com/video/863088456_1920x1080.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_1920x1080.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    },
                    {
                      "width": 1280,
                      "height": 720,
                      "link": "https://i.vimeocdn.com/video/863088456_1280x720.jpg?r=pad",
                      "link_with_play_button": "https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F863088456_1280x720.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png"
                    }
                  ],
                  "resource_key": "825d90efef392ed6e773a774814bc456c95d48a3"
                },
                "tags": [],
                "stats": {
                  "plays": 0
                },
                "categories": [],
                "metadata": {
                  "connections": {
                    "comments": {
                      "uri": "/videos/396364131:dd374c2b36/comments",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 0
                    },
                    "credits": null,
                    "likes": {
                      "uri": "/videos/396364131:dd374c2b36/likes",
                      "options": [
                        "GET"
                      ],
                      "total": 0
                    },
                    "pictures": {
                      "uri": "/videos/396364131:dd374c2b36/pictures",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 1
                    },
                    "texttracks": {
                      "uri": "/videos/396364131:dd374c2b36/texttracks",
                      "options": [
                        "GET",
                        "POST"
                      ],
                      "total": 0
                    },
                    "related": null,
                    "recommendations": null,
                    "albums": {
                      "uri": "/videos/396364131:dd374c2b36/albums",
                      "options": [
                        "GET",
                        "PATCH"
                      ],
                      "total": 0
                    },
                    "available_albums": {
                      "uri": "/videos/396364131:dd374c2b36/available_albums",
                      "options": [
                        "GET"
                      ],
                      "total": 0
                    },
                    "versions": {
                      "uri": "/videos/396364131:dd374c2b36/versions",
                      "options": [
                        "GET"
                      ],
                      "total": 1,
                      "current_uri": "/videos/396364131/versions/298758249",
                      "resource_key": "b221752c11011613055e235aa4d66e3f97c3bc7b"
                    }
                  },
                  "interactions": {
                    "watchlater": {
                      "uri": "/users/109008672/watchlater/396364131:dd374c2b36",
                      "options": [
                        "GET",
                        "PUT",
                        "DELETE"
                      ],
                      "added": false,
                      "added_time": null
                    },
                    "report": {
                      "uri": "/videos/396364131/report",
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
                        "total": 3
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
                        "view": "unlisted",
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
                  "active": true,
                  "link": "https://vimeo.com/user109008672/review/396364131/93ad877cb5"
                },
                "parent_folder": null,
                "last_user_action_event_date": "2020-03-09T03:03:24+00:00",
                "files": [],
                "download": [
                  {
                    "quality": "source",
                    "type": "source",
                    "width": 1920,
                    "height": 1080,
                    "expires": "2020-03-09T06:03:50+00:00",
                    "link": "https://player.vimeo.com/play/1685778706?s=396364131_1583766230_a2e7779a46a16a0592a21ea39df1af6e&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&download=1&filename=Sales%2BTeamsource.mp4",
                    "created_time": "2020-03-09T03:03:24+00:00",
                    "fps": 23.980000000000000426325641456060111522674560546875,
                    "size": 14868351,
                    "md5": "054266cff6c0b1acefe56c15deaccb51"
                  }
                ],
                "app": {
                  "name": "Parallel Uploader",
                  "uri": "/apps/87099"
                },
                "status": "transcoding",
                "resource_key": "ad97cee233a0b24339c497b056dafb4870bc0576",
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
                  "status": "in_progress"
                }
              }
            }).then((val) {
            }).catchError((error) {
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

