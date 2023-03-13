import 'package:fedodo_micro/Components/postList.dart';
import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
    required this.scrollController,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return PostList(
      scrollController: scrollController,
      accessToken: accessToken,
      appTitle: appTitle,
      userId: userId,
      isInbox: true,
      noReplies: true,
      firstPage:
          "https://dev.fedodo.social/inbox/e287834b-0564-4ece-b793-0ef323344959/page/0", //TODO
    );
  }
}
